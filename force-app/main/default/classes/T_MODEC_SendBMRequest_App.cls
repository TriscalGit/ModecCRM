/**
 * @File Name          : T_MODEC_SendBMRequest_App.cls
 * @Description        : Classe application para
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 20/04/2020 20:23:43
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    09/12/2019   Rafael Hadama     Initial Version
 **/
public class T_MODEC_SendBMRequest_App {
   public T_MODEC_SendBMRequest_App()
   {
   }

   /**
    * @description método responsável por validar o Request(BM).
    * BM number already filled, PO_NUm empty or no Bm itens related.
    * @author Rafael Hadama | 09/12/2019
    * @param requestBmId
    * @return void
    **/
   public T_MODEC_SendBMRequest_Ctrl.BMvalidation validateBMRequest(string requestBmId)
   {
      T_MODEC_Request_Rep requestREP = new T_MODEC_Request_Rep();
      TW1_Request__c      BM         = requestREP.getRequestById(requestBmId);
      T_MODEC_BMItem_REP  BM_ItemREP = new T_MODEC_BMItem_REP();

      T_SDK_DebugLog.EscreverLog('Querying Bm Itens of the Request');
      list<BM_Item__c> listBMItens = BM_ItemREP.getRequestBMStatus(requestBmId);
      T_SDK_DebugLog.EscreverLog('listBMItens: ' + listBMItens.size());


      T_MODEC_SendBMRequest_Ctrl.BMvalidation BMValidateDto = new T_MODEC_SendBMRequest_Ctrl.BMvalidation();
      BMValidateDto.valid = true;

      list<string> listErros = new list<string>();
      T_SDK_DebugLog.EscreverLog('Antes de validar BM RefNumber');
      if ((BM.TW1_BM_Reference_Number_in_SAP_MODEC__c != null) && (BM.TW1_BM_Reference_Number_in_SAP_MODEC__c != ''))
      {
         BMValidateDto.valid = false;
         string erro = 'Request already have a BM Reference Number created.';
         listErros.add(erro);
      }
      T_SDK_DebugLog.EscreverLog('Antes de validar TW1_PO__c');
      if ((BM.TW1_PO__c == null) || (BM.TW1_PO__c == ''))
      {
         BMValidateDto.valid = false;
         string erro = 'PO is empty.';
         listErros.add(erro);
      }
      T_SDK_DebugLog.EscreverLog('Antes de validar BM_Itens__r');
      if (listBMItens.size() == 0)
      {
         BMValidateDto.valid = false;
         string erro = 'Request does not have related BM Service Lines.';
         listErros.add(erro);
      }
      T_SDK_DebugLog.EscreverLog('Após validar todos erros> :' + listErros);

      BMValidateDto.validationsMessage = listErros;

      return BMValidateDto;
   }
}