({
	navigateToDetailsView : function(immId) {
        var event = $A.get("e.force:navigateToSObject");
        event.setParams({
            "recordId": immId
        });
        event.fire();
    }
})