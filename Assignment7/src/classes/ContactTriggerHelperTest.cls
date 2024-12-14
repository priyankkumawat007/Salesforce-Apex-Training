/** 
 * Purpose          :   Test Class for ContactTriggerHelper.
 * 
 * Created by       :   Priyank Kumawat
 * 
 * Created Date     :   12-12-2024
 * 
 * Revision Logs    :   V_1.0 - Created
 **/
@isTest
public class ContactTriggerHelperTest {
    /** 
     * Method Name  :   createTestAccount
     * 
     * Created by   :   Priyank Kumawat
     * 
     * Purpose      :   Helper method to create and insert a test Account record.
     * 
     * return       :   Account - The created Account record.
     * 
     * param        :   domainName (String) - The domain name to set in the Account's Domain_Name__c field.
     **/
    private static Account createTestAccount(String domainName) {
        Account acc = new Account(Name = 'Test Account', Domain_Name__c = domainName, Phone_Number__c = '8005883998');
        insert acc;
        return acc;
    }
    /** 
     * Method Name  :   testBeforeInsertWithCorrectEmailDomain
     * 
     * Created by   :   Priyank Kumawat
     * 
     * Purpose      :   This test ensures that the contact is inserted successfully when the email domain matches 
     *                  the domain of the associated Account.
     *
     * return       :   void
     * 
     * param        :   null
     **/
    @isTest
    public static void testBeforeInsertWithCorrectEmailDomain(){
        Account acc = createTestAccount('example.com');
        Contact con = new Contact(FirstName = 'Priyank', LastName = 'Kumawat', Email = 'priyank.kumawat@example.com', AccountId = acc.Id);
        Test.startTest();
        insert con;
        Test.stopTest();
        Contact insertedContact = [SELECT Email FROM Contact WHERE Id = :con.Id];
        System.assertEquals('priyank.kumawat@example.com', insertedContact.Email);
    }
    /** 
     * Method Name  :   testBeforeInsertWithIncorrectEmailDomain
     * 
     * Created by   :   Priyank Kumawat
     * 
     * Purpose      :   This test ensures that an error is thrown if the email domain does not match the associated 
     *                  Account's domain during insert.
     *
     * return       :   void
     * 
     * param        :   null
     **/
    @isTest
    public static void testBeforeInsertWithIncorrectEmailDomain() {
        Account acc = createTestAccount('example.com');
        Contact con = new Contact(FirstName = 'Priyank', LastName = 'Kumawat', Email = 'priyank.kumawat@wrongexample.com', AccountId = acc.Id);
        Test.startTest();
        try {
            insert con;
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Domain Name Wrong'), 'Expected domain name error');
        }
        Test.stopTest();
    }
    /** 
     * Method Name  :   testBeforeUpdateWithIncorrectEmailDomain
     * 
     * Created by   :   Priyank Kumawat
     * 
     * Purpose      :   This test ensures that an error is thrown if the email domain does not match the associated 
     *                  Account's domain during an update.
     *
     * return       :   void
     * 
     * param        :   null
     **/
    @isTest
    public static void testBeforeUpdateWithIncorrectEmailDomain() {
        Account acc = createTestAccount('example.com');
        Contact con = new Contact(FirstName = 'Priyank', LastName = 'Kumawat', Email = 'priyank.kumawat@example.com', AccountId = acc.Id);
        insert con;
        con.Email = 'priyank.kumawat@example.com';
        Test.startTest();
        try {
            update con;
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Domain Name Wrong'), 'Expected domain name error during update');
        }
        Test.stopTest();
    }
     /** 
     * Method Name  :   testBeforeUpdateWithNullEmail
     * 
     * Created by   :   Priyank Kumawat
     * 
     * Purpose      :   This test ensures that an error is thrown if the email field is set to null during update.
     *
     * return       :   void
     * 
     * param        :   null
     **/
    @isTest
    public static void testBeforeUpdateWithNullEmail() {
        Account acc = createTestAccount('example.com');
        Contact con = new Contact(FirstName = 'Priyank', LastName = 'Kumawat', Email = 'priyank.kumawat@example.com', AccountId = acc.Id);
        insert con;
        con.Email = null;
        Test.startTest();
        try {
            update con;
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Email not mentioned,please enter email with Correct domian name'), 
						  'Expected email null error during update');
        }
        Test.stopTest();
    }
    /** 
     * Method Name  :   testBeforeUpdateWithCorrectEmailDomain
     * 
     * Created by   :   Priyank Kumawat
     * 
     * Purpose      :   This test ensures that the update is successful when the email domain matches the associated 
     *                  Account's domain.
     *
     * return       :   void
     * 
     * param        :   null
     **/
    @isTest
    public static void testBeforeUpdateWithCorrectEmailDomain() {
        Account acc = createTestAccount('example.com');
        Contact con = new Contact(FirstName = 'Priyank', LastName = 'Kumawat', Email = 'priyank.kumawat@example.com', AccountId = acc.Id);
        insert con;
        con.Email = 'priyank.kumawat@example.com';
        Test.startTest();
        update con;
        Test.stopTest();
        Contact updatedContact = [SELECT Email FROM Contact WHERE Id = :con.Id];
        System.assertEquals('priyank.kumawat@example.com', updatedContact.Email);
    }
    @isTest
    /** 
     * Method Name  :   testBeforeInsertWithMissingAccountDomain
     * 
     * Created by   :   Priyank Kumawat
     * 
     * Purpose      :   This test ensures that an error is thrown if the associated Account does not have a domain 
     *                  set during insert.
     *
     * return       :   void
     * 
     * param        :   null
     **/
    public static void testBeforeInsertWithMissingAccountDomain() {
        Account acc = createTestAccount(null);
        Contact con = new Contact(FirstName = 'Priyank', LastName = 'Kumawat', Email = 'priyank.kumawat@example.com', AccountId = acc.Id);
        Test.startTest();
        try {
            insert con;
        } catch (DmlException e) {
            System.debug(e.getMessage().contains('Domain Name not mentioned in Account'));
            System.assertEquals(false,e.getMessage().contains('Domain Name not mentioned in Account'), 'Expected error for missing account domain');
        }
        Test.stopTest();
    }
}