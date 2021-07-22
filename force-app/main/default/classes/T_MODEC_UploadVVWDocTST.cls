/**
 * @File Name          : T_MODEC_UploadVVWDocTST.cls
 * @Description        : 
 * @Author             : Rafael Hadama
 * @Group              : 
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 10/02/2020 13:10:23
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    05/02/2020   Rafael Hadama     Initial Version
**/
@IsTest
public class T_MODEC_UploadVVWDocTST {
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
    customControleTrigger.Triscal_User_Id__c = UserInfo.getUserId();
    insert customControleTrigger;
   }

   
   @isTest public static void CreateDocumentationVVWAuxiliarTST()
   {
      MakeMetadataAndCustomSettings();
      
      Test.startTest();
      string DocCreatedId = T_MODEC_UploadVVWDoc_CTRL.createDocumentationVVWAuxiliar();
      Test.stopTest();
      
      System.assertEquals(true,DocCreatedId != '');
   }

   
   @isTest public static void UpdateDocumentationVVWAuxiliarTST()
   {
      MakeMetadataAndCustomSettings();
      RecordType accRec_VendorHomologated = [Select id from Recordtype where developername = 'TW1_Vendor_Homologated'];
      Account    contamock = new Account();

      contamock.recordtypeId        = accRec_VendorHomologated.id;
      contamock.name                = 'Conta ENVIO Boletim';
      contamock.TW1_CPF__c          = '57034551030';
      contamock.TW1_Contact_Name__c = 'Contato Mock';
      insert contamock;

      //Query no recordType e criação do Request do tipo BM
      RecordType  StepRec_BMNF = [Select id from Recordtype where developername = 'BM_NF'];
      TW1_Step__c StepMock      = new TW1_Step__c();
      StepMock.RecordTypeId = StepRec_BMNF.Id;


      insert StepMock;

      
      Test.startTest();
      string DocCreatedId = T_MODEC_UploadVVWDoc_CTRL.createDocumentationVVWAuxiliar();

      string DocUpdatedId = T_MODEC_UploadVVWDoc_CTRL.updateDocumentationVVWAuxiliar(DocCreatedId,StepMock.Id,'Comments Mock');
      Test.stopTest();
      
      System.assertEquals(true,DocUpdatedId != '');
   }

   @isTest public static void UpdateStepTST()
   {
      MakeMetadataAndCustomSettings();
      RecordType accRec_VendorHomologated = [Select id from Recordtype where developername = 'TW1_Vendor_Homologated'];
      Account    contamock = new Account();

      contamock.recordtypeId        = accRec_VendorHomologated.id;
      contamock.name                = 'Conta ENVIO Boletim';
      contamock.TW1_CPF__c          = '57034551030';
      contamock.TW1_Contact_Name__c = 'Contato Mock';
      insert contamock;

      //Query no recordType e criação do Request do tipo BM
      RecordType  StepRec_BMNF = [Select id from Recordtype where developername = 'BM_NF'];
      TW1_Step__c StepMock      = new TW1_Step__c();
      StepMock.RecordTypeId = StepRec_BMNF.Id;


      insert StepMock;

      
      Test.startTest();
      T_MODEC_UploadVVWDoc_CTRL.updateStep(StepMock.Id);      
      Test.stopTest();
      TW1_Step__c step = [Select Id,TW1_VVW_Doc_Uploaded__c  from TW1_Step__c where Id =:StepMock.Id ];
      System.assertEquals(true,step.TW1_VVW_Doc_Uploaded__c);
   }
}