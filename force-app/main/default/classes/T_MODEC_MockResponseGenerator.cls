/**
 * @File Name          : T_MODEC_MockResponseGenerator.cls
 * @Description        : Classe responsável por guardar os responses mock para classes de teste, com implements HttpCalloutMock
 * @Author             : Rafael Hadama
 * @Group              : 
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 03/02/2020 15:21:53
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    19/11/2019   Rafael Hadama     Initial Version
**/
global class T_MODEC_MockResponseGenerator implements HttpCalloutMock{
    
     // Implementando métdo do HttpCalloutMock
   global HTTPResponse respond(HTTPRequest req)
   {
      // Create a fake response
      if (req.getEndpoint().endsWith('POST_ENVIARBOLETIM'))
      {
         return MockPostEnvioBoletimSAP();
      }
      // Create a fake response
      if (req.getEndpoint().endsWith('SAPQAMeasurementCreateFile'))
      {
         return MockPostEnvioAnexoSAP();
      }
      /*
      if (req.getEndpoint().endsWith('GET_CONDICOESPAGAMENTO'))
      {
         return MockGetCondicoesPagamento();
      }*/

      /// Caso não tenha encontrado nenhum endpoint retorna erro
      throw new T_MODEC_AppException('Nenhum endpoint encontrado para realizar o mock');
   }

   public HTTPResponse MockPostEnvioBoletimSAP()
   {
      HTTPResponse res = new HTTPResponse();

      res.setHeader('Content-Type', 'application/json');
      res.setBody('{"MT_MeasurementCreate_Reponse":{"ENTRYSHEET":1000001319,"T_RETURN":{"item":{"STATUS":"S","MESSAGE":"Entrysheet1000001319created"}}}}');
      res.setStatusCode(200);
      return res;
   }

   public HTTPResponse MockPostEnvioAnexoSAP()
   {
      HTTPResponse res = new HTTPResponse();

      res.setHeader('Content-Type', 'application/json');
      res.setBody('{"RESPONSE":{"STATUS":"Sucesso","MESSAGE":"Msg de sucesso"}}');
      res.setStatusCode(200);
      return res;
   }
}