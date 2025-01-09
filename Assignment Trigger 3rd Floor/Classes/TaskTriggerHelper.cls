public class TaskTriggerHelper {
	public static void countRelatedActivities(List<Task> listNewOfTask, Map<Id,Task> mapOfOldTask){
		Set<Id> setOfIds = new Set<Id>();
        for(Task items : listNewOfTask != null ? listNewOfTask: mapOfOldTask.values()){
            if(items.whatId != null && items.Which_Status__c != null){
                setOfIds.add(items.WhatId);
            }
            if(mapOfOldTask != null && mapOfOldTask.get(items.Id).WhatId != null && 
     			(mapOfOldTask.get(items.Id).WhatId != items.WhatId || mapOfOldTask.get(items.Id).Whatid != items.WhatId)){
                setOfIds.add(mapOfOldTask.get(items.Id).WhatId);
            }
        } 
		List<AggregateResult> result = [SELECT WhatId, Count(Id) counts FROM Task WHERE WhatId IN: setOfIds GROUP BY WhatId];
		//List<Event> resultOpenAct = [SELECT WhatId, Id, Which_Status__c FROM Event WHERE WhatId IN: setOfIds];
		List<Event> resultOpenAct = [SELECT WhatId, Id, Which_Status__c FROM Event WHERE WhatId IN: setOfIds AND Which_Status__c = 'Open'];
		List<Event> resultCloseAct = [SELECT WhatId, Id, Which_Status__c FROM Event WHERE WhatId IN: setOfIds AND Which_Status__c = 'Close'];
		Integer sizeOfresultOpenAct = resultOpenAct.size();
		Integer sizeOfresultCloseAct = resultCloseAct.size();
		

        Map<Id,Decimal> mapOfIdAndDecimal = new Map<Id,Decimal>();
        for(AggregateResult agg : result){
			Decimal totalAmt = 0.0;
            Id AccId = (Id)agg.get('WhatId');
			
            //if((Decimal)agg.get('TotalAmount') != null){
            //	totalAmt = (Decimal)agg.get('TotalAmount');}
            Decimal CountOfEvents = (Decimal)agg.get('counts');
            //Decimal AvgAmount = totalAmt/CountOfOrderItems;
            mapOfIdAndDecimal.put(AccId,CountOfEvents);
        }
        List<Account> listToUpdate = new List<Account>();
		for(Id ids : setOfIds){
            Account acc = new Account();
            acc.id = ids;
			GlobalVariables.totalActivities += mapOfIdAndDecimal.get(Ids);
			acc.Total_Activities__c = mapOfIdAndDecimal.get(Ids);
			acc.Total_Closed_Activities__c = sizeOfresultCloseAct;
			acc.Total_Open_Activities__c = sizeOfresultOpenAct;
			//acc.Total_Activities__c = GlobalVariables.totalActivities;
            listToUpdate.add(acc);
        }
        if(!listToUpdate.isEmpty()){
            update listToUpdate;
        }
    }
}