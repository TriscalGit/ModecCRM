({
    init: function (component, event, helper) {

        console.log("Anexo Fornecedor Iniciado :");

        helper.getBMStatus(component);
        helper.getNFStatus(component);
        helper.getUserId(component);

        //Validate if browser is IE 11 or below.
        if (navigator.userAgent.indexOf('MSIE') !== -1
            || navigator.appVersion.indexOf('Trident/') > -1) {
            /* Microsoft Internet Explorer detected in. */            
            console.log('Browser é IE!');
            component.set("v.browserIsIE", true);
        }
        else{            
            console.log('Browser não é IE.!');
        }
    },

    handleUploadFinished: function (component, event, helper) {
        // This will contain the List of File uploaded data and status
        var uploadedFiles = event.getParam("files");
        //alert("Files uploaded : " + uploadedFiles.length);   
        var UploadFeitos = component.get("v.listUploadFeitos");
        var listFiles = component.get("v.listAnexos");
        console.log("controller handleUploadFinished");
        for (var i = 0; i < uploadedFiles.length; i++) {
            listFiles.push(uploadedFiles[i].documentId);
            console.log("id do documento" + uploadedFiles[i].documentId);
            UploadFeitos.push(uploadedFiles[i].name);
        }
        component.set("v.listAnexos", listFiles);
        component.set("v.listUploadFeitos", UploadFeitos);
        component.set("v.fileUploaded", true);
        console.log("UploadFeitos: " + UploadFeitos);
        console.log("listFiles: " + listFiles);
        //Validando que somente um arquivo é anexado para criação de Documentation do tipo NF Attachment
        var isNFModecCmp = component.find("isNFModec");
        console.log("isNFModecCmp: " ,isNFModecCmp);
        if(isNFModecCmp !== undefined){
            var nfPicklist = isNFModecCmp.get("v.value");
            console.log("nfPicklist >"+nfPicklist);
            console.log("listFiles >"+listFiles.length);
            if(listFiles.length === 1 && nfPicklist === "Yes"){
                console.log("Blocking future uploads");
                component.set("v.disabled", true);
                component.set("v.disabledNF", true);
            }
        }


    },

    selecionadoNF: function (component, event) {

        var selectedValue = component.find('isNFModec').get("v.value");
        //event.getParam("value");
        console.log('Valor escolhido' + selectedValue);
        if (selectedValue == 'NoChoice') {
            component.set("v.disabled", true);
            component.set("v.fileIsNF", false);
            component.set("v.ButtonText", "Criar documento do BM");
        }
        if (selectedValue == 'Yes') {
            component.set("v.disabled", true);
            component.set("v.multiple", false);
            component.set("v.fileIsNF", true);
            component.set("v.ButtonText", "Anexar nota fiscal");
        }
        if (selectedValue == 'No') {
            component.set("v.disabled", false);
            component.set("v.multiple", true);
            component.set("v.fileIsNF", false);
            component.set("v.ButtonText", "Criar documento do BM");
        }

        //alert("Files uploaded : " + uploadedFiles.length);
    },

    onchangeNfField: function (component, event, helper) {
        // Validate if the NF field is correct        
        console.log("Enter validate NF field");
        var validity = component.find("nfNumber").get("v.validity");
        console.log(validity.valid); //returns true

        if (validity.valid) {
            console.log("NF Válida!");
            component.set("v.disabled", false);
            component.set("v.multiple", false);
        } else {
            console.log("NF Inválida!");
            component.set("v.disabled", true);
            component.set("v.multiple", false);
        }
        //component.set("v.listAnexos", listFiles);
        //component.set("v.listUploadFeitos",UploadFeitos);
        //console.log("UploadFeitos: "+UploadFeitos);
        //console.log("listFiles: "+listFiles);

    },

    saveDocumentation: function (component, event, helper) {

        console.log('Salvar acionado');
        var fileUpload = component.get("v.fileUploaded");
        if (fileUpload) {
            console.log("Salvando Documentation BM.");
            component.set("v.blockSaveButton",true);
            helper.createDocumentation(component);
        }
        else {
            console.log('No file uploaded');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Warning!",
                "message": "Faça o upload de um arquivo.",
                "mode": "pester",
                "type": "warning"
            });
            toastEvent.fire();
        }

    }



});