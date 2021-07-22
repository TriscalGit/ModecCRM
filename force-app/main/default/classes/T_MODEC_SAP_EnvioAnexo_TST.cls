/**
 * @File Name          : T_MODEC_SAP_EnvioAnexo_TST.cls
 * @Description        : Classe de teste para a integração de Envio de anexo.
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 07-22-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    25/11/2019   Rafael Hadama     Initial Version
 **/
@Istest
public class T_MODEC_SAP_EnvioAnexo_TST {
    static TW1_Request__c BMRequest { get; set; }

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

        RecordType StePRecTypeBMNF = [Select id, SobjectType from Recordtype where developername = 'BM_NF' AND SobjectType = 'TW1_Step__c'];
        Group      filaSED         = new Group();
        filaSED.Type = 'Queue';
        filaSED.Name = 'SedQueue';
        insert       filaSED;
        QueueSobject mappingObject = new QueueSobject(QueueId = filaSED.Id, SobjectType = 'TW1_Step__c');
        System.runAs(new User(Id = UserInfo.getUserId()))
        {
            insert mappingObject;
        }
        ID_Queues__c customIdQueues = new ID_Queues__c();
        customIdQueues.ID_SED_Queue__c = filaSED.Id;
        insert customIdQueues;

        IDStep__c customIdSteps = new IDStep__c();
        customIdSteps.Id_RecordType_Step_BM_NF__c = StePRecTypeBMNF.Id;
        insert customIdSteps;
        //Creating Test mock data
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
        BMmock1.BM_Status__c  = 'Aguardando';
        BMmock1.TW1_BM_Reference_Number_in_SAP_MODEC__c = '1112223334';

        BMmock1.TW1_PO__c                    = '12345';
        BMmock1.TW1_Purchase_Item__c         = '00010';
        BMmock1.TW1_Service_Start_Date__c    = date.today();
        BMmock1.TW1_Service_End_Date__c      = date.today().addDays(50);
        BMmock1.TW1_Supplier_Email__c        = 'emailSuppliermock@mock.com';
        BMmock1.TW1_Modec_Requester_Email__c = 'emailRequestermock@mock.com';
        BMmock1.TW1_Final_Measurement__c     = 'Yes';
        BMmock1.TW1_Service_Description__c   = '12345';
        BMmock1.TW1_NF_Invoice_Status__c     = 'NF Accepted';

        insert BMmock1;
        //Relacionando com o Request static variable
        BMRequest = BMmock1;
    }

    @istest
    static void enviarAnexoSAP()
    {
        MakeMetadataAndCustomSettings();
        Test.setMock(HttpCalloutMock.class, new T_MODEC_MockResponseGenerator());

        ContentVersion contentVersion = new ContentVersion(Title = 'Penguins', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true);
        insert         contentVersion;
        T_SDK_DebugLog.EscreverLog('Content Version insert>' + contentVersion);

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where Title = 'Penguins'];
        T_SDK_DebugLog.EscreverLog('List ContentDocument' + documents);

        //create ContentDocumentLink  record
        ContentDocumentLink cdl = new ContentDocumentLink();

        cdl.LinkedEntityId    = BMRequest.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType         = 'V';
        insert cdl;
        T_SDK_DebugLog.EscreverLog('ContentDocumentLink' + cdl);


        /*BM_Item__c linhaBm = new BM_Item__c();
         * linhaBm.Request__c          = BMmock1.id;
         * linhaBm.TW1_Service_Line__c = '0000000010';
         * linhaBm.T_Quantity__c       = 1;
         * linhaBm.TW1_Gross_Value__c  = 100;
         * insert linhaBm;*/

        //T_MODEC_Content_REP contentREP = new T_MODEC_Content_REP();
        //ContentVersion arquivo = T_MODEC_Content_REP.getContentVersionbyId('0692f000000PXJLAA4');

        Test.startTest();

        T_MODEC_SAP_EnvioAnexo_App.executarBatchEnvioAnexos();

        Test.stopTest();
    }

    @istest
    static void enviarAnexoSAPNegativeNF()
    {
        MakeMetadataAndCustomSettings();
        Test.setMock(HttpCalloutMock.class, new T_MODEC_MockResponseGenerator());

        ContentVersion contentVersion = new ContentVersion(Title = 'Penguins', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true, TW1_IsNF__c = true);
        insert         contentVersion;
        T_SDK_DebugLog.EscreverLog('Content Version insert>' + contentVersion);

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where Title = 'Penguins'];
        T_SDK_DebugLog.EscreverLog('List ContentDocument' + documents);

        //create ContentDocumentLink  record
        ContentDocumentLink cdl = new ContentDocumentLink();

        cdl.LinkedEntityId    = BMRequest.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType         = 'V';
        insert cdl;
        T_SDK_DebugLog.EscreverLog('ContentDocumentLink' + cdl);


        //T_MODEC_Content_REP contentREP = new T_MODEC_Content_REP();
        //ContentVersion arquivo = T_MODEC_Content_REP.getContentVersionbyId('0692f000000PXJLAA4');

        Test.startTest();

        T_MODEC_SAP_EnvioAnexo_App.executarBatchEnvioAnexos();

        Test.stopTest();
    }

    @istest
    static void enviarAnexoSAPNegativeUploadSuccess()
    {
        MakeMetadataAndCustomSettings();
        Test.setMock(HttpCalloutMock.class, new T_MODEC_MockResponseGenerator());

        ContentVersion contentVersion = new ContentVersion(Title = 'Penguins', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true);
        contentVersion.TW1_Upload_Sucess_SAP__c = datetime.now();
        insert contentVersion;
        T_SDK_DebugLog.EscreverLog('Content Version insert>' + contentVersion);

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where Title = 'Penguins'];
        T_SDK_DebugLog.EscreverLog('List ContentDocument' + documents);

        //create ContentDocumentLink  record
        ContentDocumentLink cdl = new ContentDocumentLink();

        cdl.LinkedEntityId    = BMRequest.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType         = 'V';
        insert cdl;
        T_SDK_DebugLog.EscreverLog('ContentDocumentLink' + cdl);


        //T_MODEC_Content_REP contentREP = new T_MODEC_Content_REP();
        //ContentVersion arquivo = T_MODEC_Content_REP.getContentVersionbyId('0692f000000PXJLAA4');

        Test.startTest();

        T_MODEC_SAP_EnvioAnexo_App.executarBatchEnvioAnexos();

        Test.stopTest();
    }

    @istest
    static void enviarAnexoSAPNegativeWaitingResponse()
    {
        MakeMetadataAndCustomSettings();
        Test.setMock(HttpCalloutMock.class, new T_MODEC_MockResponseGenerator());

        ContentVersion contentVersion = new ContentVersion(Title = 'Penguins', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true);
        contentVersion.TW1_Last_SAP_request__c  = datetime.now();
        contentVersion.TW1_Last_SAP_response__c = datetime.now().addMinutes(-10);
        insert contentVersion;
        T_SDK_DebugLog.EscreverLog('Content Version insert>' + contentVersion);

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where Title = 'Penguins'];
        T_SDK_DebugLog.EscreverLog('List ContentDocument' + documents);

        //create ContentDocumentLink  record
        ContentDocumentLink cdl = new ContentDocumentLink();

        cdl.LinkedEntityId    = BMRequest.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType         = 'V';
        insert cdl;
        T_SDK_DebugLog.EscreverLog('ContentDocumentLink' + cdl);


        //T_MODEC_Content_REP contentREP = new T_MODEC_Content_REP();
        //ContentVersion arquivo = T_MODEC_Content_REP.getContentVersionbyId('0692f000000PXJLAA4');

        Test.startTest();

        T_MODEC_SAP_EnvioAnexo_App.executarBatchEnvioAnexos();

        Test.stopTest();
    }

    @istest
    static void enviarAnexoSAPNegativeWaitingFirstResponse()
    {
        MakeMetadataAndCustomSettings();
        Test.setMock(HttpCalloutMock.class, new T_MODEC_MockResponseGenerator());

        ContentVersion contentVersion = new ContentVersion(Title = 'Penguins', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true);
        contentVersion.TW1_Last_SAP_request__c  = datetime.now();
        contentVersion.TW1_Last_SAP_response__c = null;
        insert contentVersion;
        T_SDK_DebugLog.EscreverLog('Content Version insert>' + contentVersion);

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where Title = 'Penguins'];
        T_SDK_DebugLog.EscreverLog('List ContentDocument' + documents);

        //create ContentDocumentLink  record
        ContentDocumentLink cdl = new ContentDocumentLink();

        cdl.LinkedEntityId    = BMRequest.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType         = 'V';
        insert cdl;
        T_SDK_DebugLog.EscreverLog('ContentDocumentLink' + cdl);


        //T_MODEC_Content_REP contentREP = new T_MODEC_Content_REP();
        //ContentVersion arquivo = T_MODEC_Content_REP.getContentVersionbyId('0692f000000PXJLAA4');

        Test.startTest();

        T_MODEC_SAP_EnvioAnexo_App.executarBatchEnvioAnexos();

        Test.stopTest();
    }

    @isTest public static void ScheduleJobTST()
    {
        Test.startTest();
        T_SDK_ScheaduleUtils.scheadule('T_MODEC_SCH_EnviarAnexos', 1);
        Test.stopTest();
    }
}