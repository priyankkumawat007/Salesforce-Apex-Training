/**
 * Purpose          :   Scheduled class to dynamically fetch metadata configuration, generate 
 *                      SOQL queries, and execute batch jobs for deleting old records.
 * 
 * Author           :   Priyank Kumawat
 * 
 * Created Date     :   02-01-2025
 * 
 * Revision Logs    :   V_1.0 - Created
 */
global without sharing class ScheduleDeleteOldRecordsBatch implements Schedulable{
    	private String obj;
    	private String fieldNameForQuery ='';
	public static Integer count = 0;
	/**
       * Method Name  :   execute
       * 
       * Created by   :   Priyank Kumawat
       * 
       * Purpose      :   Dynamically retrieves metadata configuration to generate SOQL queries and execute batch jobs.
       *                
       *
       * Return       :   void
       * 
       * Parameters   :   SchedulableContext sc
       **/
    	global void execute(SchedulableContext sc){
       	List<SObject> metadata = [SELECT Developer_Name__c,Duration__c,Filter__c FROM Archive_Config__mdt];
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
		Database.executeBatch(new DeleteOldRecordsBatch(query));
		count++;
        } 
    }
}