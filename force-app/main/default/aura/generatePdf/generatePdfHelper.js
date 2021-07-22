({
    savePdf : function(component) {
		var recordId = component.get('v.recordId');
		var sObjectName = component.get('v.sObjectName');
		var action = component.get("c.savePdf");
		action.setParams({ recordId, sObjectName });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				$A.get('e.force:refreshView').fire();
				$A.get("e.force:closeQuickAction").fire();
				this.fireNotification('Success', 'Pdf successfully generated', 'success', 5000);
            }
			else {
				$A.get("e.force:closeQuickAction").fire();
				this.fireNotification('Error', 'Unknown error', 'error', 5000);
			}
        });
        $A.enqueueAction(action);
	},
	
	fireNotification: function(title, message, type, duration){
	    var notification = $A.get("e.force:showToast");
	    notification.setParams({
	    	type: type,
	    	title: title,
	        mode: 'dismissible',
	        duration: duration ? duration : 15,
	        message: message
	    });
	    notification.fire();
	}
})