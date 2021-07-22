({
	invoke : function(component, event, helper) {
        var type = component.get("v.Type");
        var duration = component.get("v.Duration");
        var title = type;
        
        if(duration == null || duration == ''){
            duration = 5000;
        } else {
            duration = duration * 1000;
        }
        
        type = type.toLowerCase();
		var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "duration": duration,
            "message": component.get("v.Message")
        });
        toastEvent.fire();
	}
})