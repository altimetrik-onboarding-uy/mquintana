@isTest
public class UpdateTasksBatchTest {
    @TestSetup
    static void setup(){
        
        String DailyRT = Schema.getGlobalDescribe().get('Task__c').getDescribe().getRecordTypeInfosByName().get('Daily').getRecordTypeId();
        String HabitRT = Schema.getGlobalDescribe().get('Task__c').getDescribe().getRecordTypeInfosByName().get('Habit').getRecordTypeId();

        Contact c = new Contact();
        c.LastName = 'Test Contact';
        c.Email = 'test@test.com';
        insert c;

        List<Task__c> tasks = new List<Task__c>();
        Task__c t = new Task__c();
        t.Name = 'This is an Habit task';
        t.Difficulty__c = 'Easy';
        t.Status__c = 'Completed';
        t.RecordTypeId = DailyRT;
        t.Employee__c = c.Id;
        tasks.add(t);

        Task__c t2 = new Task__c();
        t2.Name = 'This is a ToDo task';
        t2.Difficulty__c = 'Easy';
        t2.Status__c = 'Completed';
        t2.RecordTypeId = DailyRT;
        t2.Employee__c = c.Id;
        tasks.add(t2);

        Task__c t3 = new Task__c();
        t3.Name = 'This is a Daily task';
        t3.Difficulty__c = 'Easy';
        t3.Status__c = 'Completed';
        t3.RecordTypeId = HabitRT;
        t3.Habit_Failed__c = true;
        t3.Task_Completed__c = true;
        t3.Employee__c = c.Id;
        tasks.add(t3);

        insert tasks;
    }
    
    @isTest
    private static void updateTaskBatchTest(){

        Test.startTest();
        UpdateTasksBatch utb = new UpdateTasksBatch();
        Database.executeBatch(utb,200);
        Test.stopTest();

        Task__c t = [SELECT Id, Habit_Failed__c, Task_Completed__c FROM Task__c WHERE RecordType.Name='Habit' LIMIT 1];
        System.assertEquals(false, t.Habit_Failed__c);
        System.assertEquals(false, t.Task_Completed__c);

        Task__c daily = [SELECT Id, Status__c FROM Task__c WHERE RecordType.Name='Daily' LIMIT 1];
        System.assertEquals('New', daily.Status__c);

    }
}
