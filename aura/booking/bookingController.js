({
	  doInit: function(component, event, helper) {
        var localDate = new Date();
        var month = [
            "January", "February", "March", "April",
            "May", "June", "July", "August", "September",
            "October", "November", "December"
        ];
        var weekDay = [
            "Sunday", "Monday", "Tuesday", "Wednesday",
            "Thursday", "Friday", "Sataday"
        ] ;
		component.set("v.data", 
            [
             month[localDate.getMonth()]+" "+localDate.getDate()+", "+localDate.getFullYear(), 
             weekDay[localDate.getDay()]
            ]);

        //var action = component.get("c.getDayPart");
        var action = component.get("c.getDayPartList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //component.set("v.dayParts", response.getReturnValue());
				//var map = component.get("v.dayParts")[0];
                //component.set("v.dayPartList", Object.keys(map));
                component.set("v.dayPartList",response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });

         $A.enqueueAction(action);
      } ,
    
    createTable: function(component, event, helper) {
        var timeFormat = component.get("v.timeFormat")
        var dayPart = event.getSource().get("v.label");
        
        var action = component.get("c.getDayPartInfo");
         action.setParams({ 
                  'namePart' :dayPart, 
         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var part = response.getReturnValue();
                var begining = part['Begining__c'];
                var ending = part['Ending__c'];
                var sep = part['TimeSeparator__c'];
                var timeArr=[];
                for(var i = begining, h=0; i<ending ;){
                    //timeArr.push(i + ":" + (h==0?'00':h));
                    var strFormat = (timeFormat=='eng' && i>12 )?'pm':'am'
                    timeArr.push((timeFormat=='eng' && i>12? i-12 : i) + ":" + (h==0?'00':h) +" "+ (timeFormat=='eng'? strFormat: '') );
                    h+=sep;
                    if(h==60){
                        h=0;
                        i++;
                    }
                }
                //timeArr.push(i + ":" + (h==0?'00':h));
                
                component.set("v.selectedDayPartTime", timeArr);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });

       $A.enqueueAction(action);
    },
    
    
    selectRadio: function(component, event, helper) {
     	var timeFormat = event.currentTarget.dataset.value;
        component.set("v.timeFormat",timeFormat );
        //console.log(component.get("v.timeFormat"))
	}
})