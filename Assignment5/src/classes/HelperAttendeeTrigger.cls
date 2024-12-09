/** 
 * Purpose          :   Handler Class of Trigger on Attendee__c object
 * 
 * Created by       :   Priyank Kumawat
 * 
 * Created Date     :   08-12-2024
 * 
 * Rivision Logs    :   V_1.0 - Created
**/
public without sharing class HelperAttendeeTrigger {
    /**
    * Method Name  :   updateNoOfSessionsOnContact
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   Method will update 'No. Of Attended Training Session' field on contact object according to the  
                       number of session that contact is enrolled.
    *
    * return       :   void
    *
    * param        :   List<Attendee__c> newListOfAttendee, Map<Id, Attendee__c> mapOfOldAttendies
    **/
    public static void updateNoOfSessionsOnContact(List<Attendee__c> newListOfAttendee, Map<Id, Attendee__c> mapOfOldAttendies) {
        if( (newListOfAttendee != null && mapOfOldAttendies != null) || (newListOfAttendee != null)){
            Set<Id> setOfIds = new Set<Id>();
            for(Attendee__c att : newListOfAttendee) {
                if(att.Contact__c != null){
                    setOfIds.add(att.Contact__c);
                }
            }
            List<Attendee__c> listOfAttendee = [SELECT Id, Contact__c, Training_Session_Name__c 
                                                FROM Attendee__c  
                                                WHERE Contact__c IN :setOfIds];
            Map<Id, Set<Id>> mapOfContactIdAndTrainingSessions = new Map<Id, Set<Id>>();
            for(Attendee__c att : listOfAttendee) {
                if(att.Contact__c != null){
                        if(!mapOfContactIdAndTrainingSessions.containsKey(att.Contact__c)){
                            mapOfContactIdAndTrainingSessions.put(att.Contact__c, new Set<Id>());
                        }
                    mapOfContactIdAndTrainingSessions.get(att.Contact__c).add(att.Training_Session_Name__c);
                }
            }
            List<Contact> contactsToUpdate = new List<Contact>();
            for (Id contactId : mapOfContactIdAndTrainingSessions.keySet()) {
                 Contact con = new Contact(
                 	Id = contactId, Number_of_Sessions__c = (!mapOfContactIdAndTrainingSessions.get(contactId).isEmpty() 
        			                 ? mapOfContactIdAndTrainingSessions.get(contactId).size() : 0));
		 contactsToUpdate.add(con);
            }
            if (!contactsToUpdate.isEmpty()) {
                update contactsToUpdate;
            }
        }
        if((mapOfOldAttendies != null && newListOfAttendee != null) || (mapOfOldAttendies != null)){
            for(Id AttendeeId : mapOfOldAttendies.keySet()){
                if(mapOfOldAttendies.get(AttendeeId).Contact__c == null){
                    return;
                }
            }
            Set<Id> setOfIds = new Set<Id>();
            for (Attendee__c att : mapOfOldAttendies.values()) {
                if (att.Contact__c != null) {
                    setOfIds.add(att.Contact__c);
                }
            }
            List<Attendee__c> listOfAttendee = [SELECT Id, Contact__c, Training_Session_Name__c 
                                                FROM Attendee__c  
                                                WHERE Contact__c IN :setOfIds];
            List<Contact> contactsToUpdate = new List<Contact>();
            if (listOfAttendee.size()==0) {
				for(Id AttendeeId : mapOfOldAttendies.keySet()){
                    System.debug(AttendeeId);
                    Contact con = new Contact(Id =mapOfOldAttendies.get(AttendeeId).Contact__c, Number_of_Sessions__c = 0.00);
                    System.debug(con);
                    contactsToUpdate.add(con);
                }
            }else{
                Map<Id, Set<Id>> mapOfContactIdAndTrainingSessions = new Map<Id, Set<Id>>();
                for (Attendee__c att : listOfAttendee) {    
                     if (att.Contact__c != null) {
                         if (!mapOfContactIdAndTrainingSessions.containsKey(att.Contact__c)) {
                             mapOfContactIdAndTrainingSessions.put(att.Contact__c, new Set<Id>());
                         }
                         mapOfContactIdAndTrainingSessions.get(att.Contact__c).add(att.Training_Session_Name__c);
                     }
                }
                    for (Id contactId : mapOfContactIdAndTrainingSessions.keySet()) {
                        Set<Id> trainingSessions = mapOfContactIdAndTrainingSessions.get(contactId);
                        for (Attendee__c att : mapOfOldAttendies.values()) {
                            if (att.Contact__c == contactId) {
                                trainingSessions.remove(att.Training_Session_Name__c);
                            }
                        }
                        if (trainingSessions.size() != null) {
                            Contact con = new Contact(Id = contactId, Number_of_Sessions__c = (!trainingSessions.isEmpty() 
        							                               ? trainingSessions.size() : 0));
                            contactsToUpdate.add(con);
                        }
                    }
                } 
            if (!contactsToUpdate.isEmpty()) {
                update contactsToUpdate;
            }
	}
    }
}