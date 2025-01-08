 /**
 * Purpose          :   Batch for archive the data and sent the email to the user.
 * 
 * Created by       :   Priyank Kumawat
 * 
 * Created Date     :   02-01-2025
 * 
 * Revision Logs    :   V_1.0 - Created
 **/
public class DeleteOldRecordsBatch implements Database.Batchable<SObject>, Database.Stateful{
    	private String query;
	private String csvContent ='';
       /**
       * Constructor Name  :   DeleteOldRecordsBatch
       * 
       * Created by   :   Priyank Kumawat
       * 
       * Purpose      :   Take the query as an argument and initialize the query variable
       *                
       *
       * Return       :   void
       * 
       * Parameters   :   String query
       **/
	public DeleteOldRecordsBatch(String query){
       		this.query = query;
    	}
    	public Database.QueryLocator start(Database.BatchableContext bc){
        	return Database.getQueryLocator(query);
		
    	}
   	public void execute(Database.BatchableContext bc, List<SObject> scope){
		for (SObject obj : scope) {
                	csvContent += obj+'\n' ;
            	}
    	}
    	public void finish(Database.BatchableContext bc){
       		Blob csvBlob = Blob.valueOf(csvContent);
     		Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
       		attachment.setFileName('TestFile.csv');
       		attachment.setBody(csvBlob);
       		attachment.setContentType('text/csv');
       		List<Messaging.SingleEmailMessage> emailsWithToAddresses = new List<Messaging.SingleEmailMessage>();
       		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
       		email.setToAddresses(new String[] {'priyank.kumawat@fexle.com'});
      		email.setSubject('We deleted the record of: Sobject');
       		email.setPlainTextBody('We are going to delete SObject');
       		email.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
       		emailsWithToAddresses.add(email);
       		if (!emailsWithToAddresses.isEmpty()) {
           		 Messaging.sendEmail(emailsWithToAddresses);
        	}
       		if(!queryResult.isEmpty()){
           		 Delete queryResult;
        	}	
    	}
}