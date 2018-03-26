({
	doInit : function(component, event, helper) {
		var action = component.get("c.getSimilarImmovables");
        action.setParams({
            recordId: component.get("v.recordId"),
            rooms: component.get("v.immovablesItem.fields.Number_of_rooms__c.value"),
            baths: component.get("v.immovablesItem.fields.Number_of_bathrooms__c.value"),
            
        });
        console.log(component.get("v.immovablesItem.fields.Type__c.value"))
       action.setCallback(this, function(response){
            var similarImmovables = response.getReturnValue();
            component.set("v.similarImmovables", similarImmovables);
        });
        $A.enqueueAction(action);

	}
})