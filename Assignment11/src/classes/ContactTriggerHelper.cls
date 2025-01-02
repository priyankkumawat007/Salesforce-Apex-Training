/** 
 * Purpose          :   Handler Class of Trigger on contact object
 * 
 * Created by       :   Priyank Kumawat
 * 
 * Created Date     :   05-12-2024
 * 
 * Rivision Logs    :   V_1.0 - Created
**/
public class  ContactTriggerHelper extends TriggerHandler{
    public override void beforeInsert(){
        checkForEmailDomainNameWhenInsertingAndUpdating((List<Contact>)Trigger.new, (Map <Id, Contact>)Trigger.oldMap);
		validateIdDynamically((List<Contact>)Trigger.new, (Map <Id, Contact>)Trigger.oldMap);
		
    }
    public override void beforeUpdate(){
        checkForEmailDomainNameWhenInsertingAndUpdating((List<Contact>)Trigger.new, (Map <Id, Contact>)Trigger.oldMap);
		validateIdDynamically((List<Contact>)Trigger.new, (Map <Id, Contact>)Trigger.oldMap);
    }
    /**
    * Method Name  :   checkForEmailDomainNameWhenInsertingAndUpdating
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   Method to validate domain name in Email field of contact object based on custom field 'Domain' value 
                       whenever a contact record is getting insert or update. 
    *
    * return       :   void
    *
    * param        :   List<Contact> newContacts
    **/
    public static void checkForEmailDomainNameWhenInsertingAndUpdating(List<Contact> newListOfContacts, Map<Id, Contact> mapOfOldContacts){
	Set<Id> setOfContactId = new Set<Id>();
	for(Contact con : newListOfContacts){
            if(con.AccountId != null && con.Email != null){
                if(mapOfOldContacts == null || (mapOfOldContacts != null && mapOfOldContacts.get(con.Id).Email != con.Email)){
                    setOfContactId.add(con.AccountId);
                }
            }
        }
	Map<Id, Account> mapOfEachAccount = new Map<Id, Account>([SELECT Id, Name, Domain_Name__c 
								     FROM Account 
								     WHERE Id IN : setOfContactId]);
        for(Contact con : newListOfContacts){
		String EmailDomain = ' ';
            	if(!String.isBlank(con.Email)){
            		EmailDomain = getEmailDomain(con.Email);
            	}
            	if(mapOfEachAccount.get(con.AccountId) != null && mapOfEachAccount.get(con.AccountId).Domain_Name__c != EmailDomain
								  && mapOfEachAccount.get(con.AccountId).Domain_Name__c != null){
                	con.addError('Enter Correct Email');
            	}
         }
		
    }
    /**
    * Method Name  :   getEmailDomain
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   Method to get email domain. 
    *
    * return       :   String
    *
    * param        :   String email
    **/
    public static String getEmailDomain(String email) {
        String[] emailParts = email.split('@');
        if (emailParts.size() > 1) {
        	return emailParts[1];
        }
        return null;
    }
    
    /**
    * Method Name  :   validateIdDynamically
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   Method to validate the RecordId__c field in Contact objects and update related fields 
    *                  (Picklist_Fields__c and Object_Name__c) dynamically based on the object's metadata.
    *
    * return       :   void
    *
    * param        :   List<Contact> newListOfContact
    *                  Map<Id, Contact> mapOfContact
    **/
    public static void validateIdDynamically(List<Contact> newListOfContact, Map<Id,Contact> mapOfContact){
        for(Contact con :newListOfContact){
            if((mapOfContact == null && con.RecordId__c == null)||mapOfContact != null && mapOfContact.get(con.Id).RecordId__c == con.RecordId__c){
		return;
            }else{
		 con.Picklist_Fields__c = '';
                map<Id,String> mapAfterCheck = checkValidId(con.RecordId__c);
                String allPickList = '';
                if(!mapAfterCheck.isEmpty()){
                    for(String objectName : mapAfterCheck.values()){
                        list<String> pickListValues = fetchThePicklistValues(objectName);
                        if(pickListValues.isEmpty()){
                            return;
                        }
			  String textAreaValue = String.join(pickListValues, '\n');
                	  con.Picklist_Fields__c = textAreaValue;
                    }
                }
                if(!mapAfterCheck.isEmpty()){
                    con.Object_Name__c = mapAfterCheck.get(con.RecordId__c);
                }else{
		     con.addError('Id is Not Valid');
                    con.Object_Name__c = '';
                }
	     }
        }  
    }
	/**
    * Method Name  :   checkValidId
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   Method to validate if an Id belongs to a valid Salesforce object and return its metadata.
    *
    * return       :   Map<Id, String>
    *
    * param        :   Id ids
    **/
    public static Map<Id, String> checkValidId(Id ids) {
     	Map<Id, String> mapOfValidIds = new Map<Id, String>();
       	try{
            Schema.SObjectType sObjectType = ids.getSObjectType();
            if (!CheckRecordExist(sObjectType, ids)) {
                throw new DmlException('Invalid Id');
            }
            Schema.DescribeSObjectResult describeResult = sObjectType.getDescribe();
            mapOfValidIds.put(ids, describeResult.getName());
        }catch(Exception e){
            System.debug('Invalid Id' + e.getMessage());
        }
        return mapOfValidIds;
    } 	
    /**
    * Method Name  :   CheckRecordExist
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   Method to check if a record exists for a given Id in a Salesforce object.
    *
    * return       :   Boolean
    *
    * param        :   Schema.SObjectType obj
    *                  Id SObjectId
    **/
    public static Boolean CheckRecordExist(Schema.SObjectType obj, Id SObjectId){
	String query = 'SELECT ID FROM '+obj+' WHERE ID =: SObjectId';
       	List<SObject> sobj = Database.query(query);
       	if(!sobj.isEmpty()){
            return true;
       	} 
        return false;
    }
    /**
    * Method Name  :   fetchThePicklistValues
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   Method to fetch all picklist field names for a given Salesforce object dynamically.
    *
    * return       :   List<String>
    *
    * param        :   String objectName
    **/
	public static List<String> fetchThePicklistValues(String objectName){
       	List<String> pickListFieldList = new List<String>();
	Schema.DescribeSObjectResult objectResult = ((SObject)Type.forName(objectName).newInstance()).getSObjectType().getDescribe();
       	if(objectResult != null){
            map<String, Schema.SObjectField> fieldOfObject = objectResult.fields.getMap();
            for(String fieldName : fieldOfObject.keySet()){
                Schema.DescribeFieldResult fieldDescribe = fieldOfObject.get(fieldName).getDescribe();
                if(fieldDescribe.getType() == Schema.DisplayType.Picklist){
                    picklistFieldList.add(fieldName);
                }
            }
        }
	return pickListFieldList;
    }
}