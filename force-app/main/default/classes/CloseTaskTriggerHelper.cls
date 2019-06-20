public with sharing class CloseTaskTriggerHelper {
    
    public static void setTaskCompleted(List<Task__c> tasks) {
        String HabitRT = Schema.getGlobalDescribe().get('Task__c').getDescribe().getRecordTypeInfosByName().get('Habit').getRecordTypeId();
        for(Task__c t : tasks){
            if(t.RecordTypeId != HabitRT){
                if(t.Status__c == 'Completed'){
                    t.Task_Completed__c = true;
                }else{
                    t.Task_Completed__c = false;
                } 
            }   
        }
    }

    public static void setPointsTotals(List<Task__c> tasks){
        String HabitRT = Schema.getGlobalDescribe().get('Task__c').getDescribe().getRecordTypeInfosByName().get('Habit').getRecordTypeId();
        Map<Id, Decimal> contactPointsMap = new Map<Id, Decimal>();
        for(Task__c t : tasks){
            if(t.Status__c == 'Completed'){
                if(contactPointsMap.containsKey(t.Employee__c)){
                    contactPointsMap.put(t.Employee__c, contactPointsMap.get(t.Employee__c)+t.Points__c);
                }else{
                    contactPointsMap.put(t.Employee__c, t.Points__c);
                } 
            }     
        }
        Set<Id> idContacts = contactPointsMap.keySet();
        List<Contact> contactsToUpdate = new List<Contact>();
        for(Id i : idContacts){
            Contact c = [SELECT Id, Total_Points__c FROM Contact WHERE Id =: i];
            if(c.Total_Points__c != null ){
                c.Total_Points__c += contactPointsMap.get(i);
            }else{
                c.Total_Points__c = contactPointsMap.get(i);
            }
            
            contactsToUpdate.add(c);        
        }
        update contactsToUpdate; 
    }
}
