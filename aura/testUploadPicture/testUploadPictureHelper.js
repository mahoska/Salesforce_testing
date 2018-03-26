({
	 upload: function(component, file, base64Data, callback) {
        var action = component.get("c.uploadFile");
        console.log('type: ' + file.type);
        action.setParams({
            fileName: file.name,
            base64Data: base64Data,
            contentType: file.type
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                  console.log("SUCCESS in helper" );
                callback(a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
})