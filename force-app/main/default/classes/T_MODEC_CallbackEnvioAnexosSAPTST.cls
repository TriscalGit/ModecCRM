/**
 * @File Name          : T_MODEC_CallbackEnvioAnexosSAPTST.cls
 * @Description        :
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 07-22-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    04/02/2020   Rafael Hadama     Initial Version
 **/
@IsTest
public class T_MODEC_CallbackEnvioAnexosSAPTST {
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

    @isTest
    public static void UpdateDocRequestTST()
    {
        MakeMetadataAndCustomSettings();
        RecordType accRec_VendorHomologated = [Select id from Recordtype where developername = 'TW1_Vendor_Homologated'];
        Account    contamock = new Account();

        contamock.recordtypeId        = accRec_VendorHomologated.id;
        contamock.name                = 'Conta ENVIO Boletim';
        contamock.TW1_CPF__c          = '57034551030';
        contamock.TW1_Contact_Name__c = 'Contato Mock';
        insert contamock;

        //Criando TW1_Email_List__c para passar da trigger.
        TW1_Email_List__c emailList = new TW1_Email_List__c();
        emailList.TW1_Email__c  = 'emailRequestermock@mock.com';
        emailList.TW1_Status__c = 'Ativo';
        emailList.RecordTypeId  = Schema.SObjectType.TW1_Email_List__c.getRecordTypeInfosByDeveloperName().get('TW1_BM_Email').getRecordTypeId();
        insert emailList;
        //Query no recordType e criação do Request do tipo BM
        RecordType     requestRec_BM = [Select id from Recordtype where developername = 'TW1_BM'];
        TW1_Request__c BMmock1       = new TW1_Request__c();
        BMmock1.recordTypeId  = requestRec_BM.id;
        BMmock1.TW1_Vendor__c = contamock.id;
        BMmock1.BM_Status__c  = 'Não enviado';
        BMmock1.TW1_BM_Reference_Number_in_SAP_MODEC__c = '1112223334';

        BMmock1.TW1_PO__c                    = '12345';
        BMmock1.TW1_Purchase_Item__c         = '00010';
        BMmock1.TW1_Service_Start_Date__c    = date.today();
        BMmock1.TW1_Service_End_Date__c      = date.today().addDays(50);
        BMmock1.TW1_Supplier_Email__c        = 'emailSuppliermock@mock.com';
        BMmock1.TW1_Modec_Requester_Email__c = 'emailRequestermock@mock.com';
        BMmock1.TW1_Final_Measurement__c     = 'Yes';
        BMmock1.TW1_Service_Description__c   = '12345';

        insert BMmock1;

        //Create Content Version
        ContentVersion contentVersion = new ContentVersion(Title = 'Penguins', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true);
        insert         contentVersion;
        T_SDK_DebugLog.EscreverLog('Content Version insert>' + contentVersion);

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where Title = 'Penguins'];
        T_SDK_DebugLog.EscreverLog('List ContentDocument' + documents);

        //create ContentDocumentLink  record
        ContentDocumentLink cdl = new ContentDocumentLink();

        cdl.LinkedEntityId    = BMmock1.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType         = 'V';
        insert cdl;
        T_SDK_DebugLog.EscreverLog('ContentDocumentLink' + cdl);

        //Assert the callback field is not null.

        integer entrysheet = Integer.valueOf(BMmock1.TW1_BM_Reference_Number_in_SAP_MODEC__c);
        T_MODEC_CallbackEnvioAnexos_SAP.retorno RESPONSE = new T_MODEC_CallbackEnvioAnexos_SAP.retorno();
        RESPONSE.MESSAGE = 's dados foram gravados com sucesso.';
        RESPONSE.TYPE    = 'S';

        string AnexoId = documents[0].Id;
        Test.startTest();
        T_MODEC_CallbackEnvioAnexos_SAP.PostProcessaCallBack(entrysheet, AnexoId, RESPONSE);
        Test.stopTest();
        ContentVersion anexoAtualizado = [Select Id, TW1_Upload_Sucess_SAP__c from ContentVersion where Id =:contentVersion.Id];
        system.assertEquals(true, anexoAtualizado.TW1_Upload_Sucess_SAP__c != null);
    }
}