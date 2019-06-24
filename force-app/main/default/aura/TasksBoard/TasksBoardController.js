({
    doInit : function(cmp, event, helper) {
        helper.getTasks(cmp);
    },

    handleChangeStatusEvent : function(cmp, event, helper){
        helper.setNewStatus(cmp, event.getParam("taskId"), event.getParam("taskNewStatus"));
    },

    handleChangeHabitEvent : function(cmp, event, helper){
        helper.setNewHabitPoints(cmp, event.getParam("taskId"), event.getParam("taskAction"));
    }
})
