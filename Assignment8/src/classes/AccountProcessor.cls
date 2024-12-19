/** 
 * Purpose          :   Class have AccountProcessor which takes the accountId and update number of contact related to that acccount on account Obj.
 * 
 * Created by       :   Priyank Kumawat
 * 
 * Created Date     :   17-12-2024
 * 
 * Rivision Logs    :   V_1.0 - Created
**/
public without sharing class AccountProcessor {
	/**
    * Method Name  :   countContacts
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   Method to update number of contact on account object. 
    *
    * return       :   void
    *
    * param        :   List<Id> accountIds
    **/
    @future
    public static void countContacts(List<Id> accountIds) {
        List<Contact> contacts = [Select Id, Name, AccountId from Contact Where AccountId IN :accountIds];
        map<Id, List<Contact>> mapOfAccountIdAndContact = new map<Id, List<Contact>>();
        for(Contact con : contacts){
            if(!mapOfAccountIdAndContact.ContainsKey(con.AccountId)){
                mapOfAccountIdAndContact.put(con.AccountId,new List<Contact>());
            }
            mapOfAccountIdAndContact.get(con.AccountId).add(con);	
        }
        List<Account> updateAccounts = new List<Account>();
        for(Contact con : contacts){
            Account acc = new Account();
            acc.Id = con.AccountId;
            acc.Number_Of_Contacts__c = mapOfAccountIdAndContact.get(con.AccountId).size();
            if(!updateAccounts.Contains(acc)){
                updateAccounts.add(acc);  
            }
        }
        if(!updateAccounts.isEmpty()){
            try{
                update updateAccounts;
            }catch(exception e){
                System.debug(e.getMessage());
            } 
        }
	}
}