({
    sendBMtoSAP: function (component, callback) {
        //resgata o cadastro de fornecedor a ser clonado
        console.log("Chamando serviço sendRequest");
        var action = component.get("c.sendRequest");
        var bmId = component.get("v.recordId");

        console.log("id do bm: "+bmId);

        action.setParams({
            requestId: bmId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("Retorno: " + state);
            if (component.isValid() && state === "SUCCESS") {
                var responseDTO = response.getReturnValue();
                var result = JSON.parse(responseDTO);
                console.log('Dto Retornado: ' + result);
                console.log('Status: ' + result.status_SAP);
                if(result.status_SAP == 'I'){
                    component.set('v.showMsgError', false);
                    component.set('v.showMsgValidation', true);
                    component.set('v.showMsgSuccess', false);
                }
                if(result.status_SAP == 'S'){
                    component.set('v.showMsgError', false);
                    component.set('v.showMsgValidation', false);
                    component.set('v.showMsgSuccess', true);
                }
                if(result.status_SAP == 'E'){
                    component.set('v.showMsgError', true);
                    component.set('v.showMsgValidation', false);
                    component.set('v.showMsgSuccess', false);
                }
                component.set("v.ListMessages", result.messages_SAP);
                component.set('v.disableButton', false);
                component.set('v.loaded', true);
                component.set('v.showMsgList', true);
            } else {
                alert("Erro: " + response);
                component.set('v.disableButton', false);
                component.set('v.loaded', true);
            }
        });
        $A.enqueueAction(action);
    }
})