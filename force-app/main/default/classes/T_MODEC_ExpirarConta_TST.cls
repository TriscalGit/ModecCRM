/**
 * @File Name          : T_MODEC_ExpirarConta_TST.cls
 * @Description        :
 * @Author             : Mario Oliveira
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 30/01/2020 16:37:44
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    18/11/2019   Mario Oliveira     Initial Version
 **/
@isTest
public with sharing class T_MODEC_ExpirarConta_TST {
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

   @isTest public static void ExpirarConta_TST()
   {
      MakeMetadataAndCustomSettings();
      RecordType recAcc = [SELECT Id, DeveloperName, SObjectType FROM RecordType WHERE SObjectType = 'Account' And DeveloperName = 'TW1_Vendor_Homologated'];

      Account conta = new Account();
      conta.Name = 'Mario Teste';
      conta.TW1_Shelf_Life_Vetting_Date__c = Date.today().addDays(-2);
      conta.RecordTypeId        = recAcc.id;
      conta.TW1_Contact_Name__c = 'Contato Mock';
      insert conta;

      Test.startTest();
      T_SDK_ScheaduleUtils.scheadule('T_MODEC_SCH_ExpirarConta', 1);
      Test.stopTest();

      Account accTest = [SELECT Id, RecordTypeId, TW1_Vendor_Vetting__c FROM Account where id =: conta.id];

      System.assertEquals('Vetting Expired', accTest.TW1_Vendor_Vetting__c, 'Campo "TW1_Vendor_Vetting__c" diferente de "No Registered"');
      System.assertEquals(true, accTest.RecordTypeId != recAcc.id, 'Mudou o Recordtype');
   }
}