/**
 * @File Name          : T_MODEC_SAP_UtilService.cls
 * @Description        : Classe que possui métodos relativos a integração com SAP e tratamento de exceções.
 * @Author             : Rafael Hadama
 * @Group              : 
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 05/02/2020 17:53:23
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    05/11/2019   Rafael Hadama     Initial Version
**/
public class T_MODEC_SAP_UtilService {

    public static ExceptionSAP MontaExceptionSAP(String bodyResponse)
   {
      try {
         //Helpful debug messages
         //SAPErroNaoTratadoResponse response = (SAPErroNaoTratadoResponse)JSON.deserializeStrict(bodyResponse, SAPErroNaoTratadoResponse.class);
         T_MODEC_SAP_EnvioBoletim.MT_MeasurementCreate_Reponse response = (T_MODEC_SAP_EnvioBoletim.MT_MeasurementCreate_Reponse)JSON.deserializeStrict(bodyResponse, T_MODEC_SAP_EnvioBoletim.MT_MeasurementCreate_Reponse.class);

         ExceptionSAP exResponse = new ExceptionSAP();
         exResponse.Code    = -1;
         exResponse.message = response.MT_MeasurementCreate_Reponse.T_RETURN.item.MESSAGE;
         return exResponse;
      }
      catch (Exception e) {
      }

      try {
         //Helpful debug messages
         SAPErroTratadoResponse response = (SAPErroTratadoResponse)JSON.deserializeStrict(bodyResponse, SAPErroTratadoResponse.class);

         ExceptionSAP exResponse = new ExceptionSAP();
         exResponse.Code    = response.Code;
         exResponse.message = response.message;
         return exResponse;
      }
      catch (Exception e) {
      }

      ExceptionSAP exResponse = new ExceptionSAP();
      exResponse.Code    = -200;
      exResponse.message = bodyResponse;
      return exResponse;
   }

   /*
    * Classe que representa um erro no WBC
    */
   public class ExceptionSAP
   {
      public Integer Code { get; set; }
      public String message { get; set; }
   }

   /*
    * Classe que representa o response para erros não tratados do WBC
    */
   public class SAPErroNaoTratadoResponse
   {
      public String Mensagem { get; set; }
      public String Detalhe { get; set; }
   }

   /*
    * Classe que representa o response para erros tratados do SAP
    */
   public class SAPErroTratadoResponse
   {
      public Integer timestamp { get; set; }
      public Integer Code { get; set; }
      public String message { get; set; }
   }


    /**
    * @description Método que monta Enpoint Mock para testes
    * @author Rafael Hadama | 05/11/2019 
    * @param nomeEndPoint 
    * @return T_SAP_Service_Setting__mdt 
    **/
    public static T_SAP_Service_Setting__mdt GetMockEndPoint(string nomeEndPoint)
   {
      T_SAP_Service_Setting__mdt servicoSetting = new  T_SAP_Service_Setting__mdt();
      //servicoSetting.T_Host__c = 'http://teste.mockservico';
      //servicoSetting.T_ApiUrl__c = nomeEndPoint;
      return servicoSetting;
   }
    
}