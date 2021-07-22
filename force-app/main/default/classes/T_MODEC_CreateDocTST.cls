/**
 * @File Name          : T_MODEC_CreateDocTST.cls
 * @Description        : Classe de teste para Componente do lightning CreateDoc
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 07-22-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    03/02/2020   Rafael Hadama     Initial Version
 **/
@IsTest
public class T_MODEC_CreateDocTST {
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
        
        QueueSobject queue = [SELECT QueueId FROM QueueSobject where SobjectType =: 'TW1_Interaction__c' and Queue.DeveloperName =: 'VV_Team' limit 1];
        ID_Queues__c customSettingIDQueues = new ID_Queues__c();
        customSettingIDQueues.ID_VV_Team_Queue__c = queue.QueueId;
        insert customSettingIDQueues;
    }

    @isTest
    public static void findSobjectTypeTST()
    {
        MakeMetadataAndCustomSettings();
        Test.startTest();
        RecordType accRec_VendorHomologated = [Select id from Recordtype where developername = 'TW1_Vendor_Homologated'];
        Account    contamock = new Account();

        contamock.recordtypeId        = accRec_VendorHomologated.id;
        contamock.name                = 'Conta ENVIO Boletim';
        contamock.TW1_CPF__c          = '57034551030';
        contamock.TW1_Contact_Name__c = 'Contato Mock';
        insert contamock;

        T_MODEC_CreateDoc_CTRL.findSobjectType(string.valueOf(contamock.Id));

        list<T_MODEC_CreateDoc_CTRL.recTypesDto> listRecTypes = T_MODEC_CreateDoc_CTRL.getlistRecTypesDocumentation(contamock.Id);
        system.assertEquals(true, listRecTypes.size() > 0);
        map<string, String> mapRecTypes = T_MODEC_CreateDoc_CTRL.getRectypeMap(contamock.Id);
        system.assertEquals(true, mapRecTypes.size() > 0);
    }

    @isTest
    public static void CreateDocumentationTST()
    {
        MakeMetadataAndCustomSettings();
        Test.startTest();
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

        list<T_MODEC_CreateDoc_CTRL.recTypesDto> listRecTypes = T_MODEC_CreateDoc_CTRL.getlistRecTypesDocumentation(contamock.Id);

        string DocCreatedId = T_MODEC_CreateDoc_CTRL.createDocumentationAuxiliar(listRecTypes[0].value, BMmock1.Id);
        system.assertEquals(true, DocCreatedId != '');
    }

    @isTest
    public static void UpdateDocRequestTST()
    {
        MakeMetadataAndCustomSettings();
        Test.startTest();
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

        list<T_MODEC_CreateDoc_CTRL.recTypesDto> listRecTypes = T_MODEC_CreateDoc_CTRL.getlistRecTypesDocumentation(contamock.Id);

        string DocCreatedId = T_MODEC_CreateDoc_CTRL.createDocumentationAuxiliar(listRecTypes[0].value, BMmock1.Id);
        string UpdateDocId  = T_MODEC_CreateDoc_CTRL.updateDoc(DocCreatedId, BMmock1.Id, 'Comentarios Mock');

        system.assertEquals(true, DocCreatedId == UpdateDocId);
    }

    @isTest
    public static void UpdateDocStepTST()
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
        TW1_Step__c StepMock     = new TW1_Step__c();
        StepMock.RecordTypeId = StepRec_BMNF.Id;


        insert StepMock;

        list<T_MODEC_CreateDoc_CTRL.recTypesDto> listRecTypes = T_MODEC_CreateDoc_CTRL.getlistRecTypesDocumentation(StepMock.Id);

        string DocCreatedId = T_MODEC_CreateDoc_CTRL.createDocumentationAuxiliar(listRecTypes[0].value, StepMock.Id);
        string UpdateDocId  = T_MODEC_CreateDoc_CTRL.updateDoc(DocCreatedId, StepMock.Id, 'Comentarios Mock');

        system.assertEquals(true, DocCreatedId == UpdateDocId);
    }

    @isTest
    public static void UpdateDocInteractionTST()
    {
        MakeMetadataAndCustomSettings();
        Test.startTest();
        RecordType accRec_VendorHomologated = [Select id from Recordtype where developername = 'TW1_Vendor_Homologated'];
        Account    contamock = new Account();

        contamock.recordtypeId        = accRec_VendorHomologated.id;
        contamock.name                = 'Conta ENVIO Boletim';
        contamock.TW1_CPF__c          = '57034551030';
        contamock.TW1_Contact_Name__c = 'Contato Mock';
        insert contamock;

        //Query no recordType e criação do Request do tipo BM
        RecordType         interactionRecType = [Select id from Recordtype where developername = 'TW1_QA_QC_Inspection'];
        TW1_Interaction__c InteractionMock    = new TW1_Interaction__c();
        InteractionMock.RecordTypeId = interactionRecType.Id;
        InteractionMock.TW3_From_Portal__c = 'Brazil';

        insert InteractionMock;

        list<T_MODEC_CreateDoc_CTRL.recTypesDto> listRecTypes = T_MODEC_CreateDoc_CTRL.getlistRecTypesDocumentation(InteractionMock.Id);

        string DocCreatedId = T_MODEC_CreateDoc_CTRL.createDocumentationAuxiliar(listRecTypes[0].value, InteractionMock.Id);
        string UpdateDocId  = T_MODEC_CreateDoc_CTRL.updateDoc(DocCreatedId, InteractionMock.Id, 'Comentarios Mock');

        system.assertEquals(true, DocCreatedId == UpdateDocId);
    }

    @isTest
    public static void UpdateDocModecContractTST()
    {
        MakeMetadataAndCustomSettings();
        Test.startTest();
        RecordType accRec_VendorHomologated = [Select id from Recordtype where developername = 'TW1_Vendor_Homologated'];
        Account    contamock = new Account();

        contamock.recordtypeId        = accRec_VendorHomologated.id;
        contamock.name                = 'Conta ENVIO Boletim';
        contamock.TW1_CPF__c          = '57034551030';
        contamock.TW1_Contact_Name__c = 'Contato Mock';
        insert contamock;

        //Query no recordType e criação do Request do tipo BM

        TW1_MODEC_Contract__c ContractMock = new TW1_MODEC_Contract__c();
        ContractMock.TW1_Vendor__c = contamock.Id;
        ContractMock.Name          = 'Contrato Mock';


        insert ContractMock;

        list<T_MODEC_CreateDoc_CTRL.recTypesDto> listRecTypes = T_MODEC_CreateDoc_CTRL.getlistRecTypesDocumentation(ContractMock.Id);

        string DocCreatedId = T_MODEC_CreateDoc_CTRL.createDocumentationAuxiliar(listRecTypes[0].value, ContractMock.Id);
        string UpdateDocId  = T_MODEC_CreateDoc_CTRL.updateDoc(DocCreatedId, ContractMock.Id, 'Comentarios Mock');

        system.assertEquals(true, DocCreatedId == UpdateDocId);
    }

    @isTest
    public static void InsertDocModecContractNegativeTST()
    {
        MakeMetadataAndCustomSettings();
        Test.startTest();
        RecordType accRec_VendorHomologated = [Select id from Recordtype where developername = 'TW1_Vendor_Homologated'];
        Account    contamock = new Account();

        contamock.recordtypeId        = accRec_VendorHomologated.id;
        contamock.name                = 'Conta ENVIO Boletim';
        contamock.TW1_CPF__c          = '57034551030';
        contamock.TW1_Contact_Name__c = 'Contato Mock';
        insert contamock;

        //Query no recordType e criação do Request do tipo BM

        TW1_MODEC_Contract__c ContractMock = new TW1_MODEC_Contract__c();
        ContractMock.TW1_Vendor__c = contamock.Id;
        ContractMock.Name          = 'Contrato Mock';


        insert ContractMock;

        list<T_MODEC_CreateDoc_CTRL.recTypesDto> listRecTypes = T_MODEC_CreateDoc_CTRL.getlistRecTypesDocumentation(ContractMock.Id);

        string DocCreatedId = T_MODEC_CreateDoc_CTRL.createDocumentationAuxiliar(listRecTypes[0].value, ContractMock.Id);

        string DocCreatedIdNegative = T_MODEC_CreateDoc_CTRL.createDocumentationAuxiliar('', ContractMock.Id);
        system.assertEquals(true, DocCreatedIdNegative == '');

        //Passing empty string as Id

        /*string UpdateDocIdNegative  = T_MODEC_CreateDoc_CTRL.updateDoc(DocCreatedId, '', 'Comentarios Mock');
         *
         * system.assertEquals(true, UpdateDocIdNegative == '');*/
    }

    @isTest
    public static void UpdateDocModecContractNegativeTST()
    {
        MakeMetadataAndCustomSettings();
        Test.startTest();
        RecordType accRec_VendorHomologated = [Select id from Recordtype where developername = 'TW1_Vendor_Homologated'];
        Account    contamock = new Account();

        contamock.recordtypeId        = accRec_VendorHomologated.id;
        contamock.name                = 'Conta ENVIO Boletim';
        contamock.TW1_CPF__c          = '57034551030';
        contamock.TW1_Contact_Name__c = 'Contato Mock';
        insert contamock;

        //Query no recordType e criação do Request do tipo BM

        TW1_MODEC_Contract__c ContractMock = new TW1_MODEC_Contract__c();
        ContractMock.TW1_Vendor__c = contamock.Id;
        ContractMock.Name          = 'Contrato Mock';


        insert ContractMock;

        list<T_MODEC_CreateDoc_CTRL.recTypesDto> listRecTypes = T_MODEC_CreateDoc_CTRL.getlistRecTypesDocumentation(ContractMock.Id);

        string DocCreatedId = T_MODEC_CreateDoc_CTRL.createDocumentationAuxiliar(listRecTypes[0].value, ContractMock.Id);

        //Passing empty string as Id
        string UpdateDocId         = T_MODEC_CreateDoc_CTRL.updateDoc(DocCreatedId, ContractMock.Id, 'Comentarios Mock');
        string UpdateDocIdNegative = T_MODEC_CreateDoc_CTRL.updateDoc('', ContractMock.Id, 'Comentarios Mock');

        system.assertEquals(true, UpdateDocIdNegative == '');
    }
    
    @isTest
    public static void getTypeOfRecordIdTST(){
        Lead record = new Lead();
        record.company = 'Test a Teste';
        record.lastName = 'Sr Teste';
        record.Email = 'test@teste.com';
        insert record;
        
        Test.startTest();        
        String msgComId = T_MODEC_CreateDoc_CTRL.getTypeOfRecordId(record.Id);
		Test.stopTest();

        System.assertEquals('Lead', msgComId);
    }
    
    @isTest
    public static void TestMethod_getMainSObjectRecordFromRecordId(){
        Lead l = new Lead();
        l.lastName = 'TestMethod_getMainSObjectRecordFromRecordId';
        l.company = 'TestMethod_getMainSObjectRecordFromRecordId';
        l.Email = 'test@test.com';
        insert l;
        Id recordId = l.id;
        T_MODEC_CreateDoc_CTRL.getMainSObjectRecordFromRecordId(recordId, 'Email');
    }
}