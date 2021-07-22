/**
 * @File Name          : T_MODEC_AnexosFornecedorTST.cls
 * @Description        :
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 07-22-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    04/02/2020   Rafael Hadama     Initial Version
 **/
@Istest
public class T_MODEC_AnexosFornecedorTST {
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

    @isTest
    public static void SearchBmStatusTST()
    {
        //BMRequest
        MakeMetadataAndCustomSettings();
        string status = T_MODEC_AnexosFornecedor_Ctrl.searchBMStatus(BMRequest.Id);

        system.assertEquals('Aguardando', status);
    }

    @isTest
    public static void searchNFStatusTST()
    {
        //BMRequest
        MakeMetadataAndCustomSettings();



        TW1_End_Fiscal_Period__c fpDates = new TW1_End_Fiscal_Period__c();
        fpDates.TW1_JAN_INI__c = Datetime.Now();
        fpDates.TW1_JAN_END__c = Datetime.Now();
        fpDates.TW1_FEB_INI__c = Datetime.Now();
        fpDates.TW1_FEB_END__c = Datetime.Now();
        fpDates.TW1_MAR_INI__c = Datetime.Now();
        fpDates.TW1_MAR_END__c = Datetime.Now();
        fpDates.TW1_APR_INI__c = Datetime.Now();
        fpDates.TW1_APR_END__c = Datetime.Now();
        fpDates.TW1_MAY_INI__c = Datetime.Now();
        fpDates.TW1_MAY_END__c = Datetime.Now();
        fpDates.TW1_JUN_INI__c = Datetime.Now();
        fpDates.TW1_JUN_END__c = Datetime.Now();
        fpDates.TW1_JUL_INI__c = Datetime.Now();
        fpDates.TW1_JUL_END__c = Datetime.Now();
        fpDates.TW1_AUG_INI__c = Datetime.Now();
        fpDates.TW1_AUG_END__c = Datetime.Now();
        fpDates.TW1_SEP_INI__c = Datetime.Now();
        fpDates.TW1_SEP_END__c = Datetime.Now();
        fpDates.TW1_OCT_INI__c = Datetime.Now();
        fpDates.TW1_OCT_END__c = Datetime.Now();
        fpDates.TW1_NOV_INI__c = Datetime.Now();
        fpDates.TW1_NOV_END__c = Datetime.Now();
        fpDates.TW1_DEC_INI__c = Datetime.Now();
        fpDates.TW1_DEC_END__c = Datetime.Now();
        insert fpDates;

        Test.startTest();
        string status = T_MODEC_AnexosFornecedor_Ctrl.searchNFStatus(BMRequest.Id);
        T_MODEC_AnexosFornecedor_Ctrl.NFDTO notafiscalDTO = (T_MODEC_AnexosFornecedor_Ctrl.NFDTO)JSON.deserialize(status, T_MODEC_AnexosFornecedor_Ctrl.NFDTO.class);
        Test.stopTest();
        system.assertEquals('NF Accepted or Awaiting evaluation.', notafiscalDTO.message);
    }

    @isTest
    public static void searchNFStatusBlockFiscalPeriodTST()
    {
        //BMRequest
        MakeMetadataAndCustomSettings();



        TW1_End_Fiscal_Period__c fpDates = new TW1_End_Fiscal_Period__c();
        fpDates.TW1_JAN_INI__c = Datetime.Now().AddDays(-1);
        fpDates.TW1_JAN_END__c = Datetime.Now().AddDays(1);
        fpDates.TW1_FEB_INI__c = Datetime.Now();
        fpDates.TW1_FEB_END__c = Datetime.Now();
        fpDates.TW1_MAR_INI__c = Datetime.Now();
        fpDates.TW1_MAR_END__c = Datetime.Now();
        fpDates.TW1_APR_INI__c = Datetime.Now();
        fpDates.TW1_APR_END__c = Datetime.Now();
        fpDates.TW1_MAY_INI__c = Datetime.Now();
        fpDates.TW1_MAY_END__c = Datetime.Now();
        fpDates.TW1_JUN_INI__c = Datetime.Now();
        fpDates.TW1_JUN_END__c = Datetime.Now();
        fpDates.TW1_JUL_INI__c = Datetime.Now();
        fpDates.TW1_JUL_END__c = Datetime.Now();
        fpDates.TW1_AUG_INI__c = Datetime.Now();
        fpDates.TW1_AUG_END__c = Datetime.Now();
        fpDates.TW1_SEP_INI__c = Datetime.Now();
        fpDates.TW1_SEP_END__c = Datetime.Now();
        fpDates.TW1_OCT_INI__c = Datetime.Now();
        fpDates.TW1_OCT_END__c = Datetime.Now();
        fpDates.TW1_NOV_INI__c = Datetime.Now();
        fpDates.TW1_NOV_END__c = Datetime.Now();
        fpDates.TW1_DEC_INI__c = Datetime.Now();
        fpDates.TW1_DEC_END__c = Datetime.Now();
        insert fpDates;

        Test.startTest();
        string status = T_MODEC_AnexosFornecedor_Ctrl.searchNFStatus(BMRequest.Id);
        T_MODEC_AnexosFornecedor_Ctrl.NFDTO notafiscalDTO = (T_MODEC_AnexosFornecedor_Ctrl.NFDTO)JSON.deserialize(status, T_MODEC_AnexosFornecedor_Ctrl.NFDTO.class);
        Test.stopTest();
        system.assertEquals('NF Upload blocked by Fiscal Period', notafiscalDTO.message);
    }

    @isTest
    public static void CurrentUserIdTST()
    {
        string UserId = T_MODEC_AnexosFornecedor_Ctrl.getCurrentUserId();

        system.assertEquals(UserInfo.getUserId(), UserId);
    }

    @isTest
    public static void RelateToDocumentationTST()
    {
        //BMRequest
        MakeMetadataAndCustomSettings();
        ContentVersion contentVersion = new ContentVersion(Title = 'Penguins', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true);
        insert         contentVersion;
        T_SDK_DebugLog.EscreverLog('Content Version insert>' + contentVersion);

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where Title = 'Penguins'];
        T_SDK_DebugLog.EscreverLog('List ContentDocument' + documents);

        List<String> listDocIds = new List<String>();
        listDocIds.add(documents[0].Id);
        Test.startTest();
        string status = T_MODEC_AnexosFornecedor_Ctrl.relateToDocumentation(listDocIds, true, BMRequest.Id, '1234567890');
        Test.stopTest();
        system.assertEquals('Sucesso', status);
    }
}