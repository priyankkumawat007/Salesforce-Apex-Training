public class scoreCalculate {
	 public Integer scoreCalculation(List<Case> listCases){
		 Integer point = 0;
		 Date Todaysdate = System.today();
         for(Case eachCase : listCases){
             if(eachCase.Severity__c =='High Severity'){
                 point+=3;
             }
             if(eachCase.Severity__c =='Medium Severity'){
                  point+=2;
             }
			  if(eachCase.Severity__c =='Low Severity'){
                  point+=2;
             }
			/*
			Date startDate = Date.newInstance(eachCase.CreatedDate);
        	Date dueDate = Date.newInstance(System.today());
        	Integer numberDaysDue = startDate.daysBetween(dueDate);
             if(numberDaysDue < 30){
                 point++;
             }
			 if(numberDaysDue > 60){
                 point--;
             }
         
        */
         }
         if(point < 0){
             return 0;
         }
		return point;
    }

}