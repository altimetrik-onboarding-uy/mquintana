@isTest
private class SendEmailDailyScheduleTest {
    
    @isTest
    private static void runScheduleEmailDaily(){
        String cronExpr = '0 0 0 15 3 ? 2022';
        Integer jobs = [SELECT count() FROM CronTrigger];
        Test.startTest();
        SendEmailDailySchedule sed= new SendEmailDailySchedule();
        String jobId = System.schedule('sendEmailJob', cronExpr, sed);
        sed.execute(null);
        Test.stopTest();

        system.assertEquals(jobs + 1, [SELECT count() FROM CronTrigger],'A job should be scheduled');
    }
}
