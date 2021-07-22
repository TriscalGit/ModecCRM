/**
 * @File Name          : T_MODEC_SAP_EnvioAnexo.cls
 * @Description        :
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 26/02/2020 17:19:20
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    19/11/2019   Rafael Hadama     Initial Version
 **/

public class T_MODEC_SAP_EnvioAnexo {
   private T_SAP_Service_Setting__mdt POST_ENVIARANEXO;

   public T_MODEC_SAP_EnvioAnexo()
   {
      POST_ENVIARANEXO = [SELECT Id,Authorization_Token__c,Endpoint__c FROM T_SAP_Service_Setting__mdt WHERE DeveloperName = 'POST_ENVIARANEXO'];

      if (Test.isRunningTest())
      {
         //POST_ENVIARANEXO = T_MODEC_SAP_UtilService.GetMockEndPoint('POST_ENVIARANEXO');
         POST_ENVIARANEXO.Endpoint__c = 'SAPQAMeasurementCreateFile';
         POST_ENVIARANEXO.Authorization_Token__c = 'TokenTst';
      }
   }

   public HTTPResponse PostEnviarAnexo(anexoDto requestDto)
   {
      T_SDK_DebugLog.EscreverLog('Iniciando Post de envio de anexo ao SAP');
      T_SDK_DebugLog.EscreverLog('Montando request');
      HttpRequest req = MontarRequestPostEnvioAnexo(requestDto);

      Http http = new Http();

      HTTPResponse res;

      try
      {
         //Execute web service call here
         T_SDK_DebugLog.EscreverLog('Enviando request para o serviço de envio de anexo ao SAP');

         T_SDK_DebugLog.EscreverLog('Enviando request :' + req);
         system.debug('Heap size usado apos montar request, antes do http.send(req): ' + Limits.getHeapSize());

         res = http.send(req);

         T_SDK_DebugLog.EscreverLog('HTTP response:' + res);
         T_SDK_DebugLog.EscreverLog('Body response Auth: ' + res.getBody());
         //Helpful debug messages
         //MT_AnexoCreate_Reponse response = (MT_AnexoCreate_Reponse)JSON.deserializeStrict(res.getBody(), MT_AnexoCreate_Reponse.class);
         //MT_AnexoCreate_Reponse response = (MT_AnexoCreate_Reponse)JSON.deserialize(res.getBody(), MT_AnexoCreate_Reponse.class);
         //string respMock = '{"RESPONSE":{"STATUS":"Sucesso","MESSAGE":"Msg de sucesso"}}';
         //RESPONSE response = (RESPONSE)JSON.deserializeStrict(respMock, RESPONSE.class);
         //T_SDK_DebugLog.EscreverLog('Response após o parse' + response);


         //Return fake
         //Retornando HTTPRESPONSE
         T_SDK_DebugLog.EscreverLog('Sucesso, statusCode 200. ' + res.getStatusCode());
         return res;
      }
      catch (Exception e)
      {
         T_MODEC_SAP_UtilService.ExceptionSAP sapEx = T_MODEC_SAP_UtilService.MontaExceptionSAP('Erro no envio de anexo');
         // Exception handling goes here....
         T_SDK_DebugLog.EscreverLog('Erro em executar chamada ao serviço de enviar anexo: message: ' + e.getMessage());
         T_SDK_DebugLog.EscreverLog('Erro no serviço de anexo - stacktrace: ' + e.getStackTraceString());
         throw new T_SDK_Exception('Erro ao enviar Anexo ao SAP [Code:' + sapEx.Code + ' message: ' + sapEx.message + ']');
      }
   }

   public HttpRequest MontarRequestPostEnvioAnexo(anexoDto requestDto)
   {
      T_SDK_DebugLog.EscreverLog('Montando request de enviar boletim ao SAP.');
      HttpRequest req = new HttpRequest();

      req.setHeader('Content-Type', 'application/json');
      //req.setHeader('Content-Type', 'image/jpeg');
      //req.setHeader('apikey', T_BER_WBC_UtilService.GetApiKey());
      //Set HTTPRequest Method
      req.setMethod('POST');

      //req.setEndpoint(enpointmock);
      //AMBIENTE DEV
      //req.setEndpoint('http://189.125.172.181:8280/services/SAPMeasurementCreateFile');
      
      //AMBIENTE QA
      //req.setEndpoint('http://189.125.172.181:8280/services/SAPQAMeasurementCreateFile');
      //req.setHeader('Authorization', tokenAuth);

      //system.debug('tamanho do JSON :'+JSON.serialize(requestDto));

      req.setEndpoint(POST_ENVIARANEXO.Endpoint__c);
      req.setHeader('Authorization', 'Basic '+POST_ENVIARANEXO.Authorization_Token__c);

      req.setBody(JSON.serialize(requestDto));

      req.setTimeout(120000);
      T_SDK_DebugLog.EscreverLog('HttRequest montado> ' + req);
      T_SDK_DebugLog.EscreverLog('Heap size usado req :' + Limits.getHeapSize());
      T_SDK_DebugLog.EscreverLog('Limite de heap size :' + Limits.getLimitHeapSize());
      return req;
   }

   public class anexoRequest {
      public anexoDto REQUEST;
   }


   public class anexoDto {
      public string ENTRYSHEET;
      public string EXTERNAL_ID;
      public string ARC_TITLE;
      public string ARC_TYPE;
      public string BASE64;
   }

   /*public class RESPONSE {
    * public resp RESPONSE;
    * }
    *
    * public class resp {
    * public String STATUS;
    * public String MESSAGE;
    * }
    *
    * public class MT_AnexoCreate_Reponse {
    * public responseAnexoSAP MT_AnexoCreate_Reponse;
    * }
    * public class responseAnexoSAP {
    * public retorno T_RETURN;
    * public string ENTRYSHEET;
    * public string EXTERNAL_ID;
    * }
    *
    * public class retorno {
    * public string TYPE;
    * public string MESSAGE;
    * }*/
}