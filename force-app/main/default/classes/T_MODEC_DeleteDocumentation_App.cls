/**
 * @File Name          : T_MODEC_DeleteDocumentation_App.cls
 * @Description        : Classe Application onde está a regra para Apagar Documentation
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 24/04/2020 18:26:00
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    17/12/2019   Rafael Hadama     Initial Version
 **/
public class T_MODEC_DeleteDocumentation_App {
   public static void deleteDocs()
   {
      try{
         Datetime NowMinus20minutes = datetime.now().addMinutes(-20);
         system.debug('NowMinus20minutes >' + NowMinus20minutes);
         list<TW1_Documentation__c> listDocDelete = [SELECT Id, CreatedDate, TW1_DocumentationAux__c FROM TW1_Documentation__c where TW1_DocumentationAux__c = true AND CreatedDate <: NowMinus20minutes limit 9980];

         Database.DeleteResult[] deleteResultList = Database.delete(listDocDelete, false);
      }
      catch (Exception e)
      {
         // Exception handling goes here....
         T_SDK_DebugLog.EscreverLog('Erro deletar Documentations mocks' + e.getMessage());
         T_SDK_DebugLog.EscreverLog('Erro ao deletar Documentation- stacktrace: ' + e.getStackTraceString());
      }
      finally{
         //Reschedular job.
         T_SDK_ScheaduleUtils.scheadule('T_MODEC_SCH_DeleteDocumentations', 10);
      }
   }
}