({
	 doInit : function(component, event) {
        var action = component.get("c.findAllWithLocation");
        action.setCallback(this, function(a) {
            component.set("v.immovables", a.getReturnValue());
            window.setTimeout($A.getCallback(function() {
                var event = $A.get("e.c:ImmLoadedLoc");
                event.setParams({"immovables": a.getReturnValue()});
                event.fire();
            }), 500);
        });
        $A.enqueueAction(action);
    }
})