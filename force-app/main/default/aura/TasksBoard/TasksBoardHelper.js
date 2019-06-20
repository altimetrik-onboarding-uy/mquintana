({
    getTasks : function(cmp) {
        var action = cmp.get("c.getAllTasks");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                console.log(JSON.parse(JSON.stringify(returnValue)));
                var todos = [];
                var dailies = [];
                var habits = [];
                returnValue.forEach(element => {
                    if(element.RecordType.Name == 'TO-DO'){
                        todos.push(element);
                    }else if(element.RecordType.Name == 'Daily'){
                        dailies.push(element);
                    }else if(element.RecordType.Name == 'Habit'){
                        habits.push(element);
                    }
                });
                cmp.set("v.todoItems", todos);
                cmp.set("v.dailyItems", dailies);
                cmp.set("v.habitItems", habits);
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    setNewStatus : function(cmp, taskId, taskStatus){
        var helper = this;
        var action = cmp.get("c.setNewStatus");
        action.setParams({
            'taskId': taskId,
            'taskStatus' : taskStatus
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("SUCCESS");
                helper.findTask(cmp, taskId, taskStatus);
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        
    },

    findTask : function(cmp, taskId, status){
        var todoItems = cmp.get("v.todoItems");
        var dailyItems = cmp.get("v.dailyItems");
        var wasFound = todoItems.find((o, i) => {
            if (o.Id == taskId) {
                if(status=="Completed"){
                    todoItems.splice(i, 1);
                }else{
                    todoItems[i].Status__c = status;
                }
                return true; // stop searching
            }
        });
        if(!wasFound){
            wasFound = dailyItems.find((o, i) => {
                if (o.Id == taskId) {
                    if(status=="Completed"){
                        dailyItems.splice(i, 1);
                    }else{
                        dailyItems[i].Status__c = status;
                    }
                    return true; // stop searching
                }
            });
        }else{
            cmp.set("v.todoItems", todoItems);
        }
        if(wasFound){
            cmp.set("v.dailyItems", dailyItems); 
        }

    },

    setNewHabitPoints : function(cmp, taskId, taskAction){
        var helper = this;
        var action = cmp.get("c.setHabitPoints");
        action.setParams({
            'taskId': taskId,
            'taskAction' : taskAction
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.showToast('Success!', 'Points updated successfully', 'success');
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                helper.showToast('Error!', 'Something went wrong', 'error');
            }
        });
        $A.enqueueAction(action);
    },

    showToast : function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    }
})
