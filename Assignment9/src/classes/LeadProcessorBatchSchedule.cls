/** 
 * Purpose          :   Class LeadProcessorBatchSchedule 
 * 
 * Created by       :   Priyank Kumawat
 * 
 * Created Date     :   17-12-2024
 * 
 * Rivision Logs    :   V_1.0 - Created
**/
global class LeadProcessorBatchSchedule implements Schedulable {
	/** 
    * Method Name  :   execute
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   Method to execute the LeadProcessorBatch using the Schedulable interface.
    * 
    * return       :   @void
    * 
    * param        :   SchedulableContext SC
    **/
    global void execute(SchedulableContext SC) {
        LeadProcessorBatch leadprocessor = new LeadProcessorBatch();
		Id BatchId = Database.executeBatch(leadprocessor,10);
    }
}