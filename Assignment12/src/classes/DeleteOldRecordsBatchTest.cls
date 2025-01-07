/** 
* Purpose          :   Test Class for DeleteOldRecordsBatch.
* 
* Created by       :   Priyank Kumawat
* 
* Created Date     :   01-01-2025
* 
* Revision Logs    :   V_1.0 - Created
**/
@isTest(seeAllData = false)
public class DeleteOldRecordsBatchTest {
/**
* Method Name  :   testDeleteOldRecordsBatch
* 
* Created by   :   Priyank Kumawat
* 
* Purpose      :   This test ensures that the `DeleteOldRecordsBatch` class executes without errors 
*                  and validates the behavior of the batch process, including query execution and email sending.
*
* return       :   void
* 
* param        :   null
**/
    @isTest
    static void testDeleteOldRecordsBatch() {
        Account acc = new Account(Name='Test', Domain_Name__c = 'fexle.com', Phone_Number__c = '8005883997');
        insert acc;
        Opportunity opp = new Opportunity(Name='Test', StageName = 'Prospecting', CloseDate = Date.newInstance(2024, 12, 11));
        insert opp;
        Test.startTest();
            String cronExp = '0 0 0 * * ?';
            scheduleDeleteOldRecordsBatch batchHandler = new scheduleDeleteOldRecordsBatch();
            System.schedule('Archive jobs', cronExp, batchHandler);
            Integer remainingOpportunity = [SELECT COUNT() FROM Opportunity WHERE Name LIKE 'Test'];
            Integer remainingAccounts = [SELECT COUNT() FROM Account WHERE Name LIKE 'Test'];
        Test.stopTest(); 
        Assert.areEqual(2,scheduleDeleteOldRecordsBatch.count);
        Assert.areEqual(0, remainingOpportunity, 'All matching opportunity should have been deleted');
        Assert.areEqual(0, remainingAccounts, 'All matching accounts should have been deleted');
    }   
}
