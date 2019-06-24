global class SendEmailDailyBatch implements Database.Batchable<sObject>, Database.Stateful{
    
    @TestVisible static Integer emailLimits;
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Status__c, Name, RecordType.Name, Employee__c, Employee__r.Name, Employee__r.Email  FROM Task__c WHERE RecordType.Name = \'Daily\' AND Status__c != \'Completed\'';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Task__c> scope){
        Map<String, List<Task__c>> contactTasksMap = new Map<String, List<Task__c>>();
        Map<String, String> contactEmailMap = new Map<String, String>();
        for(Task__c t : scope){
            contactEmailMap.put(t.Employee__c, t.Employee__r.Email);
            if(contactTasksMap.containsKey(t.Employee__c)){
                List<Task__c> tasks = contactTasksMap.get(t.Employee__c);
                tasks.add(t);
                contactTasksMap.put(t.Employee__c, tasks);
            }else{
                contactTasksMap.put(t.Employee__c, new List<Task__c>{t});
            }
        }
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        for(String contact : contactEmailMap.keySet()){
            List<Task__c> tasks = contactTasksMap.get(contact);
            String taskName = '';
            for(Task__c t : tasks){
                taskName += t.Name + '<br/>';
            }         
            Messaging.SingleEmailMessage Message = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {contactEmailMap.get(contact)};
            Message.setToAddresses(toAddresses); 
            Message.SaveAsActivity = false;
            Message.setHtmlBody('Hello, <br/><br/>The following daily tasks werent completed today: <br/>' + taskName + '<br/><br/>Regards<br/> Developer');
            mailList.add(Message);
        }

        if(!mailList.isEmpty()) {
            try{
                Messaging.sendEmail(mailList);
            }catch (Exception ex) {
                System.debug('Unable to send email. Here\'s the reason: '+ ex.getStackTraceString());
            }
        }
        emailLimits = Limits.getEmailInvocations();
        
    }  
    global void finish(Database.BatchableContext BC){
        //Chain batches needed.
        //This will prevent any kind of mismatch between the two batches.
        UpdateTasksBatch utb = new UpdateTasksBatch();
        Database.executeBatch(utb,200);
  
    }
  
  

}
