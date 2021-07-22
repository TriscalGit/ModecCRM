/**
 * @File Name          : T_MODEC_CloneInspection_TST.cls
 * @Description        :
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 07-16-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    02/07/2020   Rafael Hadama     Initial Version
 **/
@istest
public class T_MODEC_CloneInspection_TST {
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

    @isTest
    public static void CloneInspectionTST()
    {
        T_MODEC_Request_Rep RequestREP = new T_MODEC_Request_Rep();

        Test.startTest();
        TW1_Request__c Inspection = T_MODEC_InspectionItem_TST.CreateInspectionRequest();
        system.debug('Inspection >' + Inspection);
        list<TW1_Inspection_Item__c> ListInspecItem = T_MODEC_InspectionItem_TST.CreateInspectionItem(Inspection.Id, 3);
        system.debug('ListInspecItem >' + ListInspecItem);

        Inspection.TW1_Inspection_Status__c = 'Inspection Scheduled';
        update Inspection;

        for (TW1_Inspection_Item__c inspectItem :ListInspecItem)
        {
            inspectItem.TW1_Status__c = 'Rejected';
        }
        update ListInspecItem;


        string retornoDto = T_MODEC_CloneInspection_Ctrl.CloneInspectionApex(Inspection.Id);

        system.debug('retornoDto >>>' + retornoDto);

        T_MODEC_CloneInspection_Ctrl.CloneResponseDto retorno = (T_MODEC_CloneInspection_Ctrl.CloneResponseDto)JSON.deserialize(retornoDto, T_MODEC_CloneInspection_Ctrl.CloneResponseDto.class);

        system.debug('retorno >>>' + retorno);

        system.assertEquals('Sucesso', retorno.Status);
    }
}