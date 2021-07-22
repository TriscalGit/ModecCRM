/**
 * @File Name          : T_MODEC_SAP_EnvioBoletim.cls
 * @Description        : Classe que realiza o request para o SAP, para criação do boletim de medição
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 26/02/2020 17:19:21
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    04/11/2019   Rafael Hadama     Initial Version
 **/
public class T_MODEC_SAP_EnvioBoletim {
   private T_SAP_Service_Setting__mdt POST_ENVIARBOLETIM;
 
   public T_MODEC_SAP_EnvioBoletim()
   {
      POST_ENVIARBOLETIM = [SELECT Id,Authorization_Token__c,Endpoint__c FROM T_SAP_Service_Setting__mdt WHERE DeveloperName = 'POST_ENVIARBOLETIM'];

      if (Test.isRunningTest())
      {
         //POST_ENVIARBOLETIM = T_MODEC_SAP_UtilService.GetMockEndPoint('POST_ENVIARBOLETIM');
         POST_ENVIARBOLETIM.Endpoint__c = 'POST_ENVIARBOLETIM';
         POST_ENVIARBOLETIM.Authorization_Token__c = 'TokenTst';
      }
   }
   
   public HTTPResponse PostEnviarBoletim(boletimDto boletim)
   {
      T_SDK_DebugLog.EscreverLog('Iniciando Post de criação do boletim no SAP');
      T_SDK_DebugLog.EscreverLog('Montando request');
      HttpRequest req = MontarRequestPostEnvioBoletim(boletim);

      Http http = new Http();

      HTTPResponse res;

      try
      {
         //Execute web service call here
         T_SDK_DebugLog.EscreverLog('Enviando request para o serviço de criação de Boletins');
         if (Test.isRunningTest())
         {
            res = new T_MODEC_MockResponseGenerator().MockPostEnvioBoletimSAP();
         }
         else
         {
            res = http.send(req);
         }
         T_SDK_DebugLog.EscreverLog('Response recebido ' + res);
         T_SDK_DebugLog.EscreverLog('Body response Auth: ' + res.getBody());
         //Helpful debug messages
         //MT_MeasurementCreate_Reponse response = (MT_MeasurementCreate_Reponse)JSON.deserialize(res.getBody(), MT_MeasurementCreate_Reponse.class);

         //T_SDK_DebugLog.EscreverLog('Response após o parse' + response);

         //Return fake
         return res;

/*
 *       if (res.getStatusCode() == 200)
 *       {
 *          //Retornando responseBoletimSAP
 *          return response;
 *       }
 *       else
 *       {
 *          throw new T_SDK_Exception('ERRO PostEnviarBoletim: ' + res.getBody());
 *       }*/
      }
      catch (Exception e)
      {
         //T_MODEC_SAP_UtilService.ExceptionSAP sapEx = T_MODEC_SAP_UtilService.MontaExceptionSAP(res.getBody());
         // Exception handling goes here....
         T_SDK_DebugLog.EscreverLog('Erro em executar chamada ao serviço de enviar boletim. ');
         return null;
         //throw new T_SDK_Exception('Erro ao enviar boletim ao SAP [Code:' + sapEx.Code + ' message: ' + sapEx.message + ']');
      }
   }

   private HttpRequest MontarRequestPostEnvioBoletim(boletimDto boletim)
   {
      T_SDK_DebugLog.EscreverLog('Montando request de enviar boletim ao SAP.');
      HttpRequest req = new HttpRequest();

      req.setHeader('Content-Type', 'application/json');
      //req.setHeader('apikey', T_BER_WBC_UtilService.GetApiKey());
      //Set HTTPRequest Method
      req.setMethod('POST');
      //Deixando aqui o setEndpoint mockado ate receber os dados da MODEC
      //req.setEndpoint('POST_ENVIARBOLETIM');
      //Endpoint ambiente DEV
      //req.setEndpoint('http://189.125.172.181:8280/services/SAPMeasurementCreate');

      //Endpoint ambiente QA
      //req.setEndpoint('http://189.125.172.181:8280/services/SAPQAMeasurementCreate');

      //POST_ENVIARBOLETIM
      req.setEndpoint(POST_ENVIARBOLETIM.Endpoint__c);
      req.setHeader('Authorization', 'Basic '+POST_ENVIARBOLETIM.Authorization_Token__c);
      

      req.setBody(JSON.serialize(boletim));
      req.setTimeout(120000);
      return req;
   }

   public class boletimDto {
      public string PO_NUM;
      public string PI_NUM;
      public string BM;
      public string DT_BEGIN;
      public string DT_END;
      public string EMAIL_VENDOR;
      public string EMAIL_REQ;
      public string CNPJ;
      public string FINAL_BM;
      public string SERVICE_TXT;
      //Atributo para enviar linhas do item de serviço. (objeto relacionado)
      public linhasItem T_SERVICE;
   }

   public class linhasItem {
      public list<linha> item;
   }
   public class linha {
      public string SRV_NUM;
      public decimal SRV_VALUE;
      public decimal SRV_QUANT;
   }

   public class MT_MeasurementCreate_Reponse {
      public responseBoletimSAP MT_MeasurementCreate_Reponse;
   }
   public class responseBoletimSAP {
      public retorno T_RETURN;
      public string ENTRYSHEET;
   }

   public class retorno {
      public itemresponse item;
   }

   public class itemresponse {
      //STATUS = "S" sucesso ou STATUS = "E" erro
      public string STATUS;
      public string MESSAGE;
   }
}