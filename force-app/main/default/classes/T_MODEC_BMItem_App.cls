/**
 * @File Name          : T_MODEC_BMItem_App.cls
 * @Description        : Application for the handler of the BM_Item__c object
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 30/03/2020 17:04:12
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    30/03/2020   Rafael Hadama     Initial Version
 **/
public class T_MODEC_BMItem_App {
   public static void AvoidDeleteOfBMItem(BM_Item__c deletedBMItem)
   {
      T_SDK_DebugLog.EscreverLog('Entrou no metodo "AvoidDeleteOfBMItem"');

      //realizar query no request(BM) relacionado, para validar se possui numero de folha criada.
      //SELECT Id, Name, Request__c FROM BM_Item__c
      TW1_Request__c RelatedBM = [SELECT Id, TW1_BM_Reference_Number_in_SAP_MODEC__c FROM TW1_Request__c where Id =:deletedBMItem.Request__c];

      if (RelatedBM.TW1_BM_Reference_Number_in_SAP_MODEC__c != null)
      {
         String currentuserId   = UserInfo.getUserId();
         User   currentUserInfo = [select LanguageLocaleKey from User where Id = :UserInfo.getUserId()];
         if (currentUserInfo.LanguageLocaleKey == 'pt_BR')
         {
            deletedBMItem.addError('Não é possivel deletar um linha de item relacionado a um BM já criado no MODEC-SAP');
         }
         else
         {
            deletedBMItem.addError('You cannot delete a BM Service Line related to a BM already created in MODEC-SAP');
         }
      }
      //Caso sim soltar erro.
   }
}