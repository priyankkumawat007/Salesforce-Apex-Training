/** 
* Purpose          :   Handler Class of Trigger on Attendee__c object
* 
* Created by       :   Priyank Kumawat
* 
* Created Date     :   08-12-2024
* 
* Revision Logs    :   V_1.0 - Created
**/
public without sharing class AttendeeTriggerHelper extends TriggerHandler{

    public override void afterInsert(){
        updateNoOfSessionsOnContact((List<Attendee__c>)Trigger.new, (Map <Id, Attendee__c>)Trigger.oldMap);
    }
    public override void afterUpdate(){
        updateNoOfSessionsOnContact((List<Attendee__c>)Trigger.new, (Map <Id, Attendee__c>)Trigger.oldMap);
    }
    public override void afterDelete(){
        updateNoOfSessionsOnContact((List<Attendee__c>)Trigger.new, (Map <Id, Attendee__c>)Trigger.oldMap);
    }

    /**
    * Method Name  :   updateNoOfSessionsOnContact
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   Updates the 'No. Of Attended Training Session' field on the Contact object
    *                  according to the number of sessions that the contact is enrolled in.
    *
    * return       :   void
    *
    * param        :   List<Attendee__c> newListOfAttendee, Map<Id, Attendee__c> mapOfOldAttendies
    **/
    public static void updateNoOfSessionsOnContact(List<Attendee__c> newListOfAttendee, Map<Id, Attendee__c> mapOfOldAttendies) {
        Set<Id> contactIds = new Set<Id>();
        for (Attendee__c att : newListOfAttendee != null ? newListOfAttendee : mapOfOldAttendies.values()) {
            if (newListOfAttendee != null || mapOfOldAttendies != null) {
                if (att.Contact__c != null) {
                    contactIds.add(att.Contact__c);
                }
            }
            if (mapOfOldAttendies != null && mapOfOldAttendies.get(att.id).Contact__c != null && att.Contact__c != mapOfOldAttendies.get(att.id).Contact__c){
                contactIds.add(mapOfOldAttendies.get(att.id).Contact__c);
            }
        }
        if (contactIds.isEmpty()) return;
        List<Attendee__c> listOfAttendee = [SELECT Id, Contact__c, Training_Session_Name__c 
                                            FROM Attendee__c  
                                            WHERE Contact__c IN :contactIds];
        Map<Id, Set<Id>> contactSessionMap = new Map<Id, Set<Id>>();
        for (Attendee__c att : listOfAttendee) {
            if (att.Contact__c != null) {
                if (!contactSessionMap.containsKey(att.Contact__c)) {
                    contactSessionMap.put(att.Contact__c, new Set<Id>());
                }
                contactSessionMap.get(att.Contact__c).add(att.Training_Session_Name__c); 
            }
        }
        List<Contact> contactsToUpdate = new List<Contact>();
        for (Id contactId : contactSessionMap.keySet()) {
            contactsToUpdate.add(new Contact(Id = contactId, Number_of_Sessions__c = contactSessionMap.get(contactId).size()));
        }
        if (mapOfOldAttendies != null) {
            for (Attendee__c att : mapOfOldAttendies.values()) {
                if (att.Contact__c != null && contactSessionMap.containsKey(att.Contact__c)) {
                    Set<Id> sessions = contactSessionMap.get(att.Contact__c);
                    sessions.remove(att.Training_Session_Name__c);
                    if (sessions.isEmpty()) {
                        sessions.add(null); 
                    }
                }
            }
        }
        for (Id contactId : contactIds) {
            if(!contactSessionMap.containsKey(contactId)){
                contactsToUpdate.add(new Contact(Id = contactId, Number_of_Sessions__c = 0));
            }
        }
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        } 
    }
}