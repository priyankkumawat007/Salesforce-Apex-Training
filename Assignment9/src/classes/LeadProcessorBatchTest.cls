/** 
* Purpose          :   Test Class for LeadProcessorBatch Class.
* 
* Created by       :   Priyank Kumawat
* 
* Created Date     :   18-12-2024
* 
* Revision Logs    :   V_1.0 - Created
**/
@isTest
public class LeadProcessorBatchTest {
	/** 
    * Method Name  :   setup
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   Method to create sample data for testing.
    * 
    * return       :   @void
    * 
    * param        :   null
    **/
	@testSetup
    static void setup(){
        List<Lead> leads = new List<Lead>();
        for(Integer i=0;i<200;i++){
            leads.add(new Lead(LastName='lead '+i, Company='example'));
        }
		insert leads;
    }
	/** 
    * Method Name  :   testLeads
    * 
    * Created by   :   Priyank Kumawat
    * 
    * Purpose      :   Method to check working of batch by updating the bulk record using batch apex.
    * 
    * return       :   @void
    * 
    * param        :   null
    **/
	@isTest 
    public static void testLeads(){
		Test.startTest();
        LeadProcessorBatch leadProcessors = new LeadProcessorBatch();
		Id BatchId = Database.executeBatch(leadProcessors);
		Test.stopTest();

		List<Lead> leads = new List<Lead>();
		leads = [SELECT Id, leadSource FROM Lead];

		Assert.areEqual('Dreamforce', leads[0].leadSource);
		Assert.areEqual(200, [SELECT count() FROM Lead]);
    }
}