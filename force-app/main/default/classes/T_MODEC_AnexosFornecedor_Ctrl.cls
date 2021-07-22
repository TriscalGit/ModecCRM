/**
 * @File Name          : T_MODEC_AnexosFornecedor_Ctrl.cls
 * @Description        :
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 28/01/2020 19:56:05
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    13/12/2019   Rafael Hadama     Initial Version
 **/
public class T_MODEC_AnexosFornecedor_Ctrl {
   /**
    * @description Metodo para validar status.
    * @author Rafael Hadama | 15/12/2019
    * @param recordId Id do objeto TW1_Request__c (BM)
    * @return string
    **/
   @AuraEnabled
   public static string searchBMStatus(string recordId)
   {
      T_MODEC_Request_Rep requestREP = new T_MODEC_Request_Rep();
      TW1_Request__c      req        = requestREP.getRequestBMStatus(recordId);

      string status = req.BM_Status__c;

      return status;
   }

   /**
    * @description Metodo para validar status.
    * @author Rafael Hadama | 15/12/2019
    * @param recordId Id do objeto TW1_Request__c (BM)
    * @return string
    **/
   @AuraEnabled
   public static string searchNFStatus(string recordId)
   {
      T_SDK_DebugLog.EscreverLog('Entrou no método searchNFStatus');
      T_MODEC_Request_Rep requestREP = new T_MODEC_Request_Rep();
      TW1_Request__c      req        = requestREP.getRequestNFStatus(recordId);
      T_SDK_DebugLog.EscreverLog('Request BM> ' + req);
      T_MODEC_AnexosFornecedor_App anexoFornecedorApp = new T_MODEC_AnexosFornecedor_App();
      NFDTO notafiscalDTO = anexoFornecedorApp.ValidateNFUpload(req);
      T_SDK_DebugLog.EscreverLog('notafiscalDTO>' + notafiscalDTO);

      string response = JSON.serialize(notafiscalDTO);
      T_SDK_DebugLog.EscreverLog('response>' + response);

      return response;
   }

   /**
    * @description Método feito para retornar id do usuário corrente, preenchendo o mesmo no componente de FileUpload
    * @author Rafael Hadama | 16/01/2020
    * @return string
    **/
   @AuraEnabled
   public static string getCurrentUserId()
   {
      return UserInfo.getUserId();
   }

   /**
    * @description
    * @author Rafael Hadama | 15/12/2019
    * @param ListrecordId (Lista de <registro do Anexo( *ContentVersion ).id> criado para anexar no documentation)
    * @return string
    **/
   @AuraEnabled
   public static string relateToDocumentation(list<string> ListrecordId, boolean isNTAttachment, string recId, string NF)
   {
      T_MODEC_AnexosFornecedor_App anexoFornecedorApp = new T_MODEC_AnexosFornecedor_App();

      T_SDK_DebugLog.EscreverLog('booleano isNF:' + isNTAttachment);

      string retorno = anexoFornecedorApp.createDocumentationAndLink(ListrecordId, isNTAttachment, recId, NF);
      return retorno;
   }

   public class NFDTO {
      public string message;
      public boolean blockNF;
   }
}