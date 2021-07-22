/**
* @description       :
* @author            : Hugo Brito
* @group             :
* @last modified on  : 04-23-2021
* @last modified by  : Hugo Brito
* Modifications Log
* Ver   Date         Author       Modification
* 1.0   04-23-2021   Hugo Brito   Criação da classe
**/
public class T_ContentDocumentLinkValidationApp {
    
    public static void ValidateInsertDocument(List<ContentDocumentLink> cdls) {
        
        User oUser = T_UserRep.getLoggedUser();       
        Set<String> documentationsIds = new Set<String>();
        
        for(ContentDocumentLink recordLink: cdls){
            String sObjectType = recordLink.LinkedEntityId.getSObjectType().getDescribe().getName();
            if(oUser.Profile.UserLicense.Name == 'External Apps') {
                if(sObjectType == 'TOBJ_Warning__c'){
                    recordLink.addError('Não é possível adicionar o arquivo. Por favor, entre em contato com a Modec.');
                }
            }
            if(sObjectType == 'TW1_Documentation__c'){ 
                documentationsIds.add(recordLink.LinkedEntityId);
            }
        }
        
        Map<id, TW1_Documentation__c> docsMap = T_DocumentationREP.getInspectionDocumentationMap(documentationsIds);
        
        for(ContentDocumentLink cdl: cdls){
            if(docsMap.containsKey(cdl.LinkedEntityId)){
        		cdl.addError('Não é possível adicionar o arquivo. Por favor, entre em contato com o administrador.');
            }
        }
    }
    
    public static void ValidateDeleteDocument(List<ContentDocumentLink> cdls) {     
        Set<String> documentationsIds = new Set<String>();
        Map<String, List<SObject>> mapaCDLS = T_Utils.montaMapaListaSObjectComCampoComoChave('LinkedEntityId', cdls);
        
        for(ContentDocumentLink recordLink: cdls){
            String sObjectType = recordLink.LinkedEntityId.getSObjectType().getDescribe().getName();
            if(sObjectType == 'TW1_Documentation__c'){ 
                documentationsIds.add(recordLink.LinkedEntityId);
            }
        }
        
        List<TW1_Documentation__c> docs = T_DocumentationREP.getInspectionDocumentation(documentationsIds);
        
        for(TW1_Documentation__c doc: docs) {
            for(SObject cdl: mapaCDLS.get(doc.id)){
                cdl.addError('Não é possível deletar o arquivo. Por favor, entre em contato com o administrador.');
            }
        }
    }
}