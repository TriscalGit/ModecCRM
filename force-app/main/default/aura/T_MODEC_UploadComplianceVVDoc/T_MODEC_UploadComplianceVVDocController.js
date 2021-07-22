({
    init: function (component, event, helper) {

        console.log("Upload Compliance VVWDoc Iniciado :");

        helper.createDocumentationVVWDOC(component);
    },

    handleUploadFinished: function (cmp, event) {
        // This will contain the List of File uploaded data and status
        var uploadedFiles = event.getParam("files");
        console.log('Arquivo: ' + uploadedFiles);
        var listaAnexos = cmp.get("v.listAttachments");
        for (var i = 0; i < uploadedFiles.length; i++) {
            console.log('Arquivo: ' + uploadedFiles[i].name);
            listaAnexos.push(uploadedFiles[i].name);
        }
        cmp.set("v.listAttachments", listaAnexos);
        cmp.set("v.fileUploaded", true);
    },

    saveDocumentation: function (cmp, event, helper) {
        console.log('Salvar acionado');
        var fileUpload = cmp.get("v.fileUploaded");
        if (fileUpload) {
            console.log('Salvando Documentation VVW');
            helper.updateDocumentationVVW(cmp);
        }
        else {
            console.log('No file uploaded');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Warning!",
                "message": "Please upload a pdf file before saving.",
                "mode": "pester",
                "type": "warning"
            });
            toastEvent.fire();
        }
    }
})