/**
 * @File Name          : T_MODEC_ExpirarContrato_TST.cls
 * @Description        :
 * @Author             : Mario Oliveira
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 30/01/2020 16:35:43
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    14/11/2019   Mario Oliveira     Initial Version
 **/
@isTest
public with sharing class T_MODEC_ExpirarContrato_TST {
   static void MakeMetadataAndCustomSettings()
   {
      system.debug('Teste system debug dentro do testSetupmetodo');
      T_Debug_Setting__mdt testSetting = new T_Debug_Setting__mdt();
      testSetting.Label                          = 'Teste';
      testSetting.DeveloperName                  = 'Teste';
      testSetting.T_Armazenar_Cause__c           = true;
      testSetting.T_Armazenar_linha_debug__c     = true;
      testSetting.T_Armazenar_StackTrace__c      = true;
      testSetting.T_Armazenar_texto_Exception__c = true;
      T_SDK_DebugLog_Test.testSetting            = testSetting;

      //Creating Custom Settings
      ID_Account__c customSettingIdAccount = new ID_Account__c();
      customSettingIdAccount.Id_IntegrationUser__c = UserInfo.getUserId();
      insert customSettingIdAccount;

      Controle_de_Triggers__c customControleTrigger = new Controle_de_Triggers__c();
      customControleTrigger.Trigger_Request__c = true;
      customControleTrigger.Trigger_Account__c = true;
      insert customControleTrigger;
   }

   @isTest static void ExpirarContrato_TST()
   {
      MakeMetadataAndCustomSettings();

      RecordType accRec_VendorHomologated = [Select id from Recordtype where developername = 'TW1_Vendor_Homologated'];
      Account    cont = new Account();

      cont.recordtypeId        = accRec_VendorHomologated.id;
      cont.name                = 'Conta ENVIO Boletim';
      cont.TW1_CPF__c          = '57034551030';
      cont.TW1_Contact_Name__c = 'Contato Mock';
      insert cont;

      TW1_MODEC_Contract__c contract = new TW1_MODEC_Contract__c();
      contract.TW1_Status__c   = 'Active';
      contract.TW1_Vendor__c   = cont.Id;
      contract.TW1_End_Date__c = Date.today().addDays(-1);
      insert contract;

      Test.startTest();
      T_SDK_ScheaduleUtils.scheadule('T_MODEC_SCH_ExpirarContrato', 1);   //Intervalo de 5 minutos
      Test.stopTest();

      TW1_MODEC_Contract__c contratoatualizado = [select id, TW1_Status__c from TW1_MODEC_Contract__c where id =:contract.id];
      System.AssertEquals('Expired', contratoatualizado.TW1_Status__c, 'Status Ativo');
   }
}