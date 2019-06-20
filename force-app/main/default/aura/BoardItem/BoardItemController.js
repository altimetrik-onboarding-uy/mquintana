({
    doInit : function(cmp, event, helper) {
        
    },

    handleSelectStatus : function(cmp, event, helper){
        var selectedStatus= event.getParam("value");
        var compEvent = cmp.getEvent("changeTaskStatusEvent");
        var task = cmp.get("v.item");
        compEvent.setParams({
            "taskId" : task.Id, 
            "taskNewStatus" : selectedStatus
        });
        compEvent.fire();
    },

    navigateToTask : function(cmp, event, helper){
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": cmp.get("v.item").Id
        });
        navEvt.fire();
    },

    addPoints : function(cmp, event, helper){
        var compEvent = cmp.getEvent("changeHabitPointsEvent");
        var task = cmp.get("v.item");
        compEvent.setParams({
            "taskId" : task.Id, 
            "taskAction" : 'add'
        });
        compEvent.fire();  
        cmp.set("v.addHits", cmp.get("v.addHits")+1);
        cmp.set("v.item.Task_Completed__c", true);  
    },

    subtractPoints : function(cmp, event, helper){
        var compEvent = cmp.getEvent("changeHabitPointsEvent");
        var task = cmp.get("v.item");
        compEvent.setParams({
            "taskId" : task.Id, 
            "taskAction" : 'subtract'
        });
        compEvent.fire();
        cmp.set("v.subtractHits", cmp.get("v.subtractHits")+1);
        cmp.set("v.item.Habit_Failed__c", true); 
        cmp.set("v.item.Task_Completed__c", true); 
    }
})
