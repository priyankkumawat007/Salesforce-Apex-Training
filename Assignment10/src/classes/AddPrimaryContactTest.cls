/** 
* Purpose          :   Test Class of AddPrimaryContact.
* 
* Created by       :   Priyank Kumawat
* 
* Created Date     :   12-12-2024
* 
* Revision Logs    :   V_1.0 - Created
**/
@istest
public class AddPrimaryContactTest {
    /**
    * Method Name  :   createTestData
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   Creating the Sample Data.    
    *
    * return       :   void
    *
    * param        :   null
    **/
    @testSetup
    public static void createTestData(){
	List<Account> listOfAcc = new List<Account>();
        for(Integer i=1;i<=50;i++){
            Account acc = new Account();
	    acc.Name = 'Account '+ i;
	    acc.BillingState = 'BillingState CA';
	    acc.Phone_Number__c = '6039084423';
	    listOfAcc.add(acc);
        }
	for(Integer i=51;i<=100;i++){
            Account acc = new Account();
		acc.Name = 'Account '+ i;
		acc.BillingState = 'BillingState NY';
		acc.Phone_Number__c = '6039084420';
		listOfAcc.add(acc);
        }
        if(!listOfAcc.isEmpty()){
            insert listOfAcc;
        }
    }
    /**
    * Method Name  :   testIsContactCreated
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   Method to test the working of AddPrimaryContact.    
    *
    * return       :   void
    *
    * param        :   null
    **/
    @isTest
    public static void testIsContactCreated(){
	Contact con = new Contact();
        con.LastName = 'Test Contact';
        Insert con;
        Test.startTest();
	System.enqueueJob(new AddPrimaryContact(con, 'BillingState CA'));
	Test.stopTest();
	List<Contact> listOfCon = [Select Id, LastName, AccountId FROM Contact WHERE LastName = 'Test Contact'];
	System.assertEquals(51, listOfCon.size(), 'There should be 50 contacts inserted for CA Accounts'); 	
	System.assertEquals('Test Contact', listOfCon[0].LastName, 'Name is not same'); 	
    }
}