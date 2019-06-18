trigger closeTaskTrigger on Task__c (after insert, after update, before insert, before update) {
    
    String HabitRT = Schema.getGlobalDescribe().get('Task__c').getDescribe().getRecordTypeInfosByName().get('Habit').getRecordTypeId();
    
    if(trigger.isBefore){
        for(Task__c t : trigger.new){
            if(t.RecordTypeId != HabitRT){
                if(t.Status__c == 'Completed'){
                    t.Task_Completed__c = true;
                }else{
                    t.Task_Completed__c = false;
                } 
            }   
        }
    }
    
    if(trigger.isAfter){
		Set<Id> contactSet = new Set<Id>();
        for(Task__c t : trigger.new){
            contactSet.add(t.Employee__c);    
        }
        List<Contact> contactsToUpdate = new List<Contact>();
        for(Id i : contactSet){
            AggregateResult aResults = [SELECT sum(Points__c) FROM Task__c WHERE Employee__c =: i AND Points__c != NULL AND Task_Completed__c = true];
            Decimal totalPoints = (Decimal)aResults.get('expr0');
            Contact c = new Contact();
            c.Id = i;
            c.Total_Points__c = totalPoints;
            contactsToUpdate.add(c);        
        }
        update contactsToUpdate;        
    }
    
    
}