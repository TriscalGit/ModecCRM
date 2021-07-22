/**
 * @File Name          : T_MODEC_SAP_EnvioAnexo_App.cls
 * @Description        : Classe application relativa a integração do SAP / para criação do anexo ao Boletim de medição
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 14/01/2020 12:40:18
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    13/11/2019   Rafael Hadama     Initial Version
 **/
public class T_MODEC_SAP_EnvioAnexo_App {
   //Log de integração para salvar dados deste Callout
   public static T_SDK_LogIntegracaoApp logIntegracaoApp;   


   /*public static void montarRequestAnexo(ContentVersion anexo, string BMnumberSAP)
   {
      //Realizando query no content Version para obter o blob(base64)
      try
      {
         T_MODEC_SAP_EnvioAnexo.anexoRequest requestDto = new T_MODEC_SAP_EnvioAnexo.anexoRequest();

         T_MODEC_SAP_EnvioAnexo.anexoDto arquivoDTO = new T_MODEC_SAP_EnvioAnexo.anexoDto();

         arquivoDTO.ENTRYSHEET  = BMnumberSAP;
         arquivoDTO.ARC_TITLE   = anexo.Title;
         arquivoDTO.ARC_TYPE    = anexo.FileExtension;
         arquivoDTO.EXTERNAL_ID = anexo.ContentDocumentId;
         arquivoDTO.BASE64      = EncodingUtil.base64Encode(anexo.VersionData);
         //T_SDK_DebugLog.EscreverLog('Arquivo. version data :' + arquivo.VersionData);
         requestDto.REQUEST = arquivoDTO;

         system.debug('Heap size usado apos montar o DTO:' + Limits.getHeapSize());

         //T_MODEC_SAP_EnvioAnexo.MT_AnexoCreate_Reponse response = T_MODEC_SAP_EnvioAnexo.PostEnviarAnexo(requestDTO);
         T_MODEC_SAP_EnvioAnexo.MT_AnexoCreate_Reponse response = new T_MODEC_SAP_EnvioAnexo.MT_AnexoCreate_Reponse();
         T_SDK_DebugLog.EscreverLog('response :' + response);

         //logIntegracaoApp.AnexarProcessoLog('Request Anexo ' + arquivo.ContentDocumentId, JSON.serialize(response));
         logIntegracaoApp.Log.T_Response__c = 'Status :' + response.MT_AnexoCreate_Reponse.T_RETURN.TYPE + ' Message: ' + response.MT_AnexoCreate_Reponse.T_RETURN.MESSAGE;

         system.debug('Heap size usado apos response:' + Limits.getHeapSize());
         system.debug('Limite de heap size :' + Limits.getLimitHeapSize());
         T_SDK_DebugLog.EscreverLog('Heap size usado :' + Limits.getHeapSize());
         T_SDK_DebugLog.EscreverLog('Limite de heap size :' + Limits.getLimitHeapSize());
      }
      catch (Exception e)
      {
         logIntegracaoApp.AnexarProcessoLog('ErroEnvioAnexo' + anexo.ContentDocumentId, T_SDK_DebugLog.MontarTextoException(e));
         logIntegracaoApp.AtualizaStatusLogIntegracao('PROCESSADO_ERRO');
      }

      //Adicionar aqui possivel logica para dml do contentversion

      if (logIntegracaoApp.Log.T_Status__c != 'PROCESSADO_ERRO')
      {
         // Fechar o log de interação com sucesso
         logIntegracaoApp.FinalizarLogIntegracao('PROCESSADO_SUCESSO');
      }

      logIntegracaoApp.Log.T_Data_fim__c = Datetime.now();
      logIntegracaoApp.ExecutarDML();
   }*/

   /**
    * @description Classe que realiza query e cria variaveis utilizados no Batch Apex de Envio de anexos.
    * @author Rafael Hadama | 29/11/2019
    * @return void
    **/
   public static void executarBatchEnvioAnexos()
   {
      T_MODEC_Request_Rep requestREP = new T_MODEC_Request_Rep();
      T_MODEC_Content_REP contentREP = new T_MODEC_Content_REP();
      //SOQL para buscar bms aprovados, validar pelo campo BM-STATUS
      List<TW1_Request__c> listBMs = requestREP.getBMsEnvioAnexos();

      //Retornar caso não exista bms na condição de envio.
      if (listBMs.size() < 1)
      {
         return;
      }
      T_SDK_DebugLog.EscreverLog('listBMs :' + listBMs);
      for (TW1_Request__c req:listBMs)
      {
         T_SDK_DebugLog.EscreverLog('BM :' + req.Id);
      }
      Map<Id, TW1_Request__c> mapBms = new Map<Id, TW1_Request__c>(listBMs);

      //SOQL para buscar link de anexos.
      set<id> newSet = mapBms.keyset();
      List<ContentDocumentLink> listLinkAnexos = contentREP.getLinksAnexos(newSet);
      for (ContentDocumentLink contLink:listLinkAnexos)
      {
         T_SDK_DebugLog.EscreverLog('ContentDocumentId :' + contLink.ContentDocumentId);
      }
      //Criando map para consulta do numero bm no content version. e lista de ids para query
      //set<id> setBMId = mapDocId_BMnumber.
      Map<String, String> mapDocId_BMnumber = new map<String, String>();

      for (ContentDocumentLink linkAnexo :listLinkAnexos)
      {
         //Adicionando item no map
         T_SDK_DebugLog.EscreverLog('linkAnexo.ContentDocumentId :' + linkAnexo.ContentDocumentId);
         T_SDK_DebugLog.EscreverLog('TW1_BM_Reference_Number_in_SAP_MODEC__c :' + mapBms.get(linkAnexo.LinkedEntityId).TW1_BM_Reference_Number_in_SAP_MODEC__c);
         mapDocId_BMnumber.put(linkAnexo.ContentDocumentId, mapBms.get(linkAnexo.LinkedEntityId).TW1_BM_Reference_Number_in_SAP_MODEC__c);
      }

      Id batchEnvioAnexosId = Database.executeBatch(new T_MODEC_BAT_EnvioAnexosSAP(mapDocId_BMnumber),1);
      system.debug('Batch process id:' + batchEnvioAnexosId);
   }

   /**
   * @description Classe que realiza query e cria variaveis utilizados no Batch Apex de Envio de anexos.
   * @author Rafael Hadama | 29/11/2019 
   * @return void 
   **/
   /*public static void executarBatchEnvioAnexos(){

      T_MODEC_Request_Rep requestREP = new T_MODEC_Request_Rep();
      T_MODEC_Content_REP contentREP = new T_MODEC_Content_REP();
      //SOQL para buscar bms aprovados, validar pelo campo BM-STATUS
      List<TW1_Request__c> listBMs = requestREP.getBMsEnvioAnexos();
      Map<Id,TW1_Request__c> mapBms = new Map<Id,TW1_Request__c>(listBMs);

      //SOQL para buscar link de anexos.
      List<ContentDocumentLink> listLinkAnexos = contentREP.getLinksAnexos(mapBms.keyset());
      
      //Criando map para consulta do numero bm no content version. e lista de ids para query
      //set<id> setBMId = mapDocId_BMnumber.
      Map<String,String> mapDocId_BMnumber = new map<String,String>();

      for(ContentDocumentLink linkAnexo :listLinkAnexos){
         
         //Adicionando item no map
         mapDocId_BMnumber.put(linkAnexo.ContentDocumentId,mapBms.get(linkAnexo.LinkedEntityId).TW1_BM_Reference_Number_in_SAP_MODEC__c);         
      }


   }*/
}