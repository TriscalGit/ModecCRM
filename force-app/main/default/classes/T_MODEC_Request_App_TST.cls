/**
 * @File Name          : T_MODEC_Request_App_TST.cls
 * @Description        :
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 07-22-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    06/11/2019   Mario Oliveira     Initial Version
 **/
@isTest
public with sharing class T_MODEC_Request_App_TST {
    @isTest
    public static void criarCategoriasdaHomologacao_TST()
    {
        T_MODEC_Request_App_TST.criarCustomSettings();

        TW1_Request__c requestTest1 = criarRegistroMock();  //Trigger 1

        List<TW1_Requested_Category__c> listacategorias = [select id from TW1_Requested_Category__c where TW1_Request__c =: requestTest1.id];
        integer qtd = listacategorias.size();

        System.assertEquals(1, qtd, 'Request Category criada.');  //Trigger 1
    }

    @isTest
    public static void homologarCategoriasTST()
    {
        T_MODEC_Request_App_TST.criarCustomSettings();

        TW1_Request__c requestTest2 = criarRegistroMockT2();  //Trigger 2

        //Realizra query no objeto TW1_Vendor_Category__c, buscando pelo relacionamento com a conta relacionado ao TW1_Request__c

        TW1_Vendor_Category__c appCat = [SELECT Id, TW1_Status__c, TW1_VEndor__c, TW1_Expiration_Date__c FROM TW1_Vendor_Category__c WHERE TW1_VEndor__c =: requestTest2.TW1_Vendor__c];

        System.assertEquals('Homologated', appCat.TW1_Status__c, 'Request Category homologada.');                     //Trigger 2
        System.assertEquals(appCat.TW1_Expiration_Date__c, requestTest2.TW1_Shelf_Life_Vetting_Date__c, 'Expirada!'); //Trigger 2
    }

    /*@isTest
     * public static void validarSupplierEmailTST() { //Não há necessidade de usar este método
     *
     *  TW1_Request__c requestTest3 = criarRegistroMockT3();  //Trigger 3
     *
     *  System.assertEquals('teste@teste.com', request.TW1_Modec_Requester_Email__c, 'Request Category homologada.');  //Trigger 3
     *
     * }*/
    public static void criarCustomSettings() //Obs.: Apenas Triggers que contêm este método serão liberadas
    {
        Controle_de_Triggers__c ctrlTriggers = new Controle_de_Triggers__c();

        ctrlTriggers.Trigger_Request__c = true; // ***** LEMBRAR ***** (Lembrar de mudar "Trigger_Request__c" ao reutilizar código)
        ctrlTriggers.Trigger_Account__c = true;
        ctrlTriggers.Trigger_BMItem__c  = true;
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
     * @description Metodo que gera registros mockados (criarCategoriasdaHomologacao - Trigger 1)
     * @author Mario Oliveira | 06/11/2019
     * @return TW1_Request__c
     **/
    public static TW1_Request__c criarRegistroMock()
    {
        /*
         *  Passo 1 - Criar uma nova Account:
         */
        RecordType accRec_VendorHomologated = [Select id from Recordtype where developername = 'TW1_Vendor_Homologated'];
        Account    conta = new Account();

        conta.Name                = 'Teste da Silva';
        conta.TW1_CPF__c          = '57034551030';
        conta.TW1_Contact_Name__c = 'Contato Mock';
        conta.RecordTypeId        = accRec_VendorHomologated.Id;
        Insert conta;

        /*
         *  Passo 2 - Criar uma nova TW1_Category__c:
         */
        TW1_Category__c categ = new TW1_Category__c();
        RecordType      cat   = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'TW1_Material'];
        categ.RecordTypeId    = cat.Id;
        categ.TW1_Category__c = 'Nome Categoria';
        insert categ;

        /*
         *  Passo 3 - Criar uma nova TW1_Vendor_Category__c:
         */
        TW1_Vendor_Category__c vendorCateg = new TW1_Vendor_Category__c();
        vendorCateg.TW1_Status__c   = 'Not Homologated';
        vendorCateg.TW1_VEndor__c   = conta.id;
        vendorCateg.TW1_Category__c = categ.id;
        insert vendorCateg;

        /*
         *  Passo 4 - Criar uma nova categoria:
         */
        TW1_Request__c request = new TW1_Request__c();
        RecordType     req     = [SELECT Id, DeveloperName FROM RecordType where DeveloperName = 'TW1_Vendor_Vetting'];
        request.RecordTypeId  = req.Id;
        request.TW1_Vendor__c = conta.id;
        request.TW1_Shelf_Life_Vetting_Date__c = Date.today().addDays(-10);
        insert request;

        return request;
    }

    /**
     * @description Metodo que gera registros mockados (homologarCategorias - Trigger 2)
     * @author Mario Oliveira | 06/11/2019
     * @return TW1_Request__c
     **/
    public static TW1_Request__c criarRegistroMockT2()
    {
        TW1_Request__c requestHomolog = criarRegistroMock();

        requestHomolog.TW1_Homologation_Process_Status__c = 'Approved';

        update requestHomolog;

        return requestHomolog;
    }

    /**
     * @description Metodo que gera registros mockados (validarSupplierEmail - Trigger 3)
     * @author Mario Oliveira | 03/12/2019
     * @return TW1_Request__c
     **/
    @isTest
    public static void validarSupplierEmailTST()
    {
        criarCustomSettings();

        try{
            TW1_Email_List__c emailListObj = new TW1_Email_List__c();
            emailListObj.TW1_Email__c  = 'teste@teste.com';
            emailListObj.TW1_Status__c = 'Ativo';
            emailListObj.RecordTypeId  = Schema.SObjectType.TW1_Email_List__c.getRecordTypeInfosByDeveloperName().get('TW1_BM_Email').getRecordTypeId();

            T_SDK_DebugLog.EscreverLog('emailListObj: ' + emailListObj);
            insert emailListObj;
            System.debug('emailListObj: ' + emailListObj);

            TW1_Request__c request = new TW1_Request__c();
            RecordType     req     = [SELECT SobjectType, Id, DeveloperName, Name FROM RecordType where DeveloperName = 'TW1_BM'];
            request.RecordTypeId = req.Id;
            //Adicionado email diferente do criado no emailList
            request.TW1_Modec_Requester_Email__c = 'teste2@teste2.com';

            T_SDK_DebugLog.EscreverLog('Request Id: ' + request.id);
            insert request;
            System.debug('Request Id: ' + request.id);
        }
        catch (Exception e)
        {
            string mensagem        = e.getMessage();
            String currentuserId   = UserInfo.getUserId();
            User   currentUserInfo = [select LanguageLocaleKey from User where Id = :UserInfo.getUserId()];
            if (currentUserInfo.LanguageLocaleKey == 'pt_BR')
            {
                system.assert (mensagem.contains('Email do Requisitante MODEC não está cadastrado como ativo.'));
            }
            else
            {
                system.assert (mensagem.contains('Modec Requester Email is not registered as active.'));
            }
        }
    }

    @isTest
    public static void checkAllApprovallsTST()
    {
        Test.startTest();
        T_MODEC_Request_App_TST.criarCustomSettings();

        TW1_Request__c requestTest1 = criarRegistroMock();  //Trigger 1

        requestTest1.TW1_Approval_Status_Compliance_Step_1__c   = 'Approved';
        requestTest1.TW1_Approval_Status_Compliance_Step_2__c   = 'Approved';
        requestTest1.TW1_Approval_Status_Docs_Validation_VV__c  = 'Approved';
        requestTest1.TW1_Approval_Status_Engineering__c         = 'Approved with Red Flag';
        requestTest1.TW1_Approval_Status_Finance_Step_1__c      = 'Approved with Red Flag';
        requestTest1.TW1_Approval_Status_Finance_Step_2__c      = 'Approved with Red Flag';
        requestTest1.TW1_Approval_Status_HSEQ_EPCI_or_Op__c     = 'Approved with Red Flag';
        requestTest1.TW1_Approval_Status_Initial_Validation__c  = 'N/A';
        requestTest1.TW1_Approval_Status_Procurement_Manager__c = 'N/A';
        requestTest1.TW1_Approval_Status_Quality__c             = 'N/A';
        test.stopTest();
        update         requestTest1;
        TW1_Request__c requestassert = [Select Id, TW1_All_Approvals__c from TW1_Request__c where Id =:requestTest1.Id];

        System.assertEquals(true, requestassert.TW1_All_Approvals__c);  //Trigger 1
    }
}