({
    invoke : function(component, event, helper) { 
        var urlEvt = $A.get("e.force:navigateToURL");
        urlEvt.setParams({
            "url" : "/lightning/o/Task/list?filterName=Recent"
        });
        urlEvt.fire();
    }
})