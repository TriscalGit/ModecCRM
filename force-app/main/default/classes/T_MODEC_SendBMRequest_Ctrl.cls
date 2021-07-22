/**
 * @File Name          : T_MODEC_SendBMRequest_Ctrl.cls
 * @Description        : Classe controller do LP. Validação de envio e retorno do callback SAP.
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 18/12/2019 12:33:51
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    09/12/2019   Rafael Hadama     Initial Version
 **/
public class T_MODEC_SendBMRequest_Ctrl {
   

   @AuraEnabled
   public static string sendRequest(string requestId)
   {
      //first Validate Request as valid
      T_SDK_DebugLog.EscreverLog('Entrou no metodo sendRequest');
      T_MODEC_SendBMRequest_App sendBM_App = new T_MODEC_SendBMRequest_App();
      BMvalidation             validateDTO = sendBM_App.validateBMRequest(requestId);
      T_MODEC_EnvioBoletim_App envio_App   = new T_MODEC_EnvioBoletim_App();

      T_SDK_DebugLog.EscreverLog('Validation DTO: ' + validateDTO);

      //Criando dto de retorno
      createBM_SAPresponse SAP_response = new createBM_SAPresponse();
      SAP_response.messages_SAP = new list<string>();

      if (!validateDTO.valid)
      {
         T_SDK_DebugLog.EscreverLog('Request negado!');
         SAP_response.status_SAP   = 'I';
         SAP_response.messages_SAP = validateDTO.validationsMessage;
         string erroValidacao = JSON.serialize(SAP_response);
         return erroValidacao;
      }
      else
      {
         //Envindo request ao SAP
         //SAP_response = envio_App 
         /*SAP_response.status_SAP   = 'Request com Sucesso.';
         SAP_response.messages_SAP.add('Folha de registro de serviços 1000025501 foi criada.');*/
         T_MODEC_EnvioBoletim_App EnvioApp = new T_MODEC_EnvioBoletim_App();
         SAP_response = EnvioApp.enviarBoletimMedicao(requestId);
         string retornoSAP = JSON.serialize(SAP_response);
         return retornoSAP;
      }
      //valid (yes), send request to sap.
      //get return message if error or not.
   }

   public class createBM_SAPresponse {
      //status_SAP, quando ocorre o request ao SAP, temos o retorno do atributo STATUS
      //Atributo STATUS pode ser 'E' ou 'S'
      //Podemos passar o valor 'I', para indicar que o mesmo está invalido para envio.
      public string status_SAP;
      //Lista de erros que mostre o que está invalido
      //ou lista com msg de retorno do SAP
      public list<string> messages_SAP;
   }

   public class BMvalidation {
      public boolean valid;
      public list<string> validationsMessage;
   }
}