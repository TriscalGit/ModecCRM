@isTest
public class T_WarningApp_TST {

    Private static Id vendorHomologated = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('TW1_Vendor_Homologated').getRecordTypeId();
    
    @TestSetup
    public static void TestSetup(){
        Account acc = new Account();
        acc.RecordTypeId = vendorHomologated;
        acc.TW1_CNPJ__c = '00151720000158';
        acc.TW1_CPF__c = '17582277023';
        acc.Name = 'TestAcc HPB';
        acc.TW1_Contact_Name__c = 'TestCont HPB';
        acc.TW1_Contact_Phone__c = '(11) 1 1111-1111';
        acc.TW1_Contact_email_address__c = 'test@test.com.br';
        acc.TCF_HSEQResponsibleEmail__c = 'test@test.com.br';
        acc.TW1_Shelf_Life_Vetting_Date__c = Date.today().addDays(-2);        
        insert acc;
        
        Contact cont = new Contact();
        cont.LastName = 'TestCont HPB';
        cont.Email = 'test@test.com.br';
        cont.Phone = '(11) 1 1111-1111';
        cont.AccountId = acc.id;
        insert cont;        
        
        User newUser = new User();
        newUser.profileId = [SELECT Id FROM Profile WHERE Name='Supplier User'].id;        
        newUser.username = 'supplierUser@test.com';
        newUser.email = 'test@test.com';
        newUser.emailencodingkey = 'ISO-8859-1';
        newUser.localesidkey = 'pt_BR';
        newUser.languagelocalekey = 'en_US';
        newUser.timezonesidkey = 'America/Sao_Paulo';
        newUser.alias='nuser';
        newUser.lastname='lastname';
        newUser.contactId = cont.id;
        insert newUser;
        
        TOBJ_Warning__c warning = new TOBJ_Warning__c();
        warning.PublicationDate__c = Date.today().addDays(-2);        
        warning.TCF_DueDate__c = Date.today().addDays(2);
        warning.RequiredSendEmail__c = 'Yes';
        warning.TCF_HSEQWarning__c = 'Yes';
        warning.TCF_Subject__c = 'Teste de Setup 1';
        warning.TCF_Notice__c = '<p>Teste com warnings 1</p>';
        warning.TCF_RequiresConfirmation__c = 'No';
        insert warning;
        
        acc.TW1_Step_Owner__c = newUser.id;
        update acc; 
        
        TOBJ_Participants__c participante = new TOBJ_Participants__c();
        participante.TCF_Supplier__c = acc.id;
        participante.Warning__c = warning.id; 
        insert participante; 
        
        ContentVersion arquivo = new ContentVersion();
        arquivo.Title = 'Titulo do arquivo';
        arquivo.VersionData = Blob.toPdf('Classe de teste');
        arquivo.Description = 'Texto comum';
        arquivo.PathOnClient = 'Qualquer texto';
        insert arquivo;
        
        ContentVersion versao = [select id, contentDocumentId from ContentVersion where Title= 'Titulo do arquivo' limit 1];
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.Visibility = 'AllUsers';
        Cdl.LinkedEntityId = participante.Warning__c;
        cdl.ContentDocumentId = versao.ContentDocumentId;
        insert cdl;
    }
    
    @isTest
    public static void TestMethod_warningEmailAlertToSuppliers(){
        TOBJ_Warning__c warn = [select id from TOBJ_Warning__c where TCF_Subject__c = 'Teste de Setup 1' limit 1];
        T_WarningEmailAlertToSupplierInvocable.warningEmailAlertToSuppliers(new List<TOBJ_Warning__c>{warn});
    }
    
    @isTest
    public static void TestMethod_warningEmailAlertToSuppliers_Future(){
        T_WarningApp.warningEmailAlertToSuppliers();
    }
}