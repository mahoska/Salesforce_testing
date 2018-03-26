({
	doInit: function(component, event, helper) {

        // Create the action
        var action = component.get("c.getTypes");

        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.typesImmovables", response.getReturnValue());
                //console.log(component.get("v.typesImmovables"));
            }
            else {
                console.log("Failed with state: " + state);
            }
        });

        // Send action off to be executed
        $A.enqueueAction(action);
    },
    
    selectType: function(component, event, helper) {
        //console.log(1);
        var typeVal = event.getParam('value');
        
        var updateTypeEvent = component.getEvent("updateTypeEvent");
        updateTypeEvent.setParams({ "typeVal": typeVal });
        updateTypeEvent.fire();
    },
    
    
  
    
    

})