/**
 * @File Name          : T_MODEC_StatusBoletim_TST.cls
 * @Description        : Classe de teste do serviço Rest /StatusBoletim/*
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 07-22-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    19/11/2019   Rafael Hadama     Initial Version
 **/
@istest
public class T_MODEC_StatusBoletim_TST {
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
        customControleTrigger.Request_Vendor_Vetting_RecId__c = Schema.SObjectType.TW1_Request__c.getRecordTypeInfosByDeveloperName().get('TW1_Vendor_Vetting').getRecordTypeId();
        insert customControleTrigger;
    }

    @Istest
    static void TestarPostStatusBoletim()
    {
        //Criar Account
        //Criar Request do tipo BM
        //Preencher com um numero de BM
        //Criar uma list<Itemrequest> REQUEST
        //Validar se o status do BM foi atualizado

        //Query no recordtype e criação de conta


        MakeMetadataAndCustomSettings();
        RecordType accRec_VendorHomologated = [Select id from Recordtype where developername = 'TW1_Vendor_Homologated'];
        Account    contamock = new Account();

        contamock.recordtypeId        = accRec_VendorHomologated.id;
        contamock.name                = 'Conta Status Boletim';
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
        RecordType           requestRec_BM = [Select id from Recordtype where developername = 'TW1_BM'];
        list<TW1_Request__c> listBMs       = new list<TW1_Request__c>();


        for (integer i = 0; i <= 150; i++)
        {
            TW1_Request__c BMmock1 = new TW1_Request__c();
            BMmock1.recordTypeId  = requestRec_BM.id;
            BMmock1.TW1_Vendor__c = contamock.id;
            BMmock1.BM_Status__c  = 'Aguardando';
            BMmock1.TW1_BM_Reference_Number_in_SAP_MODEC__c = String.valueOf(i);
            BMmock1.TW1_Modec_Requester_Email__c            = 'emailRequestermock@mock.com';
            listBMs.add(BMmock1);
        }
        TriggerFactory.validateRequesterEmail = false;
        TriggerFactory.stopRequestTrigger     = false;
        //Inserindo lista de Boletins
        insert listBMs;

        list<T_MODEC_StatusBoletim_WS.Itemrequest> Listrequest = new list<T_MODEC_StatusBoletim_WS.Itemrequest>();
        for (TW1_Request__c BM:listBMs)
        {
            T_MODEC_StatusBoletim_WS.Itemrequest itemReq = new T_MODEC_StatusBoletim_WS.Itemrequest();
            itemReq.ENTRYSHEET = BM.TW1_BM_Reference_Number_in_SAP_MODEC__c;
            itemReq.STATUS     = '1';
            itemReq.MESSAGE    = '';
            Listrequest.add(itemReq);
        }

        //Adicionado um ItemRequest com um Numero de referencia inexistente na base
        T_MODEC_StatusBoletim_WS.Itemrequest itemReqInexistente = new T_MODEC_StatusBoletim_WS.Itemrequest();
        itemReqInexistente.ENTRYSHEET = '8885552221';
        itemReqInexistente.STATUS     = '1';
        itemReqInexistente.MESSAGE    = '';
        Listrequest.add(itemReqInexistente);


        T_MODEC_StatusBoletim_WS.StatusRequest REQUEST = new T_MODEC_StatusBoletim_WS.StatusRequest();
        REQUEST.item = Listrequest;

        Test.startTest();
        //Chamando método do serviço rest
        T_MODEC_StatusBoletim_WS.Response response = T_MODEC_StatusBoletim_WS.receberStatusBoletins(REQUEST);
        T_SDK_DebugLog.EscreverLog('Response Status BM>>' + response);
        //for(T_MODEC_StatusBoletim_WS.ItemResponse iResponse:response.RESPONSE){
        //  system.assertEquals('x', iResponse.PROCESSADO);
        //}
        Test.stopTest();
        //Validando se os BMs tiveram status atualizados
        list<TW1_Request__c> listaBoletins = [Select id, BM_Status__c from TW1_Request__c where TW1_Vendor__c =:contamock.id];
        for (TW1_Request__c req:listaBoletins)
        {
            system.assertEquals('Aceita', req.BM_Status__c);
        }
    }
}