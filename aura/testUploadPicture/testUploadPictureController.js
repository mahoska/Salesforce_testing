({
    doInit: function(component, event, helper){
        //var files = component.get("v.images");
        var action = component.get("c.getAttachs");
              action.setParams({ 
                  'parentId' : 'a001r00000nrxtCAAQ'
              });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.images", response.getReturnValue());
                console.log(component.get("v.images"));
            }
            else {
                console.log("Failed with state: " + state);
            }
        });

         $A.enqueueAction(action);
    },
    
	onFileUploaded : function(component, event, helper) {
		var files = component.get("v.fileToBeUploaded");
        if (files && files.length > 0) {
            var file = files[0][0];
            var reader = new FileReader();
            reader.onloadend = function() {
                console.log('onloadend')
                var dataURL = reader.result;
                var content = dataURL.match(/,(.*)$/)[1];
                helper.upload(component, file, content, function(answer) {
                    if (answer) {
                         console.log('Success')
                        // Success
                    }
                    else{
                          console.log('Failure')
                        // Failure
                    }
                });
            }
              if (file) {
                reader.readAsDataURL(file);
              } else {
                console.log('no file')
              }
        }
	}
})