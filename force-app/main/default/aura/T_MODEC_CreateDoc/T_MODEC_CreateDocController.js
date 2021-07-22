({
    init: function (component, event, helper) {
        component.set("v.container1", true);
        component.set("v.container2", false);
        helper.getlistRecTypes(component);
        helper.getMapRecTypes(component);
        helper.getTypeOfRecordId(component, helper);
    },
  
    handleLoad: function (cmp, event, helper) {
      cmp.set('v.showSpinner', false);
    },
  
    handleSubmit: function (cmp, event, helper) {
      cmp.set('v.disabled', true);
      cmp.set('v.showSpinner', true);
    },
  
    handleError: function (cmp, event, helper) {
      // errors are handled by lightning:inputField and lightning:messages
      // so this just hides the spinner
      cmp.set('v.showSpinner', false);
    },
  
    handleSuccess: function (cmp, event, helper) {
      var params = event.getParams();
      cmp.set('v.recordId', params.response.id);
      cmp.set('v.showSpinner', false);
      cmp.set('v.saved', true);
    },
  
    SwitchToPage2: function (component, event, helper) {
      var container1 = component.get("v.container1");
      var container2 = component.get("v.container2");
  
      component.set("v.container1", false);
      component.set("v.container2", true);
      
      helper.createDocumentationAux(component);
    },
  
    SwitchBackToPage1: function (component, event, helper) {
      var container1 = component.get("v.container1");
      var container2 = component.get("v.container2");
  
      component.set("v.container1", true);
      component.set("v.container2", false);
      helper.getlistRecTypes(component);
    },
  
    handleUploadFinished: function (cmp, event) {
      // This will contain the List of File uploaded data and status
      var uploadedFiles = event.getParam("files");
      console.log('Arquivo: '+uploadedFiles);
      var listaAnexos = cmp.get("v.listAttachments");
      for (var i = 0; i < uploadedFiles.length; i++) {
        console.log('Arquivo: '+uploadedFiles[i].name);
        listaAnexos.push(uploadedFiles[i].name);
      }
      cmp.set("v.listAttachments", listaAnexos);
    },
  
    handleChangerecType: function (cmp, event) {
      var changeValue = event.getParam("value");
      cmp.set("v.recordTypeIdChecked",changeValue);
      console.log('Valor selecionado rectypeid :'+changeValue);
      var mapRecTypes = cmp.get("v.mapRecordTypes");
  
      for (var recId in mapRecTypes) {
        if (recId == changeValue) {
          console.log('map value: '+mapRecTypes[recId]);
          cmp.set("v.recordTypeName",mapRecTypes[recId]);
        }
      }
         
      
  
    },
  
    saveDocumentation: function (cmp, event, helper) {
      console.log('Salvar acionado');
      helper.updateDocumentationAux(cmp);
      //cmp.set('v.showSpinner', true);
    },
    //finishCreateDocument: function(component, event, helper) {
    //var createDocumentSelecionado = component.get("v.CreateDocumentationRequestDto");
    //}
  
  });