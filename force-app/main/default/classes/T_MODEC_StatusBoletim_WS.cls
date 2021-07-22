/**
 * @File Name          : T_MODEC_StatusBoletim_WS.cls
 * @Description        : Classe que representa o serviço REST para o processo
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 21/11/2019 19:46:03
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    08/11/2019   Rafael Hadama     Initial Version
 **/


@RestResource(urlMapping = '/StatusBoletim/*')
global class T_MODEC_StatusBoletim_WS {
   @HttpPost
   global static Response receberStatusBoletins(StatusRequest REQUEST)
   {
      /*string        jsonmock = '{"REQUEST":[{"ENTRYSHEET": "1000003333","STATUS": "2","MESSAGE":""},{"ENTRYSHEET": "1000001327","STATUS": "1","MESSAGE":""}]}';
       * StatusRequest request  = (StatusRequest)JSON.deserializeStrict(jsonmock, StatusRequest.class);
       *
       * T_SDK_DebugLog.EscreverLog('Objeto montado request :>' + request);
       * string         jsonmock2 = '{"RESPONSE":[{"ENTRYSHEET": "1000003333","PROCESSADO": "X","MESSAGE":""},{"ENTRYSHEET": "1000001327","PROCESSADO": "X","MESSAGE":""}]}';
       * StatusResponse response  = (StatusResponse)JSON.deserializeStrict(jsonmock2, StatusResponse.class);
       *
       * T_SDK_DebugLog.EscreverLog('Objeto montado response :>' + response);
       *
       */
      T_SDK_DebugLog.EscreverLog('Objeto montado response :>');
      List<ItemResponse> listaResponse = T_MODEC_StatusBoletim_App.atualizarStatusBoletins(REQUEST);
      /*List<ItemResponse> listaResponse = new list<ItemResponse>();

      for (Itemrequest item :REQUEST)
      {
         ItemResponse ItemResp = new ItemResponse();
         ItemResp.ENTRYSHEET = item.ENTRYSHEET;
         ItemResp.PROCESSADO = 'x';
         listaResponse.add(ItemResp);
      }*/

      Response resp = new Response();
      StatusResponse statusResp = new StatusResponse();
      statusResp.item = listaResponse;
      resp.RESPONSE = statusResp;
      return resp;
   }

   global class Request{
      public StatusRequest REQUEST;
   }

   global class StatusRequest {
      public list<Itemrequest> item;
   }

   global class Itemrequest {
      public String ENTRYSHEET;
      public String STATUS;
      public String MESSAGE;
   }

   global class Response{
      public StatusResponse RESPONSE;
   }

   global class StatusResponse {
      list<ItemResponse> item;
   }

   global class ItemResponse {
      public String ENTRYSHEET;
      public String PROCESSADO;
   }
}