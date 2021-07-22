/**
 * @description       :
 * @author            : Rafael Hadama
 * @group             :
 * @last modified on  : 10-29-2020
 * @last modified by  : Rafael Hadama
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   10-29-2020   Rafael Hadama   Initial Version
 **/
@Istest
public class T_MODEC_UpdateFromPortal_TST {
    @isTest
    public static void RequestTst()
    {
        T_MODEC_Request_App_TST.criarCustomSettings();
        TW1_Request__c req = T_MODEC_Request_App_TST.criarRegistroMock();

        system.debug('req ' + req);
        Test.startTest();
        string objecttype         = 'TW1_Request__c';
        Id     batchEnvioAnexosId = Database.executeBatch(new T_MODEC_UpdateFromPortal(objecttype), 5);

        system.debug('Batch process id:' + batchEnvioAnexosId);

        Test.stopTest();
        TW1_Request__c reqValidate = [Select id, TW3_From_Portal__c from TW1_Request__c where id =:req.Id];
        system.debug('reqValidate ' + reqValidate);
        system.assertEquals(true, reqValidate.TW3_From_Portal__c == 'Brazil');
    }

    @Istest
    public static void DocTst()
    {
        T_MODEC_DeleteDocumentationTST.MakeMetadataAndCustomSettings();
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
        system.debug('DocCreatedId:' + DocCreatedId);
        Test.startTest();
        string objecttype         = 'TW1_Documentation__c';
        Id     batchEnvioAnexosId = Database.executeBatch(new T_MODEC_UpdateFromPortal(objecttype), 5);

        system.debug('Batch process id:' + batchEnvioAnexosId);

        Test.stopTest();
        TW1_Documentation__c docValidate = [Select id, TW3_From_Portal__c from TW1_Documentation__c where id =:DocCreatedId];
        system.debug('docValidate ' + docValidate);
        system.assertEquals(true, docValidate.TW3_From_Portal__c == 'Brazil');
    }

    @Istest
    public static void StepTst()
    {
        T_MODEC_StepTrigger_TST.criarCustomSettings();
        T_MODEC_Request_Rep RequestREP = new T_MODEC_Request_Rep();
        String              RecTypeStepDateConfirmation = Schema.SObjectType.TW1_Step__c.getRecordTypeInfosByDeveloperName().get('Approval_Step_Date_Confirmation').getRecordTypeId();
        //Creating inspection
        TW1_Request__c InspectionRequest = T_MODEC_ScheduleInspection_TST.CreateInspectionRequest();

        //Creating Inspection item
        T_MODEC_InspectionItem_TST.CreateInspectionItem(InspectionRequest.Id, 1);

        InspectionRequest.TW1_Inspection_Status__c         = 'Awaiting Date Confirmation';
        InspectionRequest.TW1_Inspection_Scheduled_Date__c = Datetime.now().addDays(5);
        update InspectionRequest;

        //Criada pelo process builder.
        TW1_Step__c StepDateConfirmation = new TW1_Step__c();
        StepDateConfirmation.TW1_Request__c = InspectionRequest.Id;
        StepDateConfirmation.TW1_Inspection_Scheduled_Date__c = InspectionRequest.TW1_Inspection_Scheduled_Date__c;
        StepDateConfirmation.TW1_Status__c = 'Opened';
        StepDateConfirmation.RecordTypeId  = RecTypeStepDateConfirmation;
        insert StepDateConfirmation;
        //[Select id, TW1_Request__c from TW1_Step__c where TW1_Request__c =:InspectionRequest.Id AND RecordtypeId =:RecTypeStepDateConfirmation];
        system.debug('StepDateConfirmation >>' + StepDateConfirmation);

        Test.startTest();
        string objecttype         = 'TW1_Step__c';
        Id     batchEnvioAnexosId = Database.executeBatch(new T_MODEC_UpdateFromPortal(objecttype), 5);

        system.debug('Batch process id:' + batchEnvioAnexosId);

        Test.stopTest();
        TW1_Step__c stepValidate = [Select id, TW3_From_Portal__c from TW1_Step__c where id =:StepDateConfirmation.Id];
        system.debug('stepValidate ' + stepValidate);
        system.assertEquals(true, stepValidate.TW3_From_Portal__c == 'Brazil');
    }

    @Istest
    public static void IntTst()
    {
    }
}