/**
 * @File Name          : T_MODEC_EnvioBoletim_TST.cls
 * @Description        : Classe de teste
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 07-22-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    19/11/2019   Rafael Hadama     Initial Version
 **/
@Istest
public class T_MODEC_EnvioBoletim_TST {
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
        insert customControleTrigger;
    }

    @istest
    static void enviarBoletimSAP()
    {
        Test.setMock(HttpCalloutMock.class, new T_MODEC_MockResponseGenerator());
        //Calling a setup method to create Metadata and custom settings.
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

        list<BM_Item__c> BMItemlist = new list<BM_Item__c>();
        for (integer i = 0; i < 40; i++)
        {
            BM_Item__c linhaBm = new BM_Item__c();
            linhaBm.Request__c          = BMmock1.id;
            linhaBm.TW1_Service_Line__c = '0000000010';
            linhaBm.T_Quantity__c       = 1;
            linhaBm.TW1_Gross_Value__c  = 100;
            BMItemlist.add(linhaBm);
        }
        insert BMItemlist;

        T_MODEC_EnvioBoletim_App envioBoletimApp = new T_MODEC_EnvioBoletim_App();
        envioBoletimApp.enviarBoletimMedicao(BMmock1.id);

        Test.stopTest();
        TW1_Request__c BMmockAfterSend = [Select id, TW1_BM_Reference_Number_in_SAP_MODEC__c from TW1_Request__c where Id =:BMmock1.Id];
        T_SDK_DebugLog.EscreverLog('BMmockAfterSend.TW1_BM_Reference_Number_in_SAP_MODEC__c  >' + BMmockAfterSend.TW1_BM_Reference_Number_in_SAP_MODEC__c);
        system.debug('Teste system debug');
        system.assertEquals(true, BMmockAfterSend.TW1_BM_Reference_Number_in_SAP_MODEC__c == '1000001319');
    }
}