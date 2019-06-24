global class SendEmailDailySchedule implements Schedulable{
    
    global void execute(Schedulablecontext sc){
        SendEmailDailyBatch sed = new SendEmailDailyBatch();
        //Database.executeBatch(instance,size);
        Database.executeBatch(sed,200);
    }

}
