({
    doInit : function(cmp, event, helper){
        var item = cmp.get("v.item");
        if(item.Habit_Failed__c){
            cmp.set("v.subtractHits", 1);
        }else if(item.Task_Completed__c){
            cmp.set("v.addHits", 1);
        }
    },

    handleSelectStatus : function(cmp, event, helper){
        helper.fireChangeStatusEvent(cmp, event.getParam("value"));
    },

    navigateToTask : function(cmp, event, helper){
        helper.navigateToRecord(cmp.get("v.item").Id);
    },

    addPoints : function(cmp, event, helper){
        helper.changePoints(cmp, 'add');
    },

    subtractPoints : function(cmp, event, helper){
        helper.changePoints(cmp, 'subtract');
    }
})
