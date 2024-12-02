/** 
    * Purpose: (Assignment 2) Class To Perform Create, Read, Update, Delete on Training_Session__c.
    * Created by: Priyank Kumawat
    * Created Date: 27-11-24
    * Revision Log: V:1.1
**/
public with sharing class TrainingSessionManager {
    public enum Sessions {WEBINAR , WORKSHOP , SEMINAR}
    
    /**
        * Adds attendees to a training session and use of enum Sessions.
        * @param  sessionName of the Training_Session__c record.
        * @param  date of the training sesstion.
        * @param  location of the training session.
        * @param  noOfSesstion of the training session.
        * @throws Error During Insertion:
    **/
    public static void createRecordForTrainingSession(String sessionName, Sessions typeOfSession,
                                                      String dateOfSesstion, String location, Integer noOfSesstion
                                                      ){
        Date dateInFormat = Date.valueOf(dateOfSesstion);
        List<Training_Session__c> newTrainingSessions = new List<Training_Session__c>();
        Training_Session__c newTraining = new Training_Session__c();
        newTraining.Name = sessionName;
        newTraining.Session_Date__c = dateInFormat;
        newTraining.Number_of_Sessions__c = noOfSesstion;
        newTraining.Mode_of_Session__c = typeOfSession.name();
        if(typeOfSession == TrainingSessionManager.Sessions.WORKSHOP){
            newTraining.Location__c = 'Online Workshop';
        }else{
            newTraining.Location__c = location;
        }
        newTrainingSessions.add(newTraining);
        try {
            insert newTrainingSessions;
        } catch (Exception e) {
            System.debug('Error During Insertion: ' + e.getMessage());
        }
    }

    /**
        * Creates and inserts multiple training session records into the database.
        * This method generates 10 training sessions with unique names (e.g., Java0, Java1, etc.) 
        * and inserts them into the `Training_Session__c` object. The method also includes error 
        * handling to log any issues that occur during the insertion process.
        * @throws Exception Logs an error message if an exception occurs during the insertion.
    */
    public static void insertRecordForTrainingSession() {
        List<Training_Session__c> newTrainingSessions = new List<Training_Session__c>();
        for (Integer i = 0; i < 10; i++) {
            Training_Session__c newTraining = new Training_Session__c();
            newTraining.Name = 'Java' + i;
            newTrainingSessions.add(newTraining);
        }
        try {
            insert newTrainingSessions;
        } catch (Exception e) {
            System.debug('Error During Insertion: ' + e.getMessage());
        }
    }

    /**
        * Retrieves and logs all training session records from the database.
        * This method queries the `Training_Session__c` object to fetch all records with their `Id` 
        * and `Name` fields and logs the result to the debug log.
    */
    public static void readRecordForTraininSession() {
        List<Training_Session__c> trainingSessions = [SELECT Id, Name FROM Training_Session__c LIMIT 1000];
        System.debug(trainingSessions);
    }

    /**
         * Updates the name of a training session.
         * - Fetches the record by ID, updates its name, and saves it.
         * - Logs errors if the update fails.
         * @param idOfSessionToUpdate The ID of the session to update.
         * @param updatedName The new name for the session.
    */
    public static void updateRecordForTraininSession(Id idOfSessionToUpdate, String updatedName) {
        List<Training_Session__c> trainingSessions = [SELECT Id, Name FROM Training_Session__c WHERE Id = :idOfSessionToUpdate];
        if(!trainingSessions.isEmpty()){
        for (Training_Session__c itrateOnTrainingSession : trainingSessions) {
            if (itrateOnTrainingSession.Id == idOfSessionToUpdate) {
                itrateOnTrainingSession.Name = updatedName;
            }
          }
        }
        try {
            update trainingSessions;
        } catch (Exception e) {
            System.debug('Error During Updation: ' + e.getMessage());
        }
    }

    /**
         * Deletes a training session by ID.
         * - Checks if the record exists, deletes it, and logs errors if any.
         * @param idOfSessionToDelete The ID of the session to delete.
    */
    public static void deleteRecordForTraininSession(Id idOfSessionToDelete) {
        List<Training_Session__c> trainingSessions = [SELECT Id, Name FROM Training_Session__c WHERE Id = :idOfSessionToDelete];
        if (!trainingSessions.isEmpty()) {
            try {
                delete trainingSessions;
            } catch (Exception e) {
                System.debug('Error During Deletion: ' + e.getMessage());
            }
        } else {
            System.debug('No records found to delete');
        }
    }
    
    /**
         * Adds new attendees to a session without duplicates.
         * - Filters out existing attendees and inserts new ones.
         * @param sessionId The session ID.
         * @param listOfAttendeeForNewInsert List of attendees to add.
    */
    public static void addNewAttendeeUsingList(Id sessionId, List<Attendee__c> listOfAttendeeForNewInsert) {
        Set<Id> setOfExistingAttendee = new Set<Id>();
        for (Attendee__c existingAttendee : [SELECT Id, Name FROM Attendee__c WHERE Training_Session_Name__c = :sessionId]) {
            setOfExistingAttendee.add(existingAttendee.Id);
        }
        List<Attendee__c> newAttendee = new List<Attendee__c>();
        for (Attendee__c iterateSetOfAttendee : listOfAttendeeForNewInsert) {
            if (!setOfExistingAttendee.contains(iterateSetOfAttendee.Id)) {
                Attendee__c student = new Attendee__c();
                student.Name = iterateSetOfAttendee.Name;
                student.Training_Session_Name__c = sessionId;
                newAttendee.add(student);
            }
        }
        try {
            insert newAttendee;
        } catch (Exception e) {
            System.debug('Error During Insertion: ' + e.getMessage());
        }
    }

    /**
         * Adds a single attendee to a session and verifies attendee count.
         * Logs attendee count before and after adding.
    */
    public static void addAttendee() {
        List<Attendee__c> newListForTesting = [SELECT Id, Name FROM Attendee__c];
        System.debug(newListForTesting.size());
        Attendee__c student = new Attendee__c();
        student.Name = 'Priyank';
        student.Training_Session_Name__c = 'a07NS00000JC8EzYAL';
        newListForTesting.add(student);
        addNewAttendeeUsingList('a07NS00000JC8EzYAL', newListForTesting);
        newListForTesting = [SELECT Id, Name FROM Attendee__c];
        System.debug(newListForTesting.size());
        
    }

    /**
         * Fetches a training session and its attendees using safe navigation.
         * Ensures null safety while retrieving attendee names.
         * @param sessionId The session ID.
    */
    public static void fetchTrainingSessionAndRelatedAttendeesUsingSafeNavigationOperator(Id sessionId) {
        List<Training_Session__c> trainingSessions = [SELECT Id, Name ,(SELECT Id, Name FROM Attendees1__r) FROM Training_Session__c WHERE Id =: sessionId];      
        for(Training_Session__c iteratorOverTrainingSessions : trainingSessions){
            if(iteratorOverTrainingSessions.Attendees1__r != null){
                for(Attendee__c iteratorOverEachAttendee : iteratorOverTrainingSessions.Attendees1__r){
                    String nameOfAttendee = iteratorOverEachAttendee?.Name;
                    System.debug(nameOfAttendee);
                }
            }
        }
    }

    /**
         * Fetches a training session and retrieves attendee names.
         * Safely retrieves names of related attendees and logs them.
         * @param sessionId The session ID.
    */
    public static void fetchTrainingSessionAndRelatedAttendees(Id sessionId) {
        List<Training_Session__c> trainingSessions = [SELECT Id, Name ,(SELECT Id, Name FROM Attendees1__r) FROM Training_Session__c WHERE Id =: sessionId LIMIT 1];      
        for(Training_Session__c iteratorOverTrainingSessions : trainingSessions){
            if(iteratorOverTrainingSessions.Attendees1__r != null){
                List<String> nameOfAttendees = new List<String>();
                for(Attendee__c iteratorOverEachAttendee : iteratorOverTrainingSessions.Attendees1__r){
                    String nameOfAttendeeString = iteratorOverEachAttendee?.Name;
                    nameOfAttendees.add(nameOfAttendeeString);   
                }
                System.debug(nameOfAttendees);
            }  
        }  
    }
}