/**
 * @File Name          : T_MODEC_InspectionItem_TST.cls
 * @Description        :
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 07-22-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    29/06/2020   Rafael Hadama     Initial Version
 **/
@isTest
public class T_MODEC_InspectionItem_TST {
    @TestSetup
    public static void criarCustomSettings() //Obs.: Apenas Triggers que contêm este método serão liberadas
    {
        Controle_de_Triggers__c ctrlTriggers = new Controle_de_Triggers__c();
        ctrlTriggers.Trigger_Request__c              = true; // ***** LEMBRAR ***** (Lembrar de mudar "Trigger_Request__c" ao reutilizar código)
        ctrlTriggers.Trigger_Account__c              = true;
        ctrlTriggers.Trigger_BMItem__c               = true;
        ctrlTriggers.Trigger_Inspection_Item__c      = true;
        ctrlTriggers.Request_Vendor_Vetting_RecId__c = Schema.SObjectType.TW1_Request__c.getRecordTypeInfosByDeveloperName().get('TW1_Vendor_Vetting').getRecordTypeId();
        insert ctrlTriggers;
        //Creating Custom Settings
        ID_Account__c customSettingIdAccount = new ID_Account__c();
        customSettingIdAccount.Id_IntegrationUser__c = UserInfo.getUserId();
        insert customSettingIdAccount;
        //Buscando recordtype para preencher na custom settings
        RecordType recStep           = [SELECT Id, Name, DeveloperName, SobjectType FROM RecordType where DeveloperName = 'TW1_Approval_Step_Procurement_Manager'];
        RecordType recStep2          = [SELECT Id, Name, DeveloperName, SobjectType FROM RecordType where DeveloperName = 'TW1_Approval_Step_VVW_Attachment'];
        IDStep__c  customSettingSTEP = new IDStep__c();
        customSettingSTEP.Id_RecordType_Procurement_Manager__c = recStep.id;
        customSettingSTEP.Id_RecordType_VVW_Attachment__c      = recStep2.Id;
        insert customSettingSTEP;
        //Buscando fila para preencher custom settings
        Group filaPmanager = new Group();
        filaPmanager.Type = 'Queue';
        filaPmanager.Name = 'Procurement_Manager';
        insert       filaPmanager;
        QueueSobject mappingObjectStep    = new QueueSobject(QueueId = filaPmanager.Id, SobjectType = 'TW1_Step__c');
        QueueSobject mappingObjectRequest = new QueueSobject(QueueId = filaPmanager.Id, SobjectType = 'TW1_Request__c');
        System.runAs(new User(Id = UserInfo.getUserId()))
        {
            insert mappingObjectStep;
            insert mappingObjectRequest;
        }
        ID_Queues__c customIdQueues = new ID_Queues__c();
        customIdQueues.ID_Procurement_Manager_Queue__c = filaPmanager.Id;
        insert customIdQueues;
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
    /**
     * @description method that validates InspectionItem trigger - testing negative scenario
     * @author Rafael Hadama | 29/06/2020
     * @return void
     **/
    @isTest
    public static void CheckAllInspectionItensTST()
    {
        T_MODEC_Request_Rep RequestREP = new T_MODEC_Request_Rep();
        Test.startTest();
        TW1_Request__c Inspection = CreateInspectionRequest();

        system.debug('Inspection >' + Inspection);
        list<TW1_Inspection_Item__c> ListInspecItem = CreateInspectionItem(Inspection.Id, 3);
        system.debug('ListInspecItem >' + ListInspecItem);
        Inspection.TW1_Inspection_Status__c = 'Inspection Scheduled';
        update Inspection;
        //Atualizar campos do inspection item e depois validar os campos da request.
        Test.stopTest();
        ListInspecItem.get(0).TW1_Status__c = 'Rejected';
        ListInspecItem.get(1).TW1_Status__c = 'Approved';
        ListInspecItem.get(2).TW1_Status__c = null;
        update ListInspecItem;
        TW1_Request__c InspectionAfterUpdate = RequestREP.getRequestById(ListInspecItem.get(0).TW1_Request__c);
        system.debug('InspectionAfterUpdate.TW1_All_Inspection_Items_Status_Filled__c' + InspectionAfterUpdate.TW1_All_Inspection_Items_Status_Filled__c);
        system.debug('InspectionAfterUpdate.TW1_All_Appraisal__c.contains' + InspectionAfterUpdate.TW1_All_Appraisal__c);
        system.debug('InspectionAfterUpdate.TW1_All_Inspection_Items_Status__c' + InspectionAfterUpdate.TW1_All_Inspection_Items_Status__c);
        system.assertEquals(false, InspectionAfterUpdate.TW1_All_Inspection_Items_Status_Filled__c);
        //GUFSTODO Descomentar - system.assertEquals(true, InspectionAfterUpdate.TW1_All_Appraisal__c.contains('Rejection Reason'));
        //GUFSTODO Descomentar - system.assertEquals('Rejected', InspectionAfterUpdate.TW1_All_Inspection_Items_Status__c);

        //Realizar atualizações para que rode a trigger de Inspection Item
    }
    /**
     * @description method that validates InspectionItem trigger - testing positive scenario
     * @author Rafael Hadama | 29/06/2020
     * @return void
     **/
    @isTest
    public static void CheckAllInspectionItensTST2()
    {
        T_MODEC_Request_Rep RequestREP = new T_MODEC_Request_Rep();
        Test.startTest();
        TW1_Request__c Inspection = CreateInspectionRequest();

        system.debug('Inspection >' + Inspection);
        list<TW1_Inspection_Item__c> ListInspecItem = CreateInspectionItem(Inspection.Id, 3);
        system.debug('ListInspecItem >' + ListInspecItem);
        Inspection.TW1_Inspection_Status__c = 'Inspection Scheduled';
        update Inspection;
        //Atualizar campos do inspection item e depois validar os campos da request.
        Test.stopTest();
        ListInspecItem.get(0).TW1_Status__c = 'Approved';
        ListInspecItem.get(1).TW1_Status__c = 'Approved';
        ListInspecItem.get(2).TW1_Status__c = 'Approved';
        update ListInspecItem;
        TW1_Request__c InspectionAfterUpdate = RequestREP.getRequestById(ListInspecItem.get(0).TW1_Request__c);
        system.debug('InspectionAfterUpdate.TW1_All_Inspection_Items_Status_Filled__c' + InspectionAfterUpdate.TW1_All_Inspection_Items_Status_Filled__c);
        system.debug('InspectionAfterUpdate.TW1_All_Appraisal__c.contains' + InspectionAfterUpdate.TW1_All_Appraisal__c);
        system.debug('InspectionAfterUpdate.TW1_All_Inspection_Items_Status__c' + InspectionAfterUpdate.TW1_All_Inspection_Items_Status__c);
        //GUFSTODO Descomentar - system.assertEquals(true, InspectionAfterUpdate.TW1_All_Inspection_Items_Status_Filled__c);
        //GUFSTODO Descomentar - system.assertEquals(false, InspectionAfterUpdate.TW1_All_Appraisal__c.contains('Rejection Reason'));
        //GUFSTODO Descomentar - system.assertEquals('Approved', InspectionAfterUpdate.TW1_All_Inspection_Items_Status__c);

        //Realizar atualizações para que rode a trigger de Inspection Item
    }
    @isTest
    public static void CheckAllInspectionItensTST3()
    {
        T_MODEC_Request_Rep RequestREP = new T_MODEC_Request_Rep();
        Test.startTest();
        TW1_Request__c Inspection = CreateInspectionRequest();

        system.debug('Inspection >' + Inspection);
        list<TW1_Inspection_Item__c> ListInspecItem = CreateInspectionItem(Inspection.Id, 3);
        system.debug('ListInspecItem >' + ListInspecItem);
        Inspection.TW1_Inspection_Status__c = 'Inspection Scheduled';
        update Inspection;
        //Atualizar campos do inspection item e depois validar os campos da request.
        Test.stopTest();
        ListInspecItem.get(0).TW1_Status__c = 'Approved';
        ListInspecItem.get(1).TW1_Status__c = 'Approved';
        ListInspecItem.get(2).TW1_Status__c = 'Approved with Restriction';
        update ListInspecItem;
        TW1_Request__c InspectionAfterUpdate = RequestREP.getRequestById(ListInspecItem.get(0).TW1_Request__c);
        system.debug('InspectionAfterUpdate.TW1_All_Inspection_Items_Status_Filled__c' + InspectionAfterUpdate.TW1_All_Inspection_Items_Status_Filled__c);
        system.debug('InspectionAfterUpdate.TW1_All_Appraisal__c.contains' + InspectionAfterUpdate.TW1_All_Appraisal__c);
        system.debug('InspectionAfterUpdate.TW1_All_Inspection_Items_Status__c' + InspectionAfterUpdate.TW1_All_Inspection_Items_Status__c);
        //GUFSTODO Descomentar - system.assertEquals(true, InspectionAfterUpdate.TW1_All_Inspection_Items_Status_Filled__c);
        //GUFSTODO Descomentar - system.assertEquals(false, InspectionAfterUpdate.TW1_All_Appraisal__c.contains('Rejection Reason'));
        //GUFSTODO Descomentar - system.assertEquals('Approved with Restriction', InspectionAfterUpdate.TW1_All_Inspection_Items_Status__c);

        //Realizar atualizações para que rode a trigger de Inspection Item
    }
    public static TW1_Request__c CreateInspectionRequest()
    {
        TW1_Facility__c Unit = new TW1_Facility__c();
        Unit.TW1_Type__c = 'Office';
        Unit.Name        = 'Unit Mock';
        insert Unit;
        TW1_Request__c Inspection = new TW1_Request__c();
        Inspection.RecordTypeId                           = Schema.SObjectType.TW1_Request__c.getRecordTypeInfosByDeveloperName().get('Inspection').getRecordTypeId();
        Inspection.TW1_Purchase_Order__c                  = 'Purchase Order';
        Inspection.TW1_Work_Order__c                      = 'Work Order Mock';
        Inspection.TW1_Change_and_Repair_Project__c       = 'Change & Repair Project Mock';
        Inspection.TW1_Project_Number__c                  = '123456';
        Inspection.TW1_Management_Of_Change__c            = 'Management of change mock';
        Inspection.TW1_WO_Due_Date__c                     = date.today().addDays(10);
        Inspection.TW1_Planned_Delivery_Date__c           = date.today().addDays(15);
        Inspection.Technical_Inspection_Recommendation__c = 'Technical Inspection Rec Mock';
        Inspection.TW1_Facility__c                        = Unit.Id;
        Inspection.TW1_Inspection_Perfomed__c             = 'Pressure Test';
        Inspection.TW1_Inspection_Contact_Number__c       = '(21) 99999-9999';
        Inspection.TW1_Inspection_Address__c              = 'Macaé';
        Inspection.Inspection_Type__c                     = 'Normal';
        Inspection.TW1_Inspection_Status__c               = 'Not Submitted';
        insert Inspection;
        return Inspection;
    }
    public static list<TW1_Inspection_Item__c> CreateInspectionItem(string RequestId, integer qtd)
    {
        list<TW1_Inspection_Item__c> listInspecItens = new list<TW1_Inspection_Item__c>();
        for (integer i = 0; i < qtd; i++)
        {
            TW1_Inspection_Item__c InspecItem = new TW1_Inspection_Item__c();
            InspecItem.TW1_Item_Description__c          = 'Item Description Mock';
            InspecItem.TW1_Quantity__c                  = 5;
            InspecItem.TW1_Tag_or_Certificate_Number__c = 'Certificate Number Mock';
            InspecItem.TW1_Heat_Number__c               = 'Heat Number Mock';
            InspecItem.TW1_Request__c = RequestId;
            listInspecItens.add(InspecItem);
        }
        insert listInspecItens;
        return listInspecItens;
    }
}