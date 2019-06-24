({
    changePoints : function(cmp, typeOfChange) {
        
        var compEvent = cmp.getEvent("changeHabitPointsEvent");
        var task = cmp.get("v.item");
        compEvent.setParams({
            "taskId" : task.Id, 
            "taskAction" : typeOfChange
        });
        compEvent.fire(); 

        if(typeOfChange == 'add'){
            cmp.set("v.addHits", cmp.get("v.addHits")+1);
            cmp.set("v.item.Task_Completed__c", true); 
        }else if(typeOfChange == 'subtract'){
            cmp.set("v.subtractHits", cmp.get("v.subtractHits")+1);
            cmp.set("v.item.Habit_Failed__c", true); 
            cmp.set("v.item.Task_Completed__c", true); 
        }

    },

    fireChangeStatusEvent : function(cmp, selectedStatus){
        var compEvent = cmp.getEvent("changeTaskStatusEvent");
        var task = cmp.get("v.item");
        compEvent.setParams({
            "taskId" : task.Id, 
            "taskNewStatus" : selectedStatus
        });
        compEvent.fire();
    },

    navigateToRecord : function(recordId){
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId
        });
        navEvt.fire();
    }
})
