@isTest
private class TaskBoardControllerTest {
    
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
        t.Status__c = 'New';
        t.RecordTypeId = HabitRT;
        t.Employee__c = c.Id;
        tasks.add(t);

        Task__c t2 = new Task__c();
        t2.Name = 'This is a ToDo task';
        t2.Difficulty__c = 'Easy';
        t2.Status__c = 'New';
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
    private static void getAllTaskTest(){
        Test.startTest();
        List<Task__c> tasks = TaskBoardController.getAllTasks();
        Test.stopTest();
        System.assertEquals(3, tasks.size());
    }

    @isTest
    private static void setNewStatusTaskTest(){
        Task__c t = [SELECT Id, Status__c FROM Task__c WHERE Status__c != 'In Progress' LIMIT 1];
        Test.startTest();
        TaskBoardController.setNewStatus(t.Id, 'In Progress');
        Test.stopTest();
        System.assertEquals('In Progress', [SELECT Id, Status__c FROM Task__c WHERE Id =: t.Id LIMIT 1].Status__c);
    }

    @isTest
    private static void addHabitPointsTest(){
        Task__c t = [SELECT Id, Employee__c, Points__c FROM Task__c LIMIT 1];
        Test.startTest();
        TaskBoardController.setHabitPoints(t.Id, 'add');
        Test.stopTest();
        System.assert([SELECT Id, Total_Points__c FROM Contact WHERE Id =: t.Employee__c LIMIT 1].Total_Points__c > 0);
        System.assert([SELECT Id, Task_Completed__c FROM Task__c WHERE Id =: t.Id LIMIT 1].Task_Completed__c == true);
    }

    @isTest
    private static void subtractHabitPointsTest(){
        Task__c t = [SELECT Id, Employee__c, Points__c FROM Task__c LIMIT 1];
        Test.startTest();
        TaskBoardController.setHabitPoints(t.Id, 'subtract');
        Test.stopTest();
        System.assert([SELECT Id, Total_Points__c FROM Contact WHERE Id =: t.Employee__c LIMIT 1].Total_Points__c < 0);
        System.assert([SELECT Id, Habit_Failed__c FROM Task__c WHERE Id =: t.Id LIMIT 1].Habit_Failed__c == true);
    }

}