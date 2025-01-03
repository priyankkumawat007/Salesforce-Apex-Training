/** 
 * Purpose          :   Test Class for DeleteOldRecordsBatch.
 * 
 * Created by       :   Priyank Kumawat
 * 
 * Created Date     :   01-01-2025
 * 
 * Revision Logs    :   V_1.0 - Created
 **/
@isTest(seeAllData = TRUE)
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
        Test.startTest();
        	String cronExp = '0 0 0 * * ?';
        	scheduleDeleteOldRecordsBatch batchHandler = new scheduleDeleteOldRecordsBatch();
        	System.schedule('Archive jobs', cronExp, batchHandler);
        Test.stopTest(); 
        Assert.areEqual(2,scheduleDeleteOldRecordsBatch.count);
    }   
}