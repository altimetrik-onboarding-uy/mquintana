trigger closeTaskTrigger on Task__c (after insert, after update, before insert, before update) {
    
    String HabitRT = Schema.getGlobalDescribe().get('Task__c').getDescribe().getRecordTypeInfosByName().get('Habit').getRecordTypeId();
    
    if(trigger.isBefore){
        CloseTaskTriggerHelper.setTaskCompleted(trigger.new);
    }
    
    if(trigger.isAfter){
        CloseTaskTriggerHelper.setPointsTotals(trigger.new);
    }
    
    
}