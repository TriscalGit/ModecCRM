/**
 * @File Name          : T_MODEC_CallbackEnvioAnexos_SAP.cls
 * @Description        :
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 18/02/2020 11:12:30
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    25/11/2019   Rafael Hadama     Initial Version
 **/


@RestResource(urlMapping = '/CallbackEnvioAnexosSAP/*')
global class T_MODEC_CallbackEnvioAnexos_SAP {
   /**
    * @description classe que recebe o método POST, e atualiza o ContentVersion/Document para que não ocorra o reenvio.
    * @author Rafael Hadama | 28/11/2019
    * @param AnexoCallback
    * @return void
    **/
   @HttpPost
   global static void PostProcessaCallBack(integer ENTRYSHEET, string EXTERNAL_ID, retorno RESPONSE)
   {
      system.debug('Callback recebido ENTRYSHEET: ' + ENTRYSHEET);
      system.debug('Callback recebido EXTERNAL_ID: ' + EXTERNAL_ID);
      system.debug('Callback recebido RESPONSE: ' + RESPONSE);
      T_SDK_LogIntegracaoApp logIntegracaoApp;
      // Variável para log de integração
      if (logIntegracaoApp == null)
      {
         T_SDK_DebugLog.EscreverLog('Iniciando Log de integração');
         logIntegracaoApp = new T_SDK_LogIntegracaoApp('CallbackAnexo_Log');
         logIntegracaoApp.Log.T_Request__c  = 'BM Number: ' + ENTRYSHEET + ' Anexo Id :' + EXTERNAL_ID + ' Response: ' + RESPONSE;
         logIntegracaoApp.Log.T_Response__c = 'Ver em anexo';
      }

      /*AnexoCallback request = (AnexoCallback)JSON.deserialize(req.getBody(), AnexoCallback.class);
       * system.debug('Request apos deserialize: '+request);*/
      try{
         T_MODEC_Content_REP contentRep = new T_MODEC_Content_REP();
         system.debug('Realizando query no anexo ');
         ContentVersion anexo = contentRep.getContentVersionbyId(EXTERNAL_ID);
         logIntegracaoApp.Log.T_Request__c = logIntegracaoApp.Log.T_Request__c + ' Title: '+ anexo.Title;
         //TW1_Last_SAP_request__c, TW1_Last_SAP_response__c, TW1_Upload_Sucess_SAP__c,
         //Escrevendo no campo response, o datetime , para controle do fluxo de anexos.
         //Independente do sucesso ou falha, devemos atualizar o campo abaixo.
         anexo.TW1_Last_SAP_response__c = datetime.now();
         if (RESPONSE.TYPE == 'S')
         {
            T_SDK_DebugLog.EscreverLog('Anexo inserido com sucesso no SAP/Documentum');
            anexo.TW1_Upload_Sucess_SAP__c = datetime.now();
         }

         update anexo;

         if (logIntegracaoApp.Log.T_Status__c != 'PROCESSADO_ERRO')
         {
            // Fechar o log de interação com sucesso
            logIntegracaoApp.FinalizarLogIntegracao('PROCESSADO_SUCESSO');
         }
      }
      catch (Exception ex) {
         System.debug('Erro ao receber callback: ' + ex.getMessage());
         logIntegracaoApp.AnexarProcessoLog('ErroProcesso', T_SDK_DebugLog.MontarTextoException(ex));
         logIntegracaoApp.FinalizarLogIntegracao('PROCESSADO_ERRO');
      }
      finally{ logIntegracaoApp.ExecutarDML(); }



      /*ResponsePostCallback response = new ResponsePostCallback();
       * response.ENTRYSHEET  = AnexoCallback.ENTRYSHEET;
       * response.EXTERNAL_ID = AnexoCallback.EXTERNAL_ID;
       * response.TYPE        = 'S';
       * response.MESSAGE     = 'Sucesso';*/
      //Receber e processar que o arquivo está na base do SAP/DOCUMENTUM, para não enviar novamente.
      //return new T_BER_OpportunityApp().ProcessarCallBack(oportunidadeCallBackRequest);
      //return response;
   }

   /*global class ResponsePostCallback {
    * global String ENTRYSHEET  { get; set; }
    * global String EXTERNAL_ID   { get; set; }
    * global String TYPE   { get; set; }
    * global String MESSAGE   { get; set; }
    * }
    *
    * global class requestSAP{}
    *
    * global class callback {
    * global AnexoCallback AnexoCallback;
    * }
    * global class AnexoCallback
    * {
    * global String ENTRYSHEET  { get; set; }
    * global String EXTERNAL_ID  { get; set; }
    * global retorno RESPONSE { get; set; }
    * }*/
   global class retorno {
      global string TYPE;
      global string MESSAGE;
   }
}