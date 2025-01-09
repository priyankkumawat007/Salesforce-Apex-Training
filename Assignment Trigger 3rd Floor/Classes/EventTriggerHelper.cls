public class EventTriggerHelper {
	public static void countRelatedActivities(List<Event> listNewOfEvent, Map<Id,Event> mapOfOldEvent){
		Set<Id> setOfIds = new Set<Id>();
        for(Event items : listNewOfEvent != null ? listNewOfEvent: mapOfOldEvent.values()){
            if(items.whatId != null && items.Which_Status__c != null){
                setOfIds.add(items.WhatId);
            }
            if(mapOfOldEvent != null && mapOfOldEvent.get(items.Id).WhatId != null && 
     			(mapOfOldEvent.get(items.Id).WhatId != items.WhatId || mapOfOldEvent.get(items.Id).Whatid != items.WhatId)){
                setOfIds.add(mapOfOldEvent.get(items.Id).WhatId);
            }
        } 
		List<AggregateResult> result = [SELECT WhatId, Count(Id) counts FROM Event WHERE WhatId IN: setOfIds GROUP BY WhatId];
		List<Event> resultOpenAct = [SELECT WhatId, Id, Which_Status__c FROM Event WHERE WhatId IN: setOfIds AND Which_Status__c = 'Open'];
		List<Event> resultCloseAct = [SELECT WhatId, Id, Which_Status__c FROM Event WHERE WhatId IN: setOfIds AND Which_Status__c = 'Close'];
		Integer sizeOfresultOpenAct = resultOpenAct.Size();
		Integer sizeOfresultCloseAct = resultCloseAct.Size();

        Map<Id,Decimal> mapOfIdAndDecimal = new Map<Id,Decimal>();
        for(AggregateResult agg : result){
			Decimal totalAmt = 0.0;
            Id AccId = (Id)agg.get('WhatId');
            Decimal CountOfEvents = (Decimal)agg.get('counts');
            mapOfIdAndDecimal.put(AccId,CountOfEvents);
        }
        List<Account> listToUpdate = new List<Account>();
		for(Id ids : setOfIds){
            Account acc = new Account();
            acc.id = ids;
			acc.Total_Activities__c = mapOfIdAndDecimal.get(Ids);
			acc.Total_Closed_Activities__c = sizeOfresultCloseAct;
			acc.Total_Open_Activities__c = sizeOfresultOpenAct; 
            listToUpdate.add(acc);
        }
        if(!listToUpdate.isEmpty()){
            update listToUpdate;
        }
    }
}