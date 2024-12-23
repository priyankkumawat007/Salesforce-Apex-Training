/** 
 * Purpose          :   Class LeadProcessorBatch 
 * 
 * Created by       :   Priyank Kumawat
 * 
 * Created Date     :   17-12-2024
 * 
 * Rivision Logs    :   V_1.0 - Created
**/
public class LeadProcessorBatch Implements Database.Batchable<sObject>, Database.Stateful {
    public Integer count = 0;
    /**
    * Method Name  :   start
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   Method to define the batch query. 
    *
    * return       :   Database.QueryLocator
    *
    * param        :   Database.BatchableContext bc
    **/
    public Database.queryLocator start(Database.batchableContext bc){
        return Database.getQueryLocator('SELECT Id, Name FROM Lead');
    }
    /**
    * Method Name  :   execute
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   Method to process each batch of Leads and update the LeadSource field. 
    *
    * return       :   void
    *
    * param        :   Database.BatchableContext bc, List<Lead> listOfLeads
    **/
    public void execute(Database.batchableContext bc, List<Lead> listOfLeads){
	List<Lead> listToUpdateLead = new List<Lead>();
        for(Lead leads : listOfLeads){
            leads.leadSource  = 'Dreamforce'; 
 	    listToUpdateLead.add(leads);
	    count++;
        }
	update listToUpdateLead;
    }
    /**
    * Method Name  :   finish
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   Method to finalize the batch process and log the results. 
    *
    * return       :   void
    *
    * param        :   Database.BatchableContext bc
    **/
    public void finish(Database.BatchableContext bc){
	AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                 	    FROM AsyncApexJob
            		    WHERE Id = :bc.getJobId()];
    }
}