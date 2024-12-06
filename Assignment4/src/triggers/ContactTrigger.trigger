/*
    * Purpose           	: 	Practicing Trigger Assignment 4( Whenever any contact record is getting insert or updated then we have to check their Email domain name. 
    *                           If it does not contains 'Fexle .com' in the domain (Custom field on account of text type) then it should not be inserted.)
    *                        
    * Date				    :	04/12/24	
    *
    * Owner				    :   Priyank Kumawat
    *
    * Release log			:   V 0.1
*/
trigger ContactTrigger on Contact (before insert,before update) {
	if(trigger.isBefore){
        if(trigger.isInsert || trigger.isUpdate){
            try{
				ClassHelperContactTrigger.checkForEmailDomainNameWhenInsertingAndUpdating(trigger.new);
            }catch(Exception ex){
                System.debug('Unexpected error occur while inserting or updating record' + ex.getMessage());
            }
        }
    }
}