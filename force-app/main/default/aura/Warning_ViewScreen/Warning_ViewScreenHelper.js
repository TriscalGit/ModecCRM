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
    
    SearchWarnings : function(component, event, helper) {
        var actionGetWarnings = component.get("c.getWarning");
        actionGetWarnings.setParams({
            DateToOrdenate: component.get("v.warningDateToOrder"),
            Order: component.get("v.warningOrders")
        });
        
        actionGetWarnings.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var dados = response.getReturnValue();
                component.set("v.TotalNumberOfWarnings", dados.length);
                component.set("v.Warnings", dados);
            } else {
                helper.toastEvent("Error","error","Error to get records.");
            }
        });
        $A.enqueueAction(actionGetWarnings);
    }
})