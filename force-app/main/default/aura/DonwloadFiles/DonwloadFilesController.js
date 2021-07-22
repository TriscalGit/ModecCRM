({
	init: function (component, event, helper) {
        var actionGetFilesURLs = component.get("c.getContentDocumentLinks");
        var record = component.get("v.recordId");
        actionGetFilesURLs.setParams({ 
            "recordId": record
        });
        actionGetFilesURLs.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var values = response.getReturnValue();
                component.set("v.arquivos", values);
                component.set("v.step", 1);
            } else {
                helper.toastEvent("Error","error","We could not find the files.");
                helper.redirecionamentoComRefresh(component);
            }
        });
        $A.enqueueAction(actionGetFilesURLs);
	},
    
    download : function (component, event, helper) {
        var actionGetOrgURL = component.get("c.getOrgURL");
        actionGetOrgURL.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var values = response.getReturnValue();
                var arquivos = component.get("v.arquivosRetorno");
                if(arquivos != null && arquivos.length > 0){
                    for (var index in arquivos) {
                        var url = values + 'sfc/servlet.shepherd/document/download/' + arquivos[index].Id + '?operationContext=S1';
                        window.open(url);
                    }
                } else {
                    helper.toastEvent("Error","error","We could not find the files.");
                }
            } else {
                helper.toastEvent("Error","error","Error when get the current URL.");
            }
            helper.redirecionamentoComRefresh(component);
        });
        $A.enqueueAction(actionGetOrgURL);
    },
    
    cancelar : function (component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})