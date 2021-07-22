({    
    invoke : function(component, event, helper) {
        var record = component.get("v.recordId");
        var navEvt;
        
        $A.get('e.force:refreshView').fire();
        
        if(record != null){
            navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": record,
                "slideDevName": "related"
            });
        } else {
        	navEvt = $A.get("e.force:navigateToURL").setParams({"url": component.get("v.URL")});
        }
        
        navEvt.fire();
    }
})