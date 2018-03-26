({
	 doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.getTypeFromAccount");
        action.setParams({
            	recordId: recordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var acc = response.getReturnValue();
                component.set("v.accType", acc.Type);
                component.set("v.accObj", acc)
            }
        });
        
        $A.enqueueAction(action);
    },
	setOutput : function(component, event, helper) {
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
             "recordId": component.get("v.recordId")
        });
        editRecordEvent.fire();
	}
})