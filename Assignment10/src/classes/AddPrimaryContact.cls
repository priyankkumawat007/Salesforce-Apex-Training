public class AddPrimaryContact implements Queueable {
    private Contact contact;
    private String state;
    public AddPrimaryContact(Contact contact, String state) {
        this.contact = contact;
        this.state = state;
    }
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