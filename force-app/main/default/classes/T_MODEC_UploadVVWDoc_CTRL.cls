/**
 * @File Name          : T_MODEC_UploadVVWDoc_CTRL.cls
 * @Description        : Classe controller do LightningComponent T_MODEC_UploadComplianceVVDoc
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 10/02/2020 13:10:57
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    14/01/2020   Rafael Hadama     Initial Version
 **/
public without sharing class T_MODEC_UploadVVWDoc_CTRL {

   @AuraEnabled
   public static string createDocumentationVVWAuxiliar()
   {
      system.debug('Criando Documentation AUX do tipo VVW');
      T_MODEC_CreateDocumentation_App createDoc_App = new T_MODEC_CreateDocumentation_App();
      RecordType rec = [SELECT Id, Name,DeveloperName, SobjectType FROM RecordType WHERE SobjectType ='TW1_Documentation__c' AND DeveloperName = 'TW1_VVW_Attachment'];

      string documentationId = createDoc_App.documentationInsertDMLAux(rec.Id);

      return documentationId;
   }

   @AuraEnabled
   public static string updateDocumentationVVWAuxiliar(string documentId, string relatedObjectId, string comentarios)
   {
      
      T_SDK_DebugLog.EscreverLog('relatedObjectId > :' + relatedObjectId);
      T_SDK_DebugLog.EscreverLog('documentation criado > :' + documentId);

      T_MODEC_CreateDocumentation_App createDoc_App = new T_MODEC_CreateDocumentation_App();
      String nomeObjeto = 'TW1_Step__c';
      T_SDK_DebugLog.EscreverLog('nomeObjeto > :' + nomeObjeto);
      
      string documentationId = createDoc_App.documentationUpdateDMLAux(documentId, relatedObjectId, comentarios,nomeObjeto);

      updateStep(relatedObjectId);

      return documentationId;
   }

   /**
   * @description Método utilizado após a criação da documentation do tipo VVW DOC, atualizando campo booleano de controle.
   * @author Rafael Hadama | 15/01/2020 
   * @param stepId 
   * @return void 
   **/
   public static void updateStep(string stepId){
      TW1_Step__c step = [Select Id,TW1_VVW_Doc_Uploaded__c  from TW1_Step__c where Id =:stepId ];
      step.TW1_VVW_Doc_Uploaded__c = true;

      update step;
   }
}