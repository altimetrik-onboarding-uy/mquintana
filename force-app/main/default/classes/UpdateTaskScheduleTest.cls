@isTest
private class UpdateTaskScheduleTest {
    
    @isTest
    private static void runUpdateTaskScheduleJobTest() {
        String cronExpr = '0 0 0 15 3 ? 2022';
        Integer jobs = [SELECT count() FROM CronTrigger];
        Test.startTest();
        UpdateTaskSchedule uts= new UpdateTaskSchedule();
        String jobId = System.schedule('myJobTestUpdateTask', cronExpr, uts);
        uts.execute(null);
        Test.stopTest();

        system.assertEquals(jobs + 1, [SELECT count() FROM CronTrigger],'A job should be scheduled');
    }
}
