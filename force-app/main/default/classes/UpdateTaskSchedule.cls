global class UpdateTaskSchedule implements Schedulable{

   global void execute(Schedulablecontext sc){
        UpdateTasksBatch utb = new UpdateTasksBatch();
        //Database.executeBatch(instance,size);
        Database.executeBatch(utb,200);
    }

}