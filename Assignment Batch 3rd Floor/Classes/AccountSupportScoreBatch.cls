public class AccountSupportScoreBatch Implements Database.Batchable<sObject>, Database.Stateful{
	List<Account> updateAccounts = new List<Account>();
	public Database.queryLocator start (Database.batchableContext bc){
        return Database.getQueryLocator('SELECT Id, Name, CreatedDate, Status, Severity__c FROM Cases WHERE  Status = "Open"');
    }
	public void execute(Database.batchableContext bc, List<Case> listOfCases){
    	Map<Id,List<Case>> mapOfAccountAndCases = new Map<Id,List<Case>>();
        for(Case eachCase : listOfCases){
            if(!mapOfAccountAndCases.ContainsKey(eachCase.AccountId)){
                    mapOfAccountAndCases.put(eachCase.AccountId, new list<case>());
            }
            mapOfAccountAndCases.get(eachCase.AccountId).add(eachCase);
        }
		list<Account> updateAcc = new list<Account>();
		for(Id eachCaseOfMap : mapOfAccountAndCases.keySet()){
			scoreCalculate obj = new scoreCalculate();
			Integer points = obj.scoreCalculation(mapOfAccountAndCases.get(eachCaseOfMap));
			Account newAcc = new account();
			newAcc.Id = eachCaseOfMap;
			newAcc.Support_Score__c += points;
			updateAccounts.add(newAcc);
        }
    }
	public void finish(Database.BatchableContext bc){
        if(!updateAccounts.isEmpty()){
            update updateAccounts;
        }
	System.debug('Count Value' + count);
		AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                 			FROM AsyncApexJob
            				WHERE Id = :bc.getJobId()];
        System.debug('AsyncApexJob  '+ job);
    }
	
   
}