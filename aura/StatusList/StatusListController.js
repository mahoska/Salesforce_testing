({
	doInit: function(component, event, helper) {
		
        // Create the action
        var action = component.get("c.getStatus");
	
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
        
            if (state === "SUCCESS") {
                component.set("v.statusItem", response.getReturnValue());
                //console.log("TEST"+component.get("v.statusItem"));
            }
            else {
                console.log("Failed with state: " + state);
            }
        })
         // Send action off to be executed
        $A.enqueueAction(action);
    },
    
    
    selectStatus: function(component, event, helper) {
        //console.log(1);
        var statusVal = event.getParam('value');
        var updateStatusEvent = component.getEvent("updateStatusEvent");
        updateStatusEvent.setParams({ "statusVal": statusVal });
        updateStatusEvent.fire();
    },
    
})