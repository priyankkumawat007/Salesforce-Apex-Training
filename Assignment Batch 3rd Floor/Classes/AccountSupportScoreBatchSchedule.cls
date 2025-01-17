global class AccountSupportScoreBatchSchedule implements Schedulable {
    global void execute(SchedulableContext SC) {
        AccountSupportScoreBatch AccountSupportScore = new AccountSupportScoreBatch();
		Id BatchId = Database.executeBatch(AccountSupportScore,10);
    }
}


/*
//For scheduling the batch
AccountSupportScoreBatchSchedule sch = new AccountSupportScoreBatchSchedule();
String chron = '0,0,0,15,*,?,*';
System.schedule('Scheduled Batch ',chron , sch);

*/