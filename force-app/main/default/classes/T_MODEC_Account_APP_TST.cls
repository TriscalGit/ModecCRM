/**
 * @File Name          : T_MODEC_Account_APP_TST.cls
 * @Description        :
 * @Author             : Mario Oliveira
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 06/02/2020 12:13:44
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    05/12/2019   Mario Oliveira     Initial Version
 **/
@isTest
public with sharing class T_MODEC_Account_APP_TST
{ 
   
   public static void criarCustomSettings()  //Obs.: Apenas Triggers que contêm este método serão liberadas
   {
      Controle_de_Triggers__c ctrlTriggers = new Controle_de_Triggers__c();

      ctrlTriggers.Trigger_Account__c = true; // ***** LEMBRAR ***** (Lembrar de mudar "Trigger_Account__c" ao reutilizar código)
      insert ctrlTriggers;

      //Buscando recordtype para preencher na custom settings
      RecordType recStep = [SELECT Id, Name, DeveloperName, SobjectType FROM RecordType where DeveloperName = 'TW1_Approval_Step_Procurement_Manager'];

      IDStep__c customSettingSTEP = new IDStep__c();
      customSettingSTEP.Id_RecordType_Procurement_Manager__c = recStep.id;
      insert customSettingSTEP;

      //Buscando fila para preencher custom settings     

      Group      filaPmanager         = new Group();
      filaPmanager.Type = 'Queue';
      filaPmanager.Name = 'Procurement_Manager';
      insert       filaPmanager;
      QueueSobject mappingObjectStep = new QueueSobject(QueueId = filaPmanager.Id, SobjectType = 'TW1_Step__c');
      QueueSobject mappingObjectRequest = new QueueSobject(QueueId = filaPmanager.Id, SobjectType = 'TW1_Request__c');
      System.runAs(new User(Id = UserInfo.getUserId()))
      {
         insert mappingObjectStep;
         insert mappingObjectRequest;
      }
      ID_Queues__c customIdQueues = new ID_Queues__c();
      customIdQueues.ID_Procurement_Manager_Queue__c = filaPmanager.Id;
      insert customIdQueues;

      //Buscando Usuário de integração para preencher custom settings devido ao process builder Account - General process
      
      ID_Account__c customSettingsIDAccount = new ID_Account__c();
      customSettingsIDAccount.Id_IntegrationUser__c = UserInfo.getUserId();
      insert customSettingsIDAccount;
      /*******************************************/

      T_Debug_Setting__mdt testsetting;

      testsetting                                = new T_Debug_Setting__mdt();
      testsetting.Label                          = 'Teste';
      testsetting.DeveloperName                  = 'Teste';
      testsetting.T_Armazenar_Cause__c           = true;
      testsetting.T_Armazenar_linha_debug__c     = true;
      testsetting.T_Armazenar_StackTrace__c      = true;
      testsetting.T_Armazenar_texto_Exception__c = true;
      T_SDK_DebugLog_Test.testsetting            = testsetting;
   }

   @isTest
   public static void criarContatoTST()
   {
      criarCustomSettings();

      Account account = new Account();
      account.RecordTypeId                 = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('TW1_Vendor_Homologated').getRecordTypeId();
      account.Name                         = 'Teste da Silva';
      account.TW1_Contact_Name__c          = 'Teste da Silva Silva';
      account.TW1_Contact_Phone__c         = '96949869';
      account.TW1_Contact_email_address__c = 'teste@teste.com';

      insert account;
      T_SDK_DebugLog.EscreverLog('Account Id: ' + account.id);

      Contact cont = [ SELECT Id, AccountId FROM Contact WHERE AccountId =: account.Id ];

      T_SDK_DebugLog.EscreverLog('Contact: ' + cont);

      System.assertEquals(account.id, cont.AccountId, 'Contato não foi criado.(1)');
   }

}