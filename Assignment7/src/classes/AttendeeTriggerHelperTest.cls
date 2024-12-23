/** 
* Purpose          :   Test Class of HelperAttendeeTrigger.
* 
* Created by       :   Priyank Kumawat
* 
* Created Date     :   12-12-2024
* 
* Revision Logs    :   V_1.0 - Created
**/
@isTest
private class AttendeeTriggerHelperTest {
    /**
    * Method Name  :   testAfterInsert
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   This test ensure the logic correctly updates the Number_of_Sessions__c field based on 
    *                  associated Attendee__c records on every Possible insert.
    *
    * return       :   void
    *
    * param        :   null
    **/
    @isTest
    static void testAfterInsert() {
        Contact contact1 = new Contact(FirstName = 'Priyank', LastName = 'Kumawat');
        Contact contact2 = new Contact(FirstName = 'Sajal', LastName = 'Mittal');
        insert new List<Contact>{contact1, contact2};

        Training_Session__c trainingSession1 = new Training_Session__c(Name = 'Session 1');
        Training_Session__c trainingSession2 = new Training_Session__c(Name = 'Session 2');
        insert new List<Training_Session__c>{trainingSession1, trainingSession2};

        Attendee__c attendee1 = new Attendee__c(Contact__c = contact1.Id, Training_Session_Name__c = trainingSession1.id);
        Attendee__c attendee2 = new Attendee__c(Contact__c = contact1.Id, Training_Session_Name__c = trainingSession2.id);
        Attendee__c attendee3 = new Attendee__c(Contact__c = contact2.Id, Training_Session_Name__c = trainingSession1.id);
        insert new List<Attendee__c>{attendee1, attendee2, attendee3};

        contact1 = [SELECT Id, Number_of_Sessions__c FROM Contact WHERE Id = :contact1.Id];
        contact2 = [SELECT Id, Number_of_Sessions__c FROM Contact WHERE Id = :contact2.Id];

        System.assertEquals(2, contact1.Number_of_Sessions__c, 'Contact 1 should have 2 sessions');
        System.assertEquals(1, contact2.Number_of_Sessions__c, 'Contact 2 should have 1 session');
    }
    /**
    * Method Name  :   testAfterUpdate
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   This test ensure the logic correctly updates the Number_of_Sessions__c field based on 
    *                  associated Attendee__c records on every Possible updates.
    *
    * return       :   void
    *
    * param        :   null
    **/
    @isTest
    static void testAfterUpdate() {
        Contact contact1 = new Contact(FirstName = 'Priyank', LastName = 'Kumawat');
        Contact contact2 = new Contact(FirstName = 'Sajal', LastName = 'Mittal');
        insert new List<Contact>{contact1, contact2};
            
        Training_Session__c trainingSession1 = new Training_Session__c(Name = 'Session 1');
        Training_Session__c trainingSession2 = new Training_Session__c(Name = 'Session 2');
		Training_Session__c trainingSession3 = new Training_Session__c(Name = 'Session 3');
        insert new List<Training_Session__c>{trainingSession1, trainingSession2, trainingSession3};
      
        Attendee__c attendee1 = new Attendee__c(Contact__c = contact1.Id, Training_Session_Name__c = trainingSession1.id);
        Attendee__c attendee2 = new Attendee__c(Contact__c = contact1.Id, Training_Session_Name__c = trainingSession2.id);
        Attendee__c attendee3 = new Attendee__c(Contact__c = contact2.Id, Training_Session_Name__c = trainingSession1.id);
        insert new List<Attendee__c>{attendee1, attendee2, attendee3};
        
		attendee1.Contact__c = contact2.Id;
        update attendee1;
        
		contact1 = [SELECT Id, Number_of_Sessions__c FROM Contact WHERE Id = :contact1.Id];
        contact2 = [SELECT Id, Number_of_Sessions__c FROM Contact WHERE Id = :contact2.Id];

        System.assertEquals(1, contact1.Number_of_Sessions__c, 'Contact 1 should have 2 sessions after update');
        System.assertEquals(1, contact2.Number_of_Sessions__c, 'Contact 2 should have 1 session after update');
    }
    /**
    * Method Name  :   testAfterDelete
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   This test ensure the logic correctly updates the Number_of_Sessions__c field based on 
    *                  associated Attendee__c records on every Possible delete.
    *
    * return       :   void
    *
    * param        :   null
    **/
    @isTest
    static void testAfterDelete() {
        Contact contact1 = new Contact(FirstName = 'Priyank', LastName = 'Kumawat');
        Contact contact2 = new Contact(FirstName = 'Sajal', LastName = 'Mittal');
        insert new List<Contact>{contact1, contact2};

        Training_Session__c trainingSession1 = new Training_Session__c(Name = 'Session 1');
        Training_Session__c trainingSession2 = new Training_Session__c(Name = 'Session 2');
        insert new List<Training_Session__c>{trainingSession1, trainingSession2};

        Attendee__c attendee1 = new Attendee__c(Contact__c = contact1.Id, Training_Session_Name__c = trainingSession1.id);
        Attendee__c attendee2 = new Attendee__c(Contact__c = contact1.Id, Training_Session_Name__c = trainingSession2.id);
        Attendee__c attendee3 = new Attendee__c(Contact__c = contact2.Id, Training_Session_Name__c = trainingSession1.id);
        insert new List<Attendee__c>{attendee1, attendee2, attendee3};

        delete attendee2;

        contact1 = [SELECT Id, Number_of_Sessions__c FROM Contact WHERE Id = :contact1.Id];
        contact2 = [SELECT Id, Number_of_Sessions__c FROM Contact WHERE Id = :contact2.Id];

        System.assertEquals(1, contact1.Number_of_Sessions__c, 'Contact 1 should have 1 session after delete');
        System.assertEquals(1, contact2.Number_of_Sessions__c, 'Contact 2 should have 1 session after delete');
		
		delete attendee1;
		contact1 = [SELECT Id, Number_of_Sessions__c FROM Contact WHERE Id = :contact1.Id];
		System.assertEquals(0, contact1.Number_of_Sessions__c, 'Contact 1 should have 0 session after delete');

    }
    /**
    * Method Name  :   testEmptyContactRecords
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   This test ensure the logic correctly updates the Number_of_Sessions__c field based on 
    *                  associated Attendee__c records on empty values.
    *
    * return       :   void
    *
    * param        :   null
    **/
    @isTest
    static void testEmptyContactRecords() {
        Contact contact1 = new Contact(FirstName = 'Priyank', LastName = 'Kumawat');
        insert new List<Contact>{contact1};
		List<Attendee__c> emptyAttendees = new List<Attendee__c>();

        Test.startTest();
        HelperAttendeeTrigger.updateNoOfSessionsOnContact(emptyAttendees, null);
        Test.stopTest();

        contact1 = [SELECT Id, Number_of_Sessions__c FROM Contact WHERE Id = :contact1.Id];
        System.assertEquals(null, contact1.Number_of_Sessions__c, 'Contact should have 0 sessions when there are no attendees');
    } 
}