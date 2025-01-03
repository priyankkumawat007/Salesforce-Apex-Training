public class DeleteOldRecordsBatch implements Database.Batchable<SObject>, Database.Stateful{
    private String query;
	private String csvContent ='';
	public DeleteOldRecordsBatch(String query){
       this.query = query;
    }
    public Database.QueryLocator start(Database.BatchableContext bc){
		System.debug(query);
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
		/*
        if(!queryResult.isEmpty()){
            Delete queryResult;
        }
		*/
  		
    }
}