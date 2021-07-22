/**
 * @description       : T_MODEC_StepTrigger_TST.cls
 * @author            : Rafael Hadama
 * @group             :
 * @last modified on  : 07-22-2020
 * @last modified by  : Rafael Hadama
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   07-06-2020   Rafael Hadama   Initial Version
 **/
@Istest
public class T_MODEC_StepTrigger_TST {
    @TestSetup
    public static void criarCustomSettings() //Obs.: Apenas Triggers que contêm este método serão liberadas
    {
        Controle_de_Triggers__c ctrlTriggers = new Controle_de_Triggers__c();

        ctrlTriggers.Trigger_Request__c         = true;      // ***** LEMBRAR ***** (Lembrar de mudar "Trigger_Request__c" ao reutilizar código)
        ctrlTriggers.Trigger_Account__c         = true;
        ctrlTriggers.Trigger_BMItem__c          = true;
        ctrlTriggers.Trigger_Inspection_Item__c = true;
        ctrlTriggers.Trigger_Step__c            = true;
        ctrlTriggers.TW2_Inspection_Advance_Hours_Schedule__c = 48;
        ctrlTriggers.TW2_Inspection_Daily_Hour_Break__c       = 15;
        ctrlTriggers.Request_Vendor_Vetting_RecId__c          = Schema.SObjectType.TW1_Request__c.getRecordTypeInfosByDeveloperName().get('TW1_Vendor_Vetting').getRecordTypeId();
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

    @isTest
    public static void CloseStepConfirmationDateCanceled()
    {
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
        StepDateConfirmation.TW1_Status__c = 'Closed';
        //StepDateConfirmation.TW1_Conclusion_Date__c = Datetime.Now();
        StepDateConfirmation.TW1_Inspection_Date_Confirmation__c = 'Cancel';
        update StepDateConfirmation;
        system.debug('StepDateConfirmation apos update >>' + StepDateConfirmation);
        Test.stopTest();
        TW1_Request__c inspection = RequestREP.getInspectionAndInspectionLines(InspectionRequest.Id);

        system.assertEquals('Canceled', inspection.TW1_Inspection_Status__c);
    }

    @isTest
    public static void CloseStepConfirmationDateReproved()
    {
        T_MODEC_Request_Rep RequestREP = new T_MODEC_Request_Rep();
        String              RecTypeStepDateConfirmation = Schema.SObjectType.TW1_Step__c.getRecordTypeInfosByDeveloperName().get('Approval_Step_Date_Confirmation').getRecordTypeId();
        //Creating inspection
        TW1_Request__c InspectionRequest = T_MODEC_ScheduleInspection_TST.CreateInspectionRequest();

        //Creating Inspection item
        T_MODEC_InspectionItem_TST.CreateInspectionItem(InspectionRequest.Id, 1);

        InspectionRequest.TW1_Inspection_Status__c         = 'Awaiting Date Confirmation';
        InspectionRequest.TW1_Inspection_Scheduled_Date__c = Datetime.now().addHours(3);
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
        StepDateConfirmation.TW1_Status__c = 'Closed';
        //StepDateConfirmation.TW1_Conclusion_Date__c = Datetime.Now();
        StepDateConfirmation.TW1_Inspection_Date_Confirmation__c = 'Cancel';
        update StepDateConfirmation;
        system.debug('StepDateConfirmation apos update >>' + StepDateConfirmation);

        Test.stopTest();
        TW1_Request__c inspection = RequestREP.getInspectionAndInspectionLines(InspectionRequest.Id);

        system.assertEquals('Reproved', inspection.TW1_Inspection_Status__c);
    }

    @isTest
    public static void CloseStepConfirmationDateRescheduled()
    {
        T_MODEC_Request_Rep RequestREP = new T_MODEC_Request_Rep();
        String              RecTypeStepDateConfirmation = Schema.SObjectType.TW1_Step__c.getRecordTypeInfosByDeveloperName().get('Approval_Step_Date_Confirmation').getRecordTypeId();
        //Creating inspection
        TW1_Request__c InspectionRequest = T_MODEC_ScheduleInspection_TST.CreateInspectionRequest();

        //Creating Inspection item
        T_MODEC_InspectionItem_TST.CreateInspectionItem(InspectionRequest.Id, 1);

        InspectionRequest.TW1_Inspection_Status__c         = 'Awaiting Date Confirmation';
        InspectionRequest.TW1_Inspection_Scheduled_Date__c = Datetime.now().addDays(3);
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
        StepDateConfirmation.TW1_Status__c = 'Closed';
        //StepDateConfirmation.TW1_Conclusion_Date__c = Datetime.Now();
        StepDateConfirmation.TW1_Inspection_Date_Confirmation__c = 'Reschedule';
        update StepDateConfirmation;
        system.debug('StepDateConfirmation apos update >>' + StepDateConfirmation);


        Test.stopTest();
        TW1_Request__c inspection = RequestREP.getInspectionAndInspectionLines(InspectionRequest.Id);

        system.assertEquals('Rescheduled', inspection.TW1_Inspection_Status__c);
    }

    @isTest
    public static void CloseStepConfirmationDateCalculateMinutes()
    {
        T_MODEC_Request_Rep RequestREP = new T_MODEC_Request_Rep();
        String              RecTypeStepDateConfirmation = Schema.SObjectType.TW1_Step__c.getRecordTypeInfosByDeveloperName().get('Approval_Step_Date_Confirmation').getRecordTypeId();
        //Creating inspection
        TW1_Request__c InspectionRequest = T_MODEC_ScheduleInspection_TST.CreateInspectionRequest();

        //Creating Inspection item
        T_MODEC_InspectionItem_TST.CreateInspectionItem(InspectionRequest.Id, 1);

        InspectionRequest.TW1_Inspection_Status__c         = 'Awaiting Date Confirmation';
        InspectionRequest.TW1_Inspection_Scheduled_Date__c = Datetime.now().addDays(1).addMinutes(-60);
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
        StepDateConfirmation.TW1_Status__c = 'Closed';
        //StepDateConfirmation.TW1_Conclusion_Date__c = Datetime.Now();
        StepDateConfirmation.TW1_Inspection_Date_Confirmation__c = 'Cancel';
        update StepDateConfirmation;
        system.debug('StepDateConfirmation apos update >>' + StepDateConfirmation);

        Test.stopTest();
        TW1_Request__c inspection = RequestREP.getInspectionAndInspectionLines(InspectionRequest.Id);

        system.assertEquals('Reproved', inspection.TW1_Inspection_Status__c);
    }

    @isTest
    public static void CloseStepConfirmationDateSUCESS()
    {
        T_MODEC_Request_Rep RequestREP = new T_MODEC_Request_Rep();
        String              RecTypeStepDateConfirmation = Schema.SObjectType.TW1_Step__c.getRecordTypeInfosByDeveloperName().get('Approval_Step_Date_Confirmation').getRecordTypeId();
        //Creating inspection
        TW1_Request__c InspectionRequest = T_MODEC_ScheduleInspection_TST.CreateInspectionRequest();

        //Creating Inspection item
        T_MODEC_InspectionItem_TST.CreateInspectionItem(InspectionRequest.Id, 1);

        InspectionRequest.TW1_Inspection_Status__c         = 'Awaiting Date Confirmation';
        InspectionRequest.TW1_Inspection_Scheduled_Date__c = Datetime.now().addDays(2);
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
        StepDateConfirmation.TW1_Status__c = 'Closed';
        //StepDateConfirmation.TW1_Conclusion_Date__c = Datetime.Now();
        StepDateConfirmation.TW1_Inspection_Date_Confirmation__c = 'Confirm';
        update StepDateConfirmation;
        system.debug('StepDateConfirmation apos update >>' + StepDateConfirmation);

        Test.stopTest();
        TW1_Request__c inspection = RequestREP.getInspectionAndInspectionLines(InspectionRequest.Id);

        system.assertEquals('Inspection Scheduled', inspection.TW1_Inspection_Status__c);
    }

    @isTest
    public static void ModifyStepAlreadyClosed()
    {
        T_MODEC_Request_Rep RequestREP = new T_MODEC_Request_Rep();
        String              RecTypeStepDateConfirmation = Schema.SObjectType.TW1_Step__c.getRecordTypeInfosByDeveloperName().get('Approval_Step_Date_Confirmation').getRecordTypeId();
        //Creating inspection
        TW1_Request__c InspectionRequest = T_MODEC_ScheduleInspection_TST.CreateInspectionRequest();

        //Creating Inspection item
        T_MODEC_InspectionItem_TST.CreateInspectionItem(InspectionRequest.Id, 1);

        InspectionRequest.TW1_Inspection_Status__c         = 'Awaiting Date Confirmation';
        InspectionRequest.TW1_Inspection_Scheduled_Date__c = Datetime.now().addDays(2);
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
        StepDateConfirmation.TW1_Status__c = 'Closed';
        //StepDateConfirmation.TW1_Conclusion_Date__c = Datetime.Now();
        StepDateConfirmation.TW1_Inspection_Date_Confirmation__c = 'Confirm';
        update StepDateConfirmation;
        system.debug('StepDateConfirmation apos update >>' + StepDateConfirmation);

        Test.stopTest();

        try{
            StepDateConfirmation.TW1_Status__c = 'Opened';
            update StepDateConfirmation;
        }
        catch (Exception e) {
            system.debug('Exception occurs :' + e.getMessage());
            String currentuserId   = UserInfo.getUserId();
            User   currentUserInfo = [select LanguageLocaleKey from User where Id = :UserInfo.getUserId()];
            if (currentUserInfo.LanguageLocaleKey == 'pt_BR')
            {
                system.assertEquals(true, e.getMessage().contains('Step está fechada mudanças não são permitidas'));
            }
            else
            {
                system.assertEquals(true, e.getMessage().contains('Step is closed changes are not allowed'));
            }
        }
    }
}