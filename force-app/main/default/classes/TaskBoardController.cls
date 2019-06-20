public with sharing class TaskBoardController {

    @AuraEnabled
    public static List<Task__c> getAllTasks(){
        return [SELECT Id, Name, Description__c, Difficulty__c, Points__c, Status__c, RecordType.Name, Task_Completed__c, Habit_Failed__c FROM Task__c WHERE Status__c != 'Completed'];
    }

    @AuraEnabled
    public static void setNewStatus(String taskId, String taskStatus){
        Task__c t = new Task__c();
        t.Id = taskId;
        t.Status__c = taskStatus;
        update t;
    }

    @AuraEnabled
    public static void setHabitPoints(String taskId, String taskAction){
        Task__c t = [SELECT Id, Employee__c, Points__c FROM Task__c WHERE Id =: taskId];
        Contact c = [SELECT Id, Total_Points__c FROM Contact WHERE Id =: t.Employee__c];
        if(c.Total_Points__c == NULL){
            c.Total_Points__c = 0;
        }
        if(taskAction == 'add'){
            c.Total_Points__c += t.Points__c;
            t.Task_Completed__c = true;
        }else if(taskAction == 'subtract'){
            c.Total_Points__c -= t.Points__c;
            t.Habit_Failed__c = true;
        }
        update c;
        update t;
    }
}
