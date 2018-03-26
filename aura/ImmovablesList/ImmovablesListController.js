({
    	  doInit: function(component, event, helper) {
        // Create the action
        var action = component.get("c.getImmovables");
              action.setParams({ 
                  'typeIm' :component.get("v.selectedTypeImm"), 
                  'statusIm' : component.get("v.selectedStatusImm"),
                  'sortArea' : component.get("v.sortArea"),
                  'searchText': component.get("v.searchStr"),
              });
            
 			 //console.log( action.getParams(statusIm));
             // console.log( 'type: '+ action);
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.immovables", response.getReturnValue());
                //console.log(component.get("v.immovables"));
            }
            else {
                console.log("Failed with state: " + state);
            }
        });

         $A.enqueueAction(action);
              
              
        // for record type
        var actionRecType = component.get("c.fetchRecordTypeValues");
        actionRecType.setCallback(this, function(response) {
             component.set("v.lstOfRecordType", response.getReturnValue());
        });

        $A.enqueueAction(actionRecType);
    },
    
    
        handleupdateTypeEvent: function(component, event, helper) {
        var updatedType = event.getParam("typeVal");
        component.set("v.selectedTypeImm", updatedType);
        //console.log(component.get("v.selectedTypeImm"));
        
    },
    
    handleupdateStatusEvent: function(component, event, helper) {
        var updatedStatus = event.getParam("statusVal");
        component.set("v.selectedStatusImm", updatedStatus);
    },
    
    
    createAction: function(component, event, helper) {
        var objectName = event.getParam('value');
        switch(objectName){
            case 'Immovables' :
                //open modal window for record type
                component.set("v.isOpen", true);
                break;
            case 'Seller' :
                var createRecordEvent = $A.get("e.force:createRecord");
                    createRecordEvent.setParams({
                        "entityApiName": "Seller__c"
                  });
                createRecordEvent.fire();
                break;     
        }
    },
    
     closeModal: function(component, event, helper) {
      // set "isOpen" attribute to false for hide/close model box 
      component.set("v.isOpen", false);
   },
    
    
    createRecordImmovables: function(component, event, helper) {
      component.set("v.isOpen", true);
 
      var action = component.get("c.getRecTypeId");
      var recordTypeLabel = component.find("selectid").get("v.value");
      action.setParams({
         "recordTypeLabel": recordTypeLabel
      });
      action.setCallback(this, function(response) {
         var state = response.getState();
         if (state === "SUCCESS") {
            var createRecordEvent = $A.get("e.force:createRecord");
            var RecTypeID  = response.getReturnValue();
            createRecordEvent.setParams({
               "entityApiName": 'Immovables__c',
               "recordTypeId": RecTypeID
            });
            createRecordEvent.fire();
             
         } else if (state == "INCOMPLETE") {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
               "title": "Oops!",
               "message": "No Internet Connection"
            });
            toastEvent.fire();
             
         } else if (state == "ERROR") {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
               "title": "Error!",
               "message": "Please contact your administrator"
            });
            toastEvent.fire();
         }
      });
      $A.enqueueAction(action);
   },
	
   refresh: function(component, event, helper) {
       $A.get('e.force:refreshView').fire();
   },

	 openModelOf: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpenOffer", true);
   },
 
   closeModelOf: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpenOffer", false);
   },
 
   CloseOf: function(component, event, helper) {
      component.set("v.isOpenOffer", false);
   },   
    
    
    handleOpenOffers: function(component, event, helper) {
        component.set("v.isOpenOffer", event.getParam("openWinOf"));
        
        var parentId =  event.getParam("parentId");
        var action = component.get("c.getOffersByImm");
        action.setParams({ 
            'ImmovablesId' : parentId 
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.offers", response.getReturnValue());
                component.get("v.offers");
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
         $A.enqueueAction(action);
              
    },
    
    
    sort: function(component, event, helper){
        var sortFlag = component.get("v.sortArea");
    	component.set("v.sortArea", !sortFlag);
	},
    
    search: function(component, event, helper){
       component.set("v.searchStr", event.getSource().get("v.value"));
        //console.log( component.get("v.searchStr"));
    }
    
})