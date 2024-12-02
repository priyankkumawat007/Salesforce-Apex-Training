/** 
    * Purpose: (Assignment 3) Class To Perform Data Manipulation on Training_Session__c.
    * Created by: Priyank Kumawat
    * Created Date: 27-11-24
    * Revision Log: V:1.1
**/

public with sharing class TrainingSessionDataManager {
    /**
        * Logs session mode-based messages for training sessions.
        * Retrieves sessions, checks Mode_of_Session__c, and logs corresponding system labels.
    */
    public static void fetchTrainingSessionAndRelatedAttendees1(){
        List<Training_Session__c> trainingSessions = [SELECT Id, Name FROM Training_Session__c]; 
        for(Training_Session__c  trainingSession :trainingSessions){
            if(trainingSession.Mode_of_Session__c == 'Webinar Online'){
                System.debug(System.Label.CL_FOR_WEBINAR_ONLINE_MODE);
            }else if(trainingSession.Mode_of_Session__c == 'Webinar Offline'){
                System.debug(System.Label.CL_FOR_WEBINAR_OFFLINE_MODE);
            }else if(trainingSession.Mode_of_Session__c == 'Workshop Online'){
                System.debug(System.Label.CL_FOR_WORKSHOP_ONLINE_MODE);
            }else{
                System.debug(System.Label.CL_FOR_WORKSHOP_OFFLINE_MODE);
            }
        }
    }

    /**
        * Fetches training sessions using criteria: date, record type, and counts attendees.
        * @param nameOfSessions The name of the session to filter results (currently not used in the method).
        * @throws Exception Logs any errors encountered during the queries.
    */
	public static void fetchTheRecordOnTheBasisOfSpecificCriteria(String nameOfSessions){
        List<Training_Session__c> trainingSessions = [SELECT Id, Name FROM Training_Session__c WHERE Session_Date__c = 2024-11-30];
        List<Training_Session__c> trainingSessionsRecordType = [SELECT Id, Name FROM Training_Session__c WHERE RecordTypeId = '012NS000002AUDSYA4'];
        AggregateResult trainingSessionsCountAttendee = [SELECT COUNT(Id) FROM Attendee__c WHERE Training_Session_Name__c = 'a07NS00000JC8EzYAL'];
        
    }

    /**
        * Updates session names by appending "BulkOperation".
        * @throws Exception Logs any errors encountered during the DML operation or SaveResult handling.
    */
    public static void DMLBulkOperationUpdate(){
        List<Training_Session__c> listForStoringTrainingSessions =[SELECT Id,Name From Training_Session__c];
        for(Training_Session__c iteratorOverlistForStoringTrainingSessions : listForStoringTrainingSessions){
            if(!listForStoringTrainingSessions.isEmpty()){
                iteratorOverlistForStoringTrainingSessions.Name += 'BulkOperation';
            }
        }
        if(!listForStoringTrainingSessions.isEmpty()){
            Database.SaveResult[] saveResult = Database.update( listForStoringTrainingSessions,false);
            List<Id> listOfIdForSuccessfulInsertion = new List<Id>();
            for(Database.SaveResult sr : saveResult){
                if(sr.isSuccess()){
                    listOfIdForSuccessfulInsertion.add(sr.getId());
                }else{
                    for(Database.Error err : sr.getErrors()){
                        System.debug('Error' + err.getMessage());
                    }
                }
            }
        }
        
    }

    /**
        * Creates a list of Training_Session__c records for bulk insertion.
    */
    public static List<Training_Session__c> createList(){
        List<Training_Session__c> ListToInsertUsingBulkOperation = new List<Training_Session__c>();
        for(Integer i=1;i<10;i++){
            Training_Session__c Student = new Training_Session__c();
            Student.Name = 'Priyank(28-11-2024)' + i;
            ListToInsertUsingBulkOperation.add(Student);
        }
        return  ListToInsertUsingBulkOperation;
        
    }

    /**
        * Performs a bulk insert operation for `Training_Session__c` records.
        * 
        * This method creates a list of `Training_Session__c` records, inserts them into Salesforce, 
        * and handles both successful and failed insert operations. It logs error messages for any failed records.
        * 
        * @throws Exception Logs any errors encountered during the DML operation or SaveResult handling.
    */
    public static void DMLBulkOperationInsert(){
        List<Training_Session__c> listForStoringTrainingSessions = createList();
        if(!listForStoringTrainingSessions.isEmpty()){
            Database.SaveResult[] saveResult = Database.insert(listForStoringTrainingSessions,false);
            List<Id> listOfIdForSuccessfulInsertion = new List<Id>();
            for(Database.SaveResult sr : saveResult){
                if(sr.isSuccess()){
                    listOfIdForSuccessfulInsertion.add(sr.getId());
                }else{
                    for(Database.Error err : sr.getErrors()){
                        System.debug('Error' + err.getMessage());
                    }
                }
            }
        }
        
    }
    
    /**
        * Deletes sessions with names containing "BulkOperation", handles errors.
        * 
        * @throws Exception Logs any errors encountered during the DML operation or DeleteResult handling.
     */
    public static void DMLBulkOperationDelete(){
        
        List<Training_Session__c> listForStoringTrainingSessions = [SELECT Id,Name From Training_Session__c WHERE Name Like '%BulkOperation%'];
        
        if(!listForStoringTrainingSessions.isEmpty()){
            Database.DeleteResult[] deleteResult = Database.delete(listForStoringTrainingSessions,false);
            List<Id> listOfIdForSuccessfulInsertion = new List<Id>();
            for(Database.DeleteResult sr : deleteResult){
                if(sr.isSuccess()){
                    listOfIdForSuccessfulInsertion.add(sr.getId());
                }else{
                    for(Database.Error err : sr.getErrors()){
                        System.debug('Error' + err.getMessage());
                    }
                }
            }
        }
        
    }

}