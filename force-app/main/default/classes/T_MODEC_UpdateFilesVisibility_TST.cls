/**
 * @description       : Test class for - T_MODEC_BAT_UpdateFilesVisibility and T_MODEC_SCH_UpdateFilesVisibility.
 * @author            : Rafael Hadama
 * @group             :
 * @last modified on  : 07-17-2020
 * @last modified by  : Rafael Hadama
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   07-17-2020   Rafael Hadama   Initial Version
 * 1.1   27-10-2020   Gabriel Uchoa   Novo metodo ScheduleJobTST2
 **/
@Istest
public class T_MODEC_UpdateFilesVisibility_TST {
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

    //T_MODEC_ScheduleInspection_TST


    @isTest
    public static void BatchUpdateFilesVisibilityTst()
    {
        TW1_Request__c Inspection = T_MODEC_ScheduleInspection_TST.CreateInspectionRequest();

        system.debug('Inspection created status' + Inspection.TW1_Status__c);
        TW1_Documentation__c InspectionDocumentation = new TW1_Documentation__c();

        InspectionDocumentation.RecordTypeId   = Schema.SObjectType.TW1_Documentation__c.getRecordTypeInfosByName().get('Inspection Documentation').getRecordTypeId();
        InspectionDocumentation.TW1_Request__c = Inspection.Id;

        insert InspectionDocumentation;

        ContentVersion contentVersion = new ContentVersion(Title = 'Penguins', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true);

        insert contentVersion;
        system.debug('contentVersion :' + contentVersion);


        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where Title = 'Penguins'];

        system.debug('list documents :' + documents);

        //create ContentDocumentLink  record
        ContentDocumentLink cdl = new ContentDocumentLink();

        cdl.LinkedEntityId    = InspectionDocumentation.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType         = 'V';
        cdl.visibility        = 'InternalUsers';
        insert cdl;
        system.debug('cdl :' + cdl);
        Test.startTest();
        Id batchUpdateFiles = Database.executeBatch(new T_MODEC_BAT_UpdateFilesVisibility(), 1);
        system.debug('Batch process id:' + batchUpdateFiles);
        Test.stopTest();

        ContentDocumentLink cdlUpdated = [Select Id, visibility, ContentDocumentId, LinkedEntityId from ContentDocumentLink where LinkedEntityId =:InspectionDocumentation.Id AND ContentDocumentId =:documents[0].Id];
        system.debug('cdlUpdated :' + cdlUpdated);
        system.assertEquals('AllUsers', cdlUpdated.visibility);
    }

    /*@isTest public static void ScheduleJobTST()
    {
        Test.startTest();
        T_SDK_ScheaduleUtils.scheadule('T_MODEC_SCH_UpdateFilesVisibility', 1);
        Test.stopTest();
    }*/
    
    @isTest public static void ScheduleJobTST2(){
        Test.startTest();
        T_ThreeMinutesSchedule.startJob();
        T_ThreeMinutesSchedule.deleteJob();
        Test.stopTest();
    }
}