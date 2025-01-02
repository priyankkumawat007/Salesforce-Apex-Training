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
     * Method Name  :   createTestAccount(Not a Test Method)
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
        	try {
            	insert con;
        	} catch (DmlException e) {
            	System.debug(e.getMessage());
        	}
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
            System.assert(e.getMessage().contains('Enter Correct Email'), 'Expected domain name error');
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
            System.assert(e.getMessage().contains('Email not mentioned,please enter email with Correct domian name'), 'Expected email null error during update');
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
       		try {
            	update con;
        	} catch(DmlException e) {
            	System.debug(e.getMessage());
        	}
        Test.stopTest();
        Contact updatedContact = [SELECT Email FROM Contact WHERE Id = :con.Id];
        System.assertEquals('priyank.kumawat@example.com', updatedContact.Email);
    }
   
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
	 @isTest
    public static void testBeforeInsertWithMissingAccountDomain() {
        Account acc = createTestAccount(null);
        Contact con = new Contact(FirstName = 'Priyank', LastName = 'Kumawat', Email = 'priyank.kumawat@example.com', AccountId = acc.Id);
        Test.startTest();
            try {
                insert con;
            }catch (DmlException e) {
                System.debug(e.getMessage().contains('Domain Name not mentioned in Account'));
                System.assertEquals(false,e.getMessage().contains('Domain Name not mentioned in Account'), 'Expected error for missing account domain');
            }
        Test.stopTest();
    }
	/**
     * Method Name  :   testValidateIdDynamicallyWithValidId
     * 
     * Created by   :   Priyank Kumawat
     * 
     * Purpose      :   This test ensures that the fields `Picklist_Fields__c` and `Object_Name__c` 
     *                  are updated correctly when a valid `RecordId__c` is provided.
     *
     * return       :   void
     * 
     * param        :   null
     **/
    @isTest
    static void testValidateIdDynamicallyWithValidId() {
        Account testAccount = new Account(Name = 'Test Account', Phone_Number__c ='6039084423');
        insert testAccount;

        Contact testContact = new Contact(
            LastName = 'Test Contact',
            RecordId__c = testAccount.Id
        );
		Test.startTest();
            insert testContact;
            testContact.RecordId__c = testAccount.Id;
            update testContact;
		Test.stopTest();
        Contact updatedContact = [SELECT Picklist_Fields__c, Object_Name__c FROM Contact WHERE Id = :testContact.Id];
        System.assertNotEquals('', updatedContact.Picklist_Fields__c, 'Picklist_Fields__c should not be empty');
        System.assertEquals('Account', updatedContact.Object_Name__c, 'Object_Name__c should be Account');
    }
	 /**
     * Method Name  :   testValidateIdDynamicallyWithInvalidId
     * 
     * Created by   :   Priyank Kumawat
     * 
     * Purpose      :   This test ensures that an error is thrown if an invalid `RecordId__c` is provided 
     *                  during the insert operation.
     *
     * return       :   void
     * 
     * param        :   null
     **/
    @isTest
    static void testValidateIdDynamicallyWithInvalidId() {
        Contact invalidContact = new Contact(
            LastName = 'Invalid Contact',
            RecordId__c = '003NS00100O4273YAB'
        );

        Test.startTest();
            try{
                insert invalidContact;
                System.assert(false, 'Expected a DML exception due to invalid RecordId__c');
            }catch (DmlException e) {
                System.assert(e.getMessage().contains('Id is Not Valid'), 'Exception message should indicate invalid Id');
            }
        Test.stopTest();
    }
	/**
     * Method Name  :   testFetchThePicklistValues
     * 
     * Created by   :   Priyank Kumawat
     * 
     * Purpose      :   This test ensures that the method `fetchThePicklistValues` returns the correct 
     *                  list of picklist field names for a given object.
     *
     * return       :   void
     * 
     * param        :   null
     **/
    @isTest
    static void testFetchThePicklistValues(){
		Test.startTest();
        	List<String> picklistFields = ContactTriggerHelper.fetchThePicklistValues('Account');
		Test.stopTest();
        System.assert(!picklistFields.isEmpty(), 'Picklist fields should not be empty');
    }
	/**
     * Method Name  :   testCheckValidId
     * 
     * Created by   :   Priyank Kumawat
     * 
     * Purpose      :   This test ensures that the method `checkValidId` correctly validates a valid Salesforce 
     *                  object Id and returns the associated object name.
     *
     * return       :   void
     * 
     * param        :   null
     **/
    @isTest
    static void testCheckValidId() {
        Account testAccount = new Account(Name = 'Test Account', Phone_Number__c ='6039084423');
        insert testAccount;
		Test.startTest();
        	Map<Id, String> validIdMap = ContactTriggerHelper.checkValidId(testAccount.Id);
		Test.stopTest();
        System.assert(!validIdMap.isEmpty(), 'ValidIdMap should not be empty for a valid Id');
        System.assertEquals('Account', validIdMap.get(testAccount.Id), 'ValidIdMap should contain "Account" as the object name');
    }
    
	/**
     * Method Name  :   testCheckRecordExist
     * 
     * Created by   :   Priyank Kumawat
     * 
     * Purpose      :   This test ensures that the method `CheckRecordExist` correctly checks the existence of a 
     *                  record for a given Salesforce object Id.
     *
     * return       :   void
     * 
     * param        :   null
     **/
    @isTest
    static void testCheckRecordExist() {
        Account testAccount = new Account(Name = 'Test Account', Phone_Number__c ='6039084423');
        insert testAccount;
		Test.startTest();
        	Boolean recordExists = ContactTriggerHelper.CheckRecordExist(Schema.Account.SObjectType, testAccount.Id);
		Test.stopTest();
        System.assert(recordExists, 'Record should exist for the given Id');
        Boolean recordDoesNotExist = ContactTriggerHelper.CheckRecordExist(Schema.Account.SObjectType, '003NS00100O4273YAB');
        System.assert(!recordDoesNotExist, 'Record should not exist for an invalid Id');
    }
	 /**
     * Method Name  :   testTriggerWithMultipleContacts
     * 
     * Created by   :   Priyank Kumawat
     * 
     * Purpose      :   This test ensures that the trigger handles bulk operations correctly when multiple 
     *                  contacts are inserted or updated.
     *
     * return       :   void
     * 
     * param        :   null
     **/
    @isTest
    static void testTriggerWithMultipleContacts() {
        Account testAccount = new Account(Name = 'Test Account', Phone_Number__c ='6039084423');
        insert testAccount;
        List<Contact> contacts = new List<Contact>{
            new Contact(LastName = 'Contact 1', RecordId__c = testAccount.Id),
            new Contact(LastName = 'Contact 2', RecordId__c = testAccount.Id)
        };
		Test.startTest();
            insert contacts;
                for (Contact contact : contacts) {
                    contact.RecordId__c = testAccount.Id;
                }
            update contacts;
		Test.stopTest();
        List<Contact> updatedContacts = [SELECT Picklist_Fields__c, Object_Name__c FROM Contact WHERE Id IN :contacts];
        for (Contact contact : updatedContacts) {
            System.assertNotEquals('', contact.Picklist_Fields__c, 'Picklist_Fields__c should not be empty');
            System.assertEquals('Account', contact.Object_Name__c, 'Object_Name__c should be Account');
        }
    }
}