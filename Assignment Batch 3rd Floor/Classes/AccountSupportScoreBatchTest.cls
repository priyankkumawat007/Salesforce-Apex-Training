@isTest
public class AccountSupportScoreBatchTest {
	@isTest 
    public static void testCasesByFetchingAccount(){
		Account acc1 = new Account(Name = 'Test Account1', Domain_Name__c = 'example.com', Phone_Number__c = '8005883998');
        Account acc2 = new Account(Name = 'Test Account2', Domain_Name__c = 'example.com', Phone_Number__c = '8005883990');
        insert new List<Account>{acc1, acc2};

        List<Case> cases  = new List<Case>();
        cases.add(new Case(Severity__c= 'high', Status='Close', AccountId = acc1.id));
		insert cases;

		Test.startTest();
        AccountSupportScoreBatch AccountSupportScore = new AccountSupportScoreBatch();
		Id BatchId = Database.executeBatch(AccountSupportScore,10);
		Test.stopTest();

		Account acc = [SELECT Id, Name,Support_Score__c  FROM Account WHERE Id = :acc1.Id];

		Assert.areEqual('Support_Score__c', 1);
	
    }
}