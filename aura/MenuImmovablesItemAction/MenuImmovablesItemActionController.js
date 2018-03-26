({
     createItems: function (component, event) {
        var items = [
            { label: "edit", value: "edit" },
            { label: "delete", value: "delete" },
            { label: "show offers", value: "offer" }
        ];
        component.set("v.actions", items);
     },
    
	 handleMenuSelect: function(component, event, helper) {
    	var selectedMenuItemValue = event.getParam("value");
         switch(selectedMenuItemValue){
         case "edit":
             var editRecordEvent = $A.get("e.force:editRecord");
             editRecordEvent.setParams({
                 "recordId": component.get("v.immovablesItem.Id")
           	 });
             editRecordEvent.fire();

             break;
         case "delete":
              var action = component.get("c.deleteRecord");
              action.setParams({ 
                  'recordId' :component.get("v.immovablesItem.Id")
              });
                // Add callback behavior for when response is received
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var res = response.getReturnValue();
                       
                        var toastEvent = $A.get("e.force:showToast");
                        if(res>0){     
                            
                            toastEvent.setParams({
                                title : 'Success Message',
                                message: 'deletion was successful',
                                messageTemplate: 'deleted {0} records successfully',
                                messageTemplateData: [res.toString()],
                                duration:' 5000',
                                key: 'info_alt',
                                type: 'success',
                                mode: 'pester'
                            });
                            toastEvent.fire();
                            $A.get('e.force:refreshView').fire();
                        }else if(res==-1){
                             toastEvent.setParams({
                                title : 'Error Message',
                                message:'error deleting record',
                                messageTemplate: 'error deleting record',
                                duration:' 5000',
                                key: 'info_alt',
                                type: 'error',
                                mode: 'pester'
                            });
                            toastEvent.fire();
                        }else if(res==-2){
                             toastEvent.setParams({
                                title : 'Info Message',
                                message:'no record to be deleted',
                                messageTemplate: 'no record to be deleted',
                                duration:' 5000',
                                 key: 'info_alt',
                                type: 'info',
                                mode: 'dismissible'
                            });
                            toastEvent.fire();
                        }  
                    }
                    else {
                        console.log("Failed with state: " + state);
                    }
                });
                 $A.enqueueAction(action);
             break;
         case "offer":
             var openOfWinEvent = component.getEvent("openOffers");
             openOfWinEvent.setParams({ 
                 "openWinOf": true, 
                 "parentId" : component.get("v.immovablesItem.Id")
             });
             openOfWinEvent.fire();
             break;
         }
        
	},
  
   test: function(component, event, helper) {
       //console.log('ttt')
   },
    
    
})