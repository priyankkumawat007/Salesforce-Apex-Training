/*
* Purpose           	: 	Practicing Trigger Assignment 5( This trigger will update 'No. Of Attended Training Session' 
                            field on contact object according to the number of session that contact is enrolled.)
*                        
* Date				    :	04/12/24	
*
* Owner				    :   Priyank Kumawat
*
* Release log			:   V 0.1
*/
trigger AttendeeTrigger on Attendee__c (after insert, after update, after delete) {
    if(Trigger.isAfter){
        if (Trigger.isInsert) {
            HelperAttendeeTrigger.updateNoOfSessionsOnContact(Trigger.new, Trigger.oldMap);
        }
        if (Trigger.isUpdate) {
            HelperAttendeeTrigger.updateNoOfSessionsOnContact(Trigger.new, Trigger.oldMap);
        }
        if (Trigger.isDelete) {
			HelperAttendeeTrigger.updateNoOfSessionsOnContact(Trigger.new, Trigger.oldMap);
       }
	}
}