({
    getBMStatus: function (component, callback) {
        //resgata o cadastro de fornecedor a ser clonado
        console.log("Chamando serviço searchBMStatus");
        var recId = component.get("v.recordId");
        var action = component.get("c.searchBMStatus");

        action.setParams({
            recordId: recId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("Retorno: " + state);
            if (component.isValid() && state === "SUCCESS") {
                var statusBM = response.getReturnValue();
                console.log('Map retornado: ' + statusBM);
                if (statusBM === 'Aceita') {
                    component.set("v.StatusBoletim", true);
                    component.set("v.disabled", true);
                }
            } else {
                alert("Erro: " + records);
            }
        });
        $A.enqueueAction(action);
    },

    createDocumentation: function (component, callback) {
        //Cria o documentation e relacionado ele ao Anexo

        console.log("Chamando serviço relateToDocumentation");
        var listFilesIds = component.get("v.listAnexos");
        var isNF = component.get("v.fileIsNF");
        var recorId = component.get("v.recordId");
        var nfNumber = component.get("v.NFNumber");
        var action = component.get("c.relateToDocumentation");


        action.setParams({
            ListrecordId: listFilesIds,
            isNTAttachment: isNF,
            recId: recorId,
            NF: nfNumber
        });

        var messagemToast = "Documento criado.";
        if (isNF) {
            messagemToast = "NF anexada.";
        }


        console.log("request feito validando callback: relateToDocumentation");
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("Retorno: " + state);
            if (component.isValid() && state === "SUCCESS") {
                var resultado = response.getReturnValue();
                console.log('Retorno Criacao BM DOC ' + resultado);
                if (resultado === 'Sucesso') {
                    //apresentar toast de sucesso e fechar action.
                    console.log('BM doc criado com sucesso');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": messagemToast,
                        "mode": "pester",
                        "type": "success"
                    });
                    toastEvent.fire();

                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    console.log('Fechando quick action');
                    dismissActionPanel.fire();
                }
                else {
                    //apresentar toast de erro.
                    console.log('BM doc criado com sucesso');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": resultado,
                        "mode": "dismissible",
                        "type": "error"
                    });
                    toastEvent.fire();
                }
            } else {
                alert("Erro no controller APEX: ");
            }
        });
        $A.enqueueAction(action);
    },

    getUserId: function (component, callback) {
        //Busca user corrente para preenher no FileUpload
        console.log("Chamando serviço getCurrentUserId");
        var action = component.get("c.getCurrentUserId");


        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("Retorno: " + state);
            if (component.isValid() && state === "SUCCESS") {
                var userId = response.getReturnValue();
                console.log('Map retornado: ' + userId);
                component.set("v.userId", userId);

            } else {
                alert("Erro: " + userId);
            }
        });
        $A.enqueueAction(action);
    },

    getNFStatus: function (component, callback) {
        //resgata o cadastro de fornecedor a ser clonado
        console.log("Chamando serviço searchNFStatus");
        var recId = component.get("v.recordId");
        var action = component.get("c.searchNFStatus");

        action.setParams({
            recordId: recId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("Retorno: " + state);
            if (component.isValid() && state === "SUCCESS") {
                console.log("Response value " + response.getReturnValue());
                var nfDTO = JSON.parse(response.getReturnValue());
                console.log('Map nfDTO: ' + nfDTO);
                if (nfDTO.blockNF) {
                    console.log('bloqueio da NFDto ' + nfDTO.blockNF);
                    component.set("v.disabledNF", true);
                    component.set("v.disabledNFValue", 'No');
                    component.set("v.disabled", false);
                    component.set("v.warningMessage", nfDTO.message);
                }
            } else {
                alert("Erro: " + records);
            }
        });
        $A.enqueueAction(action);
    }
})