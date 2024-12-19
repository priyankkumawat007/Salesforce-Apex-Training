/** 
* Purpose          :   Test Class for AccountProcessor Class.
* 
* Created by       :   Priyank Kumawat
* 
* Created Date     :   17-12-2024
* 
* Revision Logs    :   V_1.0 - Created
**/
@isTest
public without sharing class AccountProcessorTest {
    /** 
    * Method Name  :   createTestData
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   Method to create sample data for testing.
    * 
    * return       :   @void
    * 
    * param        :   null
    **/
	@TestSetup
	static void createTestData(){
	Account acc1 = new Account(Name = 'Test Account1', Domain_Name__c = 'example.com', Phone_Number__c = '8005883998');
        Account acc2 = new Account(Name = 'Test Account2', Domain_Name__c = 'example.com', Phone_Number__c = '8005883990');
        insert new List<Account>{acc1, acc2};
            
        Contact con1 = new Contact(FirstName = 'Priyank', LastName = 'Kumawat', Email = 'priyank.kumawat@example.com', AccountId = acc1.Id);
        Contact con2 = new Contact(FirstName = 'Spider', LastName = 'Man', Email = 'spider.man@example.com', AccountId = acc1.Id);
        Contact con3 = new Contact(FirstName = 'Bat', LastName = 'Man', Email = 'bat.man@example.com', AccountId = acc2.Id);
        insert new List<Contact>{con1, con2, con3};
    }
    /** 
    * Method Name  :   testNumberOfRelatedContact
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   Method to test count of related contact to the specific account is correct or not.
    * 
    * return       :   @void
    * 
    * param        :   null
    **/
    @isTest
    private static void testNumberOfRelatedContact(){
        List<Contact> listOfAccount = [SELECT Id, AccountId, LastName FROM Contact WHERE LastName = 'Kumawat']; 
	List<Id> accountsToPass = new List<Id>(); 
        accountsToPass.add(listOfAccount[0].AccountId); 
        
        Test.startTest(); 
        AccountProcessor.countContacts(accountsToPass); 
        Test.stopTest();
        
        Account acc = [SELECT Id, Name, Number_Of_Contacts__c FROM Account WHERE Id = :listOfAccount[0].AccountId];
        Assert.areEqual(2, acc.Number_Of_Contacts__c, 'Number of Contact Should be 2');
    }
}