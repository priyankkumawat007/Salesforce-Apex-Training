/** 
* Purpose 		: Class AddPrimaryContact 
* 
* Created by 		: Priyank Kumawat 
* 
* Created Date 		: 20/12/24 
* 
* Revision Logs 	: V_1.0 - Created 
**/
public class AddPrimaryContact implements Queueable{
    private Contact contact;
    private String state;
    /**
    * Constructor Name  :   AddPrimaryContact
    * 
    * Created by        :   Priyank Kumawat
    * 
    * Purpose      	:   Constructor to initialize the AddPrimaryContact class with a Contact and a state abbreviation.
    *
    * param        	:   Contact contact, String state
    **/
    public AddPrimaryContact(Contact contact, String state) {
        this.contact = contact;
        this.state = state;
    }
    /**
    * Constructor Name  :   execute
    * 
    * Created by        :   Priyank Kumawat
    * 
    * Purpose      	:   Queries Accounts by the specified state, clones the provided Contact for each Account, and inserts the cloned Contact records.
    *
    * param        	:   QueueableContext context
    **/
    public void execute(QueueableContext context){
        List<Account> accounts = [SELECT Id FROM Account WHERE BillingState = :state LIMIT 200];
        List<Contact> newContacts = new List<Contact>();
        for (Account acc : accounts) {
            Contact newContact = contact.clone(false, true, false, false);
            newContact.AccountId = acc.Id;
            newContacts.add(newContact);
        }
        if (!newContacts.isEmpty()) {
            insert newContacts;
        }
    }
}