({
    getlistRecTypes: function (component, callback) {
  
      console.log("Chamando serviço getlistRecTypesDocumentation");
      var action = component.get("c.getlistRecTypesDocumentation");
      var recId = component.get("v.recordId");
      action.setParams({
        recordID:recId
      });
  
      action.setCallback(this, function (response) {
        var state = response.getState();
        console.log("Retorno: " + state);
        if (component.isValid() && state === "SUCCESS") {
          var listRecTypesDocumentation = response.getReturnValue();
          console.log(listRecTypesDocumentation);
          component.set("v.listRecTypesDocumentation", listRecTypesDocumentation);
        } else {
          alert("Erro: " + records);
        }
      });
      $A.enqueueAction(action);
    },
    
    getTypeOfRecordId: function (component, helper) {
        //Variables
        var action = component.get("c.getTypeOfRecordId");
        var recordId = component.get("v.recordId");
        
        action.setParams({
            recordID:recordId
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                component.set("v.SObjectType", resp);
                helper.verifySObjectTypeAndGetRecord(component, helper);         //GUFS_Merge
            } else {
                alert("Erro: " + response); //trocar isso para o erro bonito
            }
        });
        $A.enqueueAction(action);
    },
    
    verifySObjectTypeAndGetRecord : function (component, helper) {         //GUFS_Merge
        var SObjectType = component.get("v.SObjectType");
        
        if(SObjectType == 'TW1_Request__c'){
            helper.getRecord(component, 'RecordType.DeveloperName');         //GUFS_Merge
        } else if(SObjectType == 'TOBJ_AvaliacaoHSE__c') {
            component.set("v.isDisplayError",true);
        }
    },
    
    getRecord: function (component, campos) {
        //Variables
        var action = component.get("c.getMainSObjectRecordFromRecordId");
        var recordId = component.get("v.recordId");
        
        action.setParams({
            recordID:recordId,
            campos: campos
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                component.set("v.SObjectRecord", resp);
                var SObjectType = component.get("v.SObjectType");         //GUFS_Merge
                
                if(SObjectType == 'TW1_Request__c'){         //GUFS_Merge
                    
                    if(resp.RecordType.DeveloperName == 'T_PO_Review_Form') {         //GUFS_Merge
                        component.set("v.accept", "['.zip']");         //GUFS_Merge
                        
                    } else if(resp.RecordType.DeveloperName == 'Inspection' && (         //GUFS_Merge
                        resp.TW1_Inspection_Status__c == 'Approved' ||
                        resp.TW1_Inspection_Status__c == 'Approved with Restriction' ||
                        resp.TW1_Inspection_Status__c == 'Canceled' ||
                        resp.TW1_Inspection_Status__c == 'Rejected' ||
                        resp.TW1_Inspection_Status__c == 'Reproved')) {
                        component.set("v.isDisplayError",true);
                        component.set("v.isGenericError",true);
                    }
                }
            } else {
                alert("Erro: " + response);
            }
        });
        $A.enqueueAction(action);
    },
    
    
    getMapRecTypes: function (component, callback) {
  
      console.log("Chamando serviço getMapRecTypes");
      var action = component.get("c.getRectypeMap");
      var recId = component.get("v.recordId");
      action.setParams({
        recordID:recId
      });
  
      action.setCallback(this, function (response) {
        var state = response.getState();
        console.log("Retorno: " + state);
        if (component.isValid() && state === "SUCCESS") {
          var mapRetorno = response.getReturnValue();
          console.log(mapRetorno);
          component.set("v.mapRecordTypes", mapRetorno);
        } else {
          alert("Erro: " + records);
        }
      });
      $A.enqueueAction(action);
    },
  
    createDocumentationAux: function (component, callback) {
        
        var rectype = component.get("v.recordTypeIdChecked");
        var step = component.get("v.recordId");
        var action = component.get("c.createDocumentationAuxiliar");
        
        action.setParams({
            recordtypeId: rectype,
            stepId: step
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("Retorno: " + state);
            if (component.isValid() && state === "SUCCESS") {
                var auxDocumentationId = response.getReturnValue();
                console.log('id doc criado:' + auxDocumentationId);
                component.set("v.documentationId", auxDocumentationId);
                component.set('v.showSpinner', false);
            } else {
                alert("Erro: " + records);
            }
        });
        $A.enqueueAction(action);
    },
  
    updateDocumentationAux: function (component, callback) {
  
      console.log("Chamando serviço update Documentatioan");
      var documentId = component.get("v.documentationId");
      var step = component.get("v.recordId");
      var coment = component.find("Commentfield").get("v.value");
      console.log("Id do step: " + step);
      console.log("documentId: " + documentId);
      console.log("coment: " + coment);
  
      var action = component.get("c.updateDoc");
  
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
          console.log('id doc criado:' + auxDocumentationId);
          component.set("v.documentationId", auxDocumentationId);
          component.set('v.showSpinner', false);
  
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
  
  });