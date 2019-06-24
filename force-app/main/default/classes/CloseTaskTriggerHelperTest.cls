@isTest
private class CloseTaskTriggerHelperTest {
    
    @TestSetup
    static void setup(){
        String HabitRT = Schema.getGlobalDescribe().get('Task__c').getDescribe().getRecordTypeInfosByName().get('Habit').getRecordTypeId();
        String TODORT = Schema.getGlobalDescribe().get('Task__c').getDescribe().getRecordTypeInfosByName().get('TO-DO').getRecordTypeId();
        String DailyRT = Schema.getGlobalDescribe().get('Task__c').getDescribe().getRecordTypeInfosByName().get('Daily').getRecordTypeId();
        
        Contact c = new Contact();
        c.LastName = 'Test Contact';
        insert c;

        List<Task__c> tasks = new List<Task__c>();
        Task__c t = new Task__c();
        t.Name = 'This is an Habit task';
        t.Difficulty__c = 'Easy';
        t.Status__c = 'Completed';
        t.RecordTypeId = HabitRT;
        t.Employee__c = c.Id;
        tasks.add(t);

        Task__c t2 = new Task__c();
        t2.Name = 'This is a ToDo task';
        t2.Difficulty__c = 'Easy';
        t2.Status__c = 'Completed';
        t2.RecordTypeId = TODORT;
        t2.Employee__c = c.Id;
        tasks.add(t2);

        Task__c t3 = new Task__c();
        t3.Name = 'This is a Daily task';
        t3.Difficulty__c = 'Easy';
        t3.Status__c = 'New';
        t3.RecordTypeId = DailyRT;
        t3.Employee__c = c.Id;
        tasks.add(t3);

        insert tasks;
    }

    @isTest
    private static void setTaskCompletedTest(){
        List<Task__c> tasks = [SELECT Id, Name, Status__c, RecordTypeId FROM Task__c WHERE RecordType.Name != 'Habit'];

        Test.startTest();
        CloseTaskTriggerHelper.setTaskCompleted(tasks);
        Test.stopTest();

        System.assertEquals(true, [SELECT Id, Task_Completed__c FROM Task__c WHERE RecordType.Name != 'Habit' AND Status__c = 'Completed' LIMIT 1].Task_Completed__c);
        System.assertEquals(false, [SELECT Id, Task_Completed__c FROM Task__c WHERE RecordType.Name != 'Habit' AND Status__c != 'Completed' LIMIT 1].Task_Completed__c);
    }

    @isTest
    private static void setPointsTotalTest(){
        List<Task__c> tasks = [SELECT Id, Name, Status__c, RecordTypeId, Employee__c, Points__c FROM Task__c];
        Contact c = new Contact();
        c.Id = tasks[0].Employee__c;
        c.Total_Points__c = 0;
        update c; // THIS IS NEEDED BECAUSE AFTER INSERT TASK TOTAL POINTS ARE ALREADY ASIGNED
        Test.startTest();
        CloseTaskTriggerHelper.setPointsTotals(tasks);
        Test.stopTest();
        Decimal totalPoints = (Decimal)[SELECT sum(Points__c) total FROM Task__c WHERE Status__c = 'Completed'][0].get('total');
        System.assertEquals(totalPoints, [SELECT Total_Points__c FROM Contact WHERE Id =: tasks[0].Employee__c].Total_Points__c);
    }

}
