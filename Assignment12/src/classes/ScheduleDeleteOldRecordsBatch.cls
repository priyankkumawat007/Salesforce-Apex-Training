global without sharing class ScheduleDeleteOldRecordsBatch implements Schedulable{
    private String obj;
    private String fieldNameForQuery ='';
	public static Integer count = 0;
    global void execute(SchedulableContext sc){
        List<SObject> metadata = [SELECT Developer_Name__c,Duration__c,Filter__c FROM Archive_Config__mdt];
		System.debug(metadata);
        for(SObject  eachObj : metadata){
            fieldNameForQuery = '';
            Decimal duration = (Decimal)eachObj.get('Duration__c');
            String developerName = (String)eachObj.get('Developer_Name__c');
            String filter = (String)eachObj.get('Filter__c');
            Schema.SObjectType SObjectInstance = ((SObject)Type.forName(developerName).newInstance()).getSObjectType();
            Map<String, Schema.SObjectField> fieldMapForDeveloperName = SObjectInstance.getDescribe().fields.getMap();
            for (Schema.SObjectField eachObjField : fieldMapForDeveloperName.values()) {
                Schema.DescribeFieldResult fieldResult = eachObjField.getDescribe();
                if(fieldResult.isAccessible()){
                    fieldNameForQuery += fieldResult.getName()+ ', ';
                }
            }
            fieldNameForQuery= fieldNameForQuery.substring(0,fieldNameForQuery.lastIndexOf(', '));
            String query = 'SELECT ' +fieldNameForQuery+ ' FROM ' +developerName+ 
                           ' WHERE '+filter+ ' AND CreatedDate >= LAST_N_DAYS:'+ duration;
			System.debug(query);
			Database.executeBatch(new DeleteOldRecordsBatch(query));
			count++;
        } 
    }
}