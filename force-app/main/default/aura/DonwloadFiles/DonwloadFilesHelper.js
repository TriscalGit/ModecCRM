({
    toastEvent : function(title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,  // Erro --> "error" | Sucesso --> "success" | Informação --> "info"
            "message": message
        });
        toastEvent.fire();
    },
    
    redirecionamentoComRefresh : function(component) {
        $A.get('e.force:refreshView').fire();
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId"),
            "slideDevName": "related"
        });
        navEvt.fire();
    }
})