/**
 * @File Name          : T_MODEC_BMItem_REP.cls
 * @Description        : Classe REP do objeto BM_Item__c
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 20/04/2020 20:15:29
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    20/04/2020   Rafael Hadama     Initial Version
 **/
public class T_MODEC_BMItem_REP {
   public list<BM_Item__c> getRequestBMStatus(string requestId)
   {
      list<BM_Item__c> listBmItens = [SELECT Id, Request__c, TW1_Gross_Value__c, TW1_Service_Line__c, TW1_Total__c, T_Quantity__c FROM BM_Item__c where Request__c =:requestid];

      return listBmItens;
   }
}