/**
* @description       :
* @author            : Rafael Hadama
* @group             :
* @last modified on  : 10-08-2020
* @last modified by  : Saulo Silva
* Modifications Log
* Ver   Date         Author          Modification
* 1.0   09-21-2020   Rafael Hadama   Initial Version
**/
public class T_MODEC_ContentDocumentApp {
    /**
* @description Method that validates if the file is related to a documentation related to an inspection request.
* @author Rafael Hadama | 09-21-2020
**/
    public static void ValidateDeletedDocument(Map<Id, ContentDocument> mapaContentDocuments) {
        //Validar se o usuario é guest. senão return
        
        //Buscar pelo ContentDocument id, com quais objetos ele está relacionado.
        //Caso esteja relacionado a uma documentation, validar se está relacionado a uma request do tipo inspection
        //caso sim - impedir com aviso de sem permissão.
        
        User oUser = T_UserRep.getLoggedUser();       
        
        Set<String> ContentDocumentsIds = T_Utils.getSetIds(mapaContentDocuments.values(), 'Id');
        Id rt = Schema.SObjectType.TW1_Documentation__c.getRecordTypeInfosByDeveloperName().get('TW1_Inspection_Documentation').getRecordTypeId();
        List<ContentDocumentLink> cdl = [SELECT Id, LinkedEntityId, ShareType, ContentDocumentId FROM ContentDocumentLink where ContentDocumentId in: ContentDocumentsIds];
        
        if(oUser.Profile.UserLicense.Name == 'External Apps') {
            IF(cdl.size() > 0) {
                Set<String> vIdsLinkedEntityId = T_Utils.getSetIds(cdl, 'LinkedEntityId');
                Set<String> documentationIds = new Set<String>();
                
                for(String recordId: vIdsLinkedEntityId){
                    Id sId = recordId;
                    String sobjectType = sId.getSObjectType().getDescribe().getName();
                    
                    IF(sobjectType == 'TW1_Documentation__c'){
                        documentationIds.add(recordId);
                    }
                }
                
                IF(documentationIds.size() > 0){
                    List<TW1_Documentation__c> oDocumentacao = new List<TW1_Documentation__c>();
                    oDocumentacao = [SELECT ID, RecordTypeId, TW1_Request__r.TW1_Inspection_Status__c FROM TW1_Documentation__c WHERE RecordTypeId =: rt and ID IN: documentationIds];
                    
                    if (oDocumentacao.size() > 0) {
                        for(ContentDocumentLink recordLink: cdl){
                            IF(documentationIds.contains(recordLink.LinkedEntityId) && mapaContentDocuments.containsKey(recordLink.ContentDocumentId)){
                                SObject obj = mapaContentDocuments.get(recordLink.ContentDocumentId);
                                obj.addError('Não é possível deletar o arquivo da inspeção. Por favor, entre em contato com a Modec.');
                            }
                        }
                    }
                }
            }
        }
    }
}