/**
 * @File Name          : T_MODEC_ExpirarCategoria_TST.cls
 * @Description        : 
 * @Author             : Rafael Hadama
 * @Group              : 
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 26/02/2020 16:45:08
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    19/02/2020   Rafael Hadama     Initial Version
**/
@isTest
public with sharing class T_MODEC_ExpirarCategoria_TST {
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

   @isTest public static void ExpirarCategoria_TST()
   {
      MakeMetadataAndCustomSettings();
      RecordType recAcc = [SELECT Id, DeveloperName, SObjectType FROM RecordType WHERE SObjectType = 'Account' And DeveloperName = 'TW1_Vendor_Homologated'];

      Account conta = new Account();
      conta.Name = 'Mario Teste';
      conta.TW1_Shelf_Life_Vetting_Date__c = Date.today().addDays(-2);
      conta.RecordTypeId        = recAcc.id;
      conta.TW1_Contact_Name__c = 'Contato Mock';
      insert conta;

      /*
       *  Passo 2 - Criar uma nova TW1_Category__c:
       */
      TW1_Category__c categ = new TW1_Category__c();
      RecordType      cat   = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'TW1_Material'];
      categ.RecordTypeId    = cat.Id;
      categ.TW1_Category__c = 'Nome Categoria';
      insert categ;

      /*
       *  Passo 3 - Criar uma nova TW1_Vendor_Category__c:
       */
      TW1_Vendor_Category__c vendorCateg = new TW1_Vendor_Category__c();
      vendorCateg.TW1_VEndor__c   = conta.id;
      vendorCateg.TW1_Category__c = categ.id;
      vendorCateg.TW1_Status__c = 'Homologated';
      vendorCateg.TW1_Expiration_Date__c = Date.today().addDays(-1);
      insert vendorCateg;

      Test.startTest();
      T_SDK_ScheaduleUtils.scheadule('T_MODEC_SCH_ExpirarCategoria', 1);
      Test.stopTest();

      TW1_Vendor_Category__c VendCategoryTST = [SELECT Id,TW1_Status__c From TW1_Vendor_Category__c Where Id =:vendorCateg.Id];

      System.assertEquals(true, VendCategoryTST.TW1_Status__c == 'Expired');
   }
}