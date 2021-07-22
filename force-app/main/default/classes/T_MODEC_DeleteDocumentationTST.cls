/**
 * @File Name          : T_MODEC_DeleteDocumentationTST.cls
 * @Description        :
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 10-29-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    05/02/2020   Rafael Hadama     Initial Version
 **/
@Istest
public class T_MODEC_DeleteDocumentationTST {
    public static void MakeMetadataAndCustomSettings()
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
    }

    @isTest public static void DeleteDocumentation_TST()
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

        TW1_MODEC_Contract__c ContractMock = new TW1_MODEC_Contract__c();
        ContractMock.TW1_Vendor__c = contamock.Id;
        ContractMock.Name          = 'Contrato Mock';


        insert ContractMock;

        list<T_MODEC_CreateDoc_CTRL.recTypesDto> listRecTypes = T_MODEC_CreateDoc_CTRL.getlistRecTypesDocumentation(ContractMock.Id);

        string DocCreatedId = T_MODEC_CreateDoc_CTRL.createDocumentationAuxiliar(listRecTypes[0].value, ContractMock.Id);


        Datetime NowMinus21minutes = datetime.now().addMinutes(-21);
        system.debug('NowMinus21minutes >' + NowMinus21minutes);
        //The schedule job to delete documentations, queries Doc with TW1_DocumentationAux__c = true AND CreatedDate < Now(-20minutes)
        //Considering that, we are changing the created date of the documentation created.
        Test.setCreatedDate(DocCreatedId, NowMinus21minutes);


        Test.startTest();
        T_SDK_ScheaduleUtils.scheadule('T_MODEC_SCH_DeleteDocumentations', 1);
        Test.stopTest();

        list<TW1_Documentation__c> listDocs = [Select Id from TW1_Documentation__c where Id =:DocCreatedId];
        T_SDK_DebugLog.EscreverLog('Lista Docs' + listDocs.size());

        System.assertEquals(0, listDocs.size());
    }
}