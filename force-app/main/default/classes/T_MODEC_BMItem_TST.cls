/**
 * @File Name          : T_MODEC_BMItem_TST.cls
 * @Description        :
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 30/03/2020 17:39:23
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    30/03/2020   Rafael Hadama     Initial Version
 **/
@isTest
public class T_MODEC_BMItem_TST {
   @isTest
   public static void deleteServiceLineTst()
   {
      T_MODEC_Request_App_TST.criarCustomSettings();

      TW1_Request__c requestTest1 = T_MODEC_Request_App_TST.criarRegistroMock();     //Trigger 1
      requestTest1.TW1_BM_Reference_Number_in_SAP_MODEC__c = '1234567898';
      update requestTest1;
      //SELECT Id, TW1_Service_Line__c, T_Quantity__c, TW1_Gross_Value__c, TW1_Total__c FROM BM_Item__c
      BM_Item__c BMItemMock = new BM_Item__c();
      BMItemMock.Request__c          = requestTest1.Id;
      BMItemMock.TW1_Service_Line__c = '10';
      BMItemMock.T_Quantity__c       = 1;
      BMItemMock.TW1_Gross_Value__c  = 1;
      insert BMItemMock;

      try{
         delete BMItemMock;
      }
      catch (Exception e)
      {
         string mensagem        = e.getMessage();
         String currentuserId   = UserInfo.getUserId();
         User   currentUserInfo = [select LanguageLocaleKey from User where Id = :UserInfo.getUserId()];
         if (currentUserInfo.LanguageLocaleKey == 'pt_BR')
         {
            system.assert (mensagem.contains('Não é possivel deletar um linha de item relacionado a um BM já criado no MODEC-SAP'));
         }
         else
         {
            system.assert (mensagem.contains('You cannot delete a BM Service Line related to a BM already created in MODEC-SAP'));
         }
      }
   }
}