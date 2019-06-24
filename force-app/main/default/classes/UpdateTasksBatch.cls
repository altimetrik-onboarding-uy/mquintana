global class UpdateTasksBatch implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Status__c, Habit_Failed__c, Task_Completed__c, RecordType.Name FROM Task__c WHERE RecordType.Name = \'Daily\' OR RecordType.Name = \'Habit\'';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Task__c> scope){
      
        for(Task__c t : scope){      
            if(t.RecordType.Name == 'Habit'){
                t.Habit_Failed__c = false;
                t.Task_Completed__c = false;
            }else if(t.RecordType.Name == 'Daily'){
                t.Status__c = 'New';
            }
        }
        update scope;
        
    }
      
    global void finish(Database.BatchableContext BC){
        AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :BC.getJobId()];
         //Sending mail about batch status.......
  
    }
  
  

}
