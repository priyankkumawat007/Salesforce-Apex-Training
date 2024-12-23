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
    }
    public override void beforeUpdate(){
        checkForEmailDomainNameWhenInsertingAndUpdating((List<Contact>)Trigger.new, (Map <Id, Contact>)Trigger.oldMap);
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
        if(!newListOfContacts.isEmpty()){
		    Set<Id> setOfContactId = new Set<Id>();
            for(Contact con : newListOfContacts){
                if(mapOfOldContacts != null){
			if(con.Email == null){
                       	    return;
                	}
		}
                if(con.AccountId != null)
                    setOfContactId.add(con.AccountId);
            }
            Map<Id, Account> mapOfEachAccount = new Map<Id, Account>([SELECT Id, Name, Domain_Name__c 
                                                                    FROM Account 
                                                                    WHERE Id IN : setOfContactId]);
            for(Contact con : newListOfContacts){
                if(con.Email == null){
                    con.addError('Email not mentioned,please enter email with Correct domian name');
                }else{          
                    String EmailDomain = getEmailDomain(con.Email);
                    if(mapOfOldContacts != null){
                        if(mapOfEachAccount.get(con.AccountId).Domain_Name__c == null){
                            con.addError('Domain Name not mentioned in Account');
                        }
		    }
                    if(mapOfEachAccount.get(con.AccountId).Domain_Name__c != EmailDomain){
                    		con.addError('Domain Name Wrong');
                    }
                }
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
}