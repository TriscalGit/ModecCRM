/**
 * @File Name          : T_MODEC_ScheduleInspection_TST.cls
 * @Description        :
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 07-22-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    29/06/2020   Rafael Hadama     Initial Version
 **/
@istest
public class T_MODEC_ScheduleInspection_TST {
    @TestSetup
    public static void criarCustomSettings() //Obs.: Apenas Triggers que contêm este método serão liberadas
    {
        Controle_de_Triggers__c ctrlTriggers = new Controle_de_Triggers__c();

        ctrlTriggers.Trigger_Request__c         = true;      // ***** LEMBRAR ***** (Lembrar de mudar "Trigger_Request__c" ao reutilizar código)
        ctrlTriggers.Trigger_Account__c         = true;
        ctrlTriggers.Trigger_BMItem__c          = true;
        ctrlTriggers.Trigger_Inspection_Item__c = true;
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

    public static TW1_Request__c CreateInspectionRequest()
    {
        TW1_Facility__c Unit = new TW1_Facility__c();

        Unit.TW1_Type__c = 'Office';
        Unit.Name        = 'Unit Mock';
        insert Unit;

        TW1_Request__c Inspection = new TW1_Request__c();

        Inspection.RecordTypeId                           = Schema.SObjectType.TW1_Request__c.getRecordTypeInfosByDeveloperName().get('Inspection').getRecordTypeId();
        Inspection.TW1_Purchase_Order__c                  = 'Purchase';
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
        Inspection.TW1_Status__c                          = 'Open';
        insert Inspection;

        return Inspection;
    }

    /**
     * @description test method to cover the T_MODEC_ScheduleInspection_Ctrl class
     * @author Rafael Hadama | 29/06/2020
     * @return void
     **/
    @isTest
    public static void ScheduleWithRequestInController()
    {
        Test.startTest();
        T_MODEC_ScheduleInspection_App ScheduleApp = new T_MODEC_ScheduleInspection_App();
        TW1_Request__c                 Inspection  = CreateInspectionRequest();

        T_MODEC_InspectionItem_TST.CreateInspectionItem(Inspection.Id, 1);

        Inspection.TW1_Inspection_Status__c = 'Inspection Scheduled';
        update Inspection;

        system.debug('Inspection >' + Inspection);
        T_MODEC_ScheduleInspection_Ctrl.InspectionDatesDto scheduletestDto = new T_MODEC_ScheduleInspection_Ctrl.InspectionDatesDto();

        scheduletestDto.InspectionDate1         = Date.today().addDays(1);
        scheduletestDto.InspectionDate2         = Date.today().addDays(2);
        scheduletestDto.InspectionDate3         = Date.today().addDays(4);
        scheduletestDto.EmergencyInspectionDate = null;
        scheduletestDto.InspectionNote          = 'Inspection Note Mock';
        scheduletestDto.InspectionType          = 'normal';
        scheduletestDto.RequestId = Inspection.Id;
        string strRequest = JSON.serialize(scheduletestDto);
        Test.stopTest();
        string controllerresponse = T_MODEC_ScheduleInspection_Ctrl.ScheduleInspection(strRequest);
        system.debug('controllerresponse' + controllerresponse);
        T_MODEC_ScheduleInspection_Ctrl.InspectionResponseDto request = (T_MODEC_ScheduleInspection_Ctrl.InspectionResponseDto)JSON.deserialize(controllerresponse, T_MODEC_ScheduleInspection_Ctrl.InspectionResponseDto.class);
        system.debug('request' + request);

        system.assertEquals('Erro', request.Status);
        //system.assertEquals(true, InspectionResponse.MessageList.get(0).contains('is invalid'));
    }

    /**
     * @description Test method to validate the inspection status of the Request
     * @author Rafael Hadama | 29/06/2020
     * @return void
     **/
    @isTest
    public static void ScheduleWithRequestStatusInvalid()
    {
        Test.startTest();
        T_MODEC_ScheduleInspection_App ScheduleApp = new T_MODEC_ScheduleInspection_App();
        TW1_Request__c                 Inspection  = CreateInspectionRequest();
        T_MODEC_InspectionItem_TST.CreateInspectionItem(Inspection.Id, 1);
        Inspection.TW1_Inspection_Status__c = 'Inspection Scheduled';
        update Inspection;

        system.debug('Inspection >' + Inspection);
        T_MODEC_ScheduleInspection_Ctrl.InspectionDatesDto scheduletestDto = new T_MODEC_ScheduleInspection_Ctrl.InspectionDatesDto();

        scheduletestDto.InspectionDate1         = Date.today().addDays(1);
        scheduletestDto.InspectionDate2         = Date.today().addDays(2);
        scheduletestDto.InspectionDate3         = Date.today().addDays(4);
        scheduletestDto.EmergencyInspectionDate = null;
        scheduletestDto.InspectionNote          = 'Inspection Note Mock';
        scheduletestDto.InspectionType          = 'normal';
        scheduletestDto.RequestId = Inspection.Id;

        Test.stopTest();
        T_MODEC_ScheduleInspection_Ctrl.InspectionResponseDto InspectionResponse = ScheduleApp.ValidateScheduledInspection(scheduletestDto, true);
        system.debug('InspectionResponse' + InspectionResponse);

        system.assertEquals('Erro', InspectionResponse.Status);
        //system.assertEquals(true, InspectionResponse.MessageList.get(0).contains('is invalid'));
    }

    /**
     * @description test method to validate Dates in the past
     * @author Rafael Hadama | 29/06/2020
     * @return void
     **/
    @isTest
    public static void ScheduleWithDatesInThePast()
    {
        T_MODEC_ScheduleInspection_App ScheduleApp = new T_MODEC_ScheduleInspection_App();
        TW1_Request__c                 Inspection  = CreateInspectionRequest();

        system.debug('Inspection >' + Inspection);
        T_MODEC_ScheduleInspection_Ctrl.InspectionDatesDto scheduletestDto = new T_MODEC_ScheduleInspection_Ctrl.InspectionDatesDto();

        scheduletestDto.InspectionDate1         = Date.today().addDays(-1);
        scheduletestDto.InspectionDate2         = Date.today().addDays(2);
        scheduletestDto.InspectionDate3         = Date.today().addDays(4);
        scheduletestDto.EmergencyInspectionDate = null;
        scheduletestDto.InspectionNote          = 'Inspection Note Mock';
        scheduletestDto.InspectionType          = 'normal';
        scheduletestDto.RequestId = Inspection.Id;


        T_MODEC_ScheduleInspection_Ctrl.InspectionResponseDto InspectionResponse = ScheduleApp.ValidateScheduledInspection(scheduletestDto, true);
        system.debug('InspectionResponse' + InspectionResponse);

        system.assertEquals('Erro', InspectionResponse.Status);
        //system.assertEquals(true, InspectionResponse.MessageList.get(0).contains('is invalid'));
    }

    @isTest
    public static void ScheduleWithDuplicateDates()
    {
        T_MODEC_ScheduleInspection_App ScheduleApp = new T_MODEC_ScheduleInspection_App();
        TW1_Request__c                 Inspection  = CreateInspectionRequest();

        system.debug('Inspection >' + Inspection);
        T_MODEC_ScheduleInspection_Ctrl.InspectionDatesDto scheduletestDto = new T_MODEC_ScheduleInspection_Ctrl.InspectionDatesDto();

        scheduletestDto.InspectionDate1         = Date.today().addDays(2);
        scheduletestDto.InspectionDate2         = Date.today().addDays(2);
        scheduletestDto.InspectionDate3         = Date.today().addDays(4);
        scheduletestDto.EmergencyInspectionDate = null;
        scheduletestDto.InspectionNote          = 'Inspection Note Mock';
        scheduletestDto.InspectionType          = 'normal';
        scheduletestDto.RequestId = Inspection.Id;


        T_MODEC_ScheduleInspection_Ctrl.InspectionResponseDto InspectionResponse = ScheduleApp.ValidateScheduledInspection(scheduletestDto, true);
        system.debug('InspectionResponse' + InspectionResponse);

        system.assertEquals('Erro', InspectionResponse.Status);
        //system.assertEquals(true, InspectionResponse.MessageList.get(0).contains('There are duplicate dates'));
    }

    @isTest
    public static void ScheduleWithDatesinWrongOrder()
    {
        T_MODEC_ScheduleInspection_App ScheduleApp = new T_MODEC_ScheduleInspection_App();
        TW1_Request__c                 Inspection  = CreateInspectionRequest();

        system.debug('Inspection >' + Inspection);
        T_MODEC_ScheduleInspection_Ctrl.InspectionDatesDto scheduletestDto = new T_MODEC_ScheduleInspection_Ctrl.InspectionDatesDto();

        scheduletestDto.InspectionDate1         = Date.today().addDays(1);
        scheduletestDto.InspectionDate2         = Date.today().addDays(4);
        scheduletestDto.InspectionDate3         = Date.today().addDays(2);
        scheduletestDto.EmergencyInspectionDate = null;
        scheduletestDto.InspectionNote          = 'Inspection Note Mock';
        scheduletestDto.InspectionType          = 'normal';
        scheduletestDto.RequestId = Inspection.Id;


        T_MODEC_ScheduleInspection_Ctrl.InspectionResponseDto InspectionResponse = ScheduleApp.ValidateScheduledInspection(scheduletestDto, true);
        system.debug('InspectionResponse' + InspectionResponse);

        system.assertEquals('Erro', InspectionResponse.Status);
        //system.assertEquals(true, InspectionResponse.MessageList.get(0).contains('The order of the dates should be Date 1 > Date 2 > Date 3'));
    }

    @isTest
    public static void ScheduleWithNotWorkingDays()
    {
        T_MODEC_ScheduleInspection_App ScheduleApp = new T_MODEC_ScheduleInspection_App();
        TW1_Request__c                 Inspection  = CreateInspectionRequest();

        system.debug('Inspection >' + Inspection);
        T_MODEC_ScheduleInspection_Ctrl.InspectionDatesDto scheduletestDto = new T_MODEC_ScheduleInspection_Ctrl.InspectionDatesDto();

        boolean dateIsNotWeekend = false;
        Date    DateAux          = Date.today().addDays(1);
        while (!dateIsNotWeekend)
        {
            dateIsNotWeekend = ScheduleApp.CheckIfDateIsWeekend(DateAux);

            if (!dateIsNotWeekend)
            {
                DateAux = DateAux.addDays(1);
            }
        }
        system.debug('DateAux :' + DateAux);

        scheduletestDto.InspectionDate1         = DateAux;
        scheduletestDto.InspectionDate2         = DateAux.addDays(3);
        scheduletestDto.InspectionDate3         = DateAux.addDays(4);
        scheduletestDto.EmergencyInspectionDate = null;
        scheduletestDto.InspectionNote          = 'Inspection Note Mock';
        scheduletestDto.InspectionType          = 'normal';
        scheduletestDto.RequestId = Inspection.Id;


        T_MODEC_ScheduleInspection_Ctrl.InspectionResponseDto InspectionResponse = ScheduleApp.ValidateScheduledInspection(scheduletestDto, true);
        system.debug('InspectionResponse' + InspectionResponse);

        system.assertEquals('Erro', InspectionResponse.Status);
        //system.assertEquals(true, InspectionResponse.MessageList.get(0).contains('The Date Option 1 is a'));
    }

    @isTest
    public static void ScheduleWithDatesOutOfRange()
    {
        T_MODEC_ScheduleInspection_App ScheduleApp = new T_MODEC_ScheduleInspection_App();
        TW1_Request__c                 Inspection  = CreateInspectionRequest();

        system.debug('Inspection >' + Inspection);
        T_MODEC_ScheduleInspection_Ctrl.InspectionDatesDto scheduletestDto = new T_MODEC_ScheduleInspection_Ctrl.InspectionDatesDto();

        boolean dateIsNotWeekend = false;
        integer count            = 0;
        Date    DateAux          = Date.today();
        while (!dateIsNotWeekend)
        {
            dateIsNotWeekend = ScheduleApp.CheckIfDateIsWeekend(DateAux);

            if (!dateIsNotWeekend)
            {
                DateAux = DateAux.addDays(1);
                count++;
            }
        }
        system.debug('DateAux :' + DateAux);

        scheduletestDto.InspectionDate1         = DateAux.addDays(-count);
        scheduletestDto.InspectionDate2         = DateAux.addDays(3);
        scheduletestDto.InspectionDate3         = DateAux.addDays(4);
        scheduletestDto.EmergencyInspectionDate = null;
        scheduletestDto.InspectionNote          = 'Inspection Note Mock';
        scheduletestDto.InspectionType          = 'normal';
        scheduletestDto.RequestId = Inspection.Id;


        T_MODEC_ScheduleInspection_Ctrl.InspectionResponseDto InspectionResponse = ScheduleApp.ValidateScheduledInspection(scheduletestDto, true);
        system.debug('InspectionResponse' + InspectionResponse);

        system.assertEquals('Erro', InspectionResponse.Status);
        //system.assertEquals(true, InspectionResponse.MessageList.get(0).contains('is earlier then the Minimum schedule date'));
    }

    @isTest
    public static void ScheduleWithSucessEmergencial()
    {
        T_MODEC_ScheduleInspection_App ScheduleApp = new T_MODEC_ScheduleInspection_App();
        TW1_Request__c                 Inspection  = CreateInspectionRequest();

        system.debug('Inspection >' + Inspection);

        //Criando TW1_Email_List__c para passar da trigger.
        TW1_Email_List__c emailList = new TW1_Email_List__c();
        emailList.TW1_Email__c  = 'teste@teste.com';
        emailList.TW1_Status__c = 'Ativo';
        emailList.RecordTypeId  = Schema.SObjectType.TW1_Email_List__c.getRecordTypeInfosByDeveloperName().get('TW1_Inspection_Email').getRecordTypeId();
        insert emailList;

        T_MODEC_ScheduleInspection_Ctrl.InspectionDatesDto scheduletestDto = new T_MODEC_ScheduleInspection_Ctrl.InspectionDatesDto();


        scheduletestDto.InspectionDate1         = null;
        scheduletestDto.InspectionDate2         = null;
        scheduletestDto.InspectionDate3         = null;
        scheduletestDto.EmergencyInspectionDate = Date.today().addDays(2);
        scheduletestDto.InspectionNote          = 'Inspection Note Mock';
        scheduletestDto.InspectionType          = 'emergencial';
        scheduletestDto.RequestId      = Inspection.Id;
        scheduletestDto.EmergencyEmail = 'teste@teste.com';


        T_MODEC_ScheduleInspection_Ctrl.InspectionResponseDto InspectionResponse = ScheduleApp.ValidateScheduledInspection(scheduletestDto, true);
        system.debug('InspectionResponse' + InspectionResponse);

        system.assertEquals('Sucesso', InspectionResponse.Status);
    }

    @isTest
    public static void ScheduleWithErrorEmergencial()
    {
        T_MODEC_ScheduleInspection_App ScheduleApp = new T_MODEC_ScheduleInspection_App();
        TW1_Request__c                 Inspection  = CreateInspectionRequest();

        system.debug('Inspection >' + Inspection);

        //Criando TW1_Email_List__c para passar da trigger.
        TW1_Email_List__c emailList = new TW1_Email_List__c();
        emailList.TW1_Email__c  = 'teste2@teste.com';
        emailList.TW1_Status__c = 'Ativo';
        emailList.RecordTypeId  = Schema.SObjectType.TW1_Email_List__c.getRecordTypeInfosByDeveloperName().get('TW1_Inspection_Email').getRecordTypeId();
        insert emailList;

        T_MODEC_ScheduleInspection_Ctrl.InspectionDatesDto scheduletestDto = new T_MODEC_ScheduleInspection_Ctrl.InspectionDatesDto();


        scheduletestDto.InspectionDate1         = null;
        scheduletestDto.InspectionDate2         = null;
        scheduletestDto.InspectionDate3         = null;
        scheduletestDto.EmergencyInspectionDate = Date.today().addDays(2);
        scheduletestDto.InspectionNote          = 'Inspection Note Mock';
        scheduletestDto.InspectionType          = 'emergencial';
        scheduletestDto.RequestId      = Inspection.Id;
        scheduletestDto.EmergencyEmail = 'teste@teste.com';


        T_MODEC_ScheduleInspection_Ctrl.InspectionResponseDto InspectionResponse = ScheduleApp.ValidateScheduledInspection(scheduletestDto, true);
        system.debug('InspectionResponse' + InspectionResponse);

        system.assertEquals('Erro', InspectionResponse.Status);
    }

    @isTest
    public static void ScheduleWithDatesSucess()
    {
        T_MODEC_ScheduleInspection_App ScheduleApp = new T_MODEC_ScheduleInspection_App();
        TW1_Request__c                 Inspection  = CreateInspectionRequest();

        system.debug('Inspection >' + Inspection);
        T_MODEC_ScheduleInspection_Ctrl.InspectionDatesDto scheduletestDto = new T_MODEC_ScheduleInspection_Ctrl.InspectionDatesDto();

        boolean dateIsNotWeekend = false;
        integer count            = 0;
        Date    DateAux          = Date.today();
        while (!dateIsNotWeekend)
        {
            dateIsNotWeekend = ScheduleApp.CheckIfDateIsWeekend(DateAux);

            if (!dateIsNotWeekend)
            {
                DateAux = DateAux.addDays(1);
                count++;
            }
        }
        system.debug('DateAux :' + DateAux);

        scheduletestDto.InspectionDate1         = DateAux.addDays(4);
        scheduletestDto.InspectionDate2         = DateAux.addDays(11);
        scheduletestDto.InspectionDate3         = DateAux.addDays(18);
        scheduletestDto.EmergencyInspectionDate = null;
        scheduletestDto.InspectionNote          = 'Inspection Note Mock';
        scheduletestDto.InspectionType          = 'normal';
        scheduletestDto.RequestId = Inspection.Id;


        T_MODEC_ScheduleInspection_Ctrl.InspectionResponseDto InspectionResponse = ScheduleApp.ValidateScheduledInspection(scheduletestDto, true);
        system.debug('InspectionResponse' + InspectionResponse);

        //system.assertEquals('Sucesso', InspectionResponse.Status);
    }

    @isTest
    public static void ValidateSendInspectionAction()
    {
        T_MODEC_ScheduleInspection_App ScheduleApp = new T_MODEC_ScheduleInspection_App();
        TW1_Request__c                 Inspection  = CreateInspectionRequest();

        T_MODEC_InspectionItem_TST.CreateInspectionItem(Inspection.Id, 1);

        try{
            Inspection.TW1_Inspection_Sent__c          = true;
            Inspection.TW1_Emergency_Date__c           = null;
            Inspection.TW1_Inspection_Date_Option_1__c = Date.today().addDays(-1);
            Inspection.TW1_Inspection_Date_Option_2__c = Date.today().addDays(3);
            Inspection.TW1_Inspection_Date_Option_3__c = Date.today().addDays(4);
            Inspection.TW1_Note__c = 'Note mock';
            update Inspection;
            system.debug('Inspection >' + Inspection);
        }
        catch (Exception e) {
            string mensagem        = e.getMessage();
            String currentuserId   = UserInfo.getUserId();
            User   currentUserInfo = [select LanguageLocaleKey from User where Id = :UserInfo.getUserId()];
            if (currentUserInfo.LanguageLocaleKey == 'pt_BR')
            {
                system.assert (mensagem.contains('por favor agende novamente'));
            }
            else
            {
                system.assert (mensagem.contains('please schedule inspection again'));
            }
        }
    }

    /**
     * @description Validating the method in the request app validateCancelInspectionAction
     * TW1_Inspection_Scheduled_Date__c is more than 24h from now().
     * @author Rafael Hadama | 07-16-2020
     **/
    @isTest
    public static void ValidateCancelInspectionActionCanceled()
    {
        T_MODEC_Request_Rep            RequestREP  = new T_MODEC_Request_Rep();
        T_MODEC_ScheduleInspection_App ScheduleApp = new T_MODEC_ScheduleInspection_App();
        TW1_Request__c                 Inspection  = CreateInspectionRequest();

        T_MODEC_InspectionItem_TST.CreateInspectionItem(Inspection.Id, 1);


        Inspection.TW1_Cancel_Inspection__c   = true;
        Inspection.TW1_Inspection_Status__c   = 'Canceled';
        Inspection.TW1_Instant_Cancel_Date__c = Datetime.now();
        Inspection.TW1_Status__c      = 'Canceled';
        Inspection.TW1_Cancel_Note__c = '<html><body><div style="color: red;"><b>In case you have to cancel this inspection, you can clone it and restart your request anytime pressing the Clone button.</b></div></body></html>';
        Inspection.TW1_Inspection_Scheduled_Date__c = Datetime.now().addDays(2);
        update Inspection;
        system.debug('Inspection >' + Inspection);

        TW1_Request__c InspectionAssert = RequestREP.getInspectionAndInspectionLines(Inspection.Id);

        system.assertEquals('Canceled', InspectionAssert.TW1_Inspection_Status__c);
    }

    /**
     * @description Validating the method in the request app validateCancelInspectionAction
     * TW1_Inspection_Scheduled_Date__c is too close to Now()
     * @author Rafael Hadama | 07-16-2020
     **/
    @isTest
    public static void ValidateCancelInspectionActionReproved()
    {
        T_MODEC_Request_Rep            RequestREP  = new T_MODEC_Request_Rep();
        T_MODEC_ScheduleInspection_App ScheduleApp = new T_MODEC_ScheduleInspection_App();
        TW1_Request__c                 Inspection  = CreateInspectionRequest();

        T_MODEC_InspectionItem_TST.CreateInspectionItem(Inspection.Id, 1);


        Inspection.TW1_Cancel_Inspection__c   = true;
        Inspection.TW1_Inspection_Status__c   = 'Canceled';
        Inspection.TW1_Instant_Cancel_Date__c = Datetime.now();
        Inspection.TW1_Status__c      = 'Canceled';
        Inspection.TW1_Cancel_Note__c = '<html><body><div style="color: red;"><b>In case you have to cancel this inspection, you can clone it and restart your request anytime pressing the Clone button.</b></div></body></html>';
        Inspection.TW1_Inspection_Scheduled_Date__c = Datetime.now();
        update Inspection;
        system.debug('Inspection >' + Inspection);

        TW1_Request__c InspectionAssert = RequestREP.getInspectionAndInspectionLines(Inspection.Id);

        system.assertEquals('Reproved', InspectionAssert.TW1_Inspection_Status__c);
    }

    /**
     * @description Validating the method in the request app validateCancelInspectionAction
     * TW1_Inspection_Scheduled_Date__c = null
     * @author Rafael Hadama | 07-16-2020
     **/
    @isTest
    public static void ValidateCancelInspectionDateIsNull()
    {
        T_MODEC_Request_Rep            RequestREP  = new T_MODEC_Request_Rep();
        T_MODEC_ScheduleInspection_App ScheduleApp = new T_MODEC_ScheduleInspection_App();
        TW1_Request__c                 Inspection  = CreateInspectionRequest();

        T_MODEC_InspectionItem_TST.CreateInspectionItem(Inspection.Id, 1);


        Inspection.TW1_Cancel_Inspection__c   = true;
        Inspection.TW1_Inspection_Status__c   = 'Canceled';
        Inspection.TW1_Instant_Cancel_Date__c = Datetime.now();
        Inspection.TW1_Status__c      = 'Canceled';
        Inspection.TW1_Cancel_Note__c = '<html><body><div style="color: red;"><b>In case you have to cancel this inspection, you can clone it and restart your request anytime pressing the Clone button.</b></div></body></html>';
        Inspection.TW1_Inspection_Scheduled_Date__c = null;
        update Inspection;
        system.debug('Inspection >' + Inspection);

        TW1_Request__c InspectionAssert = RequestREP.getInspectionAndInspectionLines(Inspection.Id);

        system.assertEquals('Canceled', InspectionAssert.TW1_Inspection_Status__c);
    }
}