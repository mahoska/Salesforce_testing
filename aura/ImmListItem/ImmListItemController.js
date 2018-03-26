({
	immSelected : function(component) {
        var event = $A.get("e.c:ImmSelectedLoc");
        event.setParams({"immovables": component.get("v.immovablesItem")});
        event.fire();
    }
})