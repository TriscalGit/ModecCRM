({
    createDocumentationVVWDOC: function (component, callback) {

        console.log("Chamando serviço create Documentatioan");

        var action = component.get("c.createDocumentationVVWAuxiliar");

        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("Retorno: " + state);
            if (component.isValid() && state === "SUCCESS") {
                var auxDocumentationId = response.getReturnValue();
                console.log('id doc criado:' + auxDocumentationId);
                component.set("v.documentationId", auxDocumentationId);
            } else {
                alert("Erro: " + records);
            }
        });
        $A.enqueueAction(action);
    },

    updateDocumentationVVW: function (component, callback) {

        console.log("Chamando serviço update Documentatioan");
        var documentId = component.get("v.documentationId");
        var step = component.get("v.recordId");
        var coment = component.find("Commentfield").get("v.value");
        console.log("Id do step: " + step);
        console.log("documentId: " + documentId);
        console.log("coment: " + coment);

        var action = component.get("c.updateDocumentationVVWAuxiliar");

        action.setParams({
            documentId: documentId,
            relatedObjectId: step,
            comentarios: coment
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("Retorno: " + state);
            if (component.isValid() && state === "SUCCESS") {
                var auxDocumentationId = response.getReturnValue();
                console.log('id doc atualizado:' + auxDocumentationId);
                component.set("v.documentationId", auxDocumentationId);

                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": auxDocumentationId,
                    "slideDevName": "detail"
                });
                navEvt.fire();
            } else {
                alert("Erro: " + records);
            }
        });
        $A.enqueueAction(action);
    }
})