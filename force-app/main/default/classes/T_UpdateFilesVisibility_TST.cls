@isTest
public class T_UpdateFilesVisibility_TST {
    
    Private static Id vendorHomologated = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('TW1_Vendor_Homologated').getRecordTypeId();
    
    
    @TestSetup
    public static void TestSetup(){
        ContentVersion arquivo = new ContentVersion();
        arquivo.Title = 'Titulo do arquivo';
        arquivo.VersionData = Blob.toPdf('Classe de teste');
        arquivo.Description = 'Texto comum';
        arquivo.PathOnClient = 'Qualquer texto';          
        insert arquivo;
        
        Account acc = new Account();
        acc.RecordTypeId = vendorHomologated;
        acc.TW1_CNPJ__c = '00151720000158';
        acc.TW1_CPF__c = '17582277023';
        acc.Name = 'TestAcc HPB';
        acc.TW1_Contact_Name__c = 'TestCont HPB';
        acc.TW1_Contact_Phone__c = '(11) 1 1111-1111';
        acc.TW1_Contact_email_address__c = 'test@test.com.br';
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
        newUser.username = 'userTest@test.com';
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
        warning.PublicationDate__c = Date.newInstance(2021, 04, 01);        
        warning.TCF_DueDate__c = Date.newInstance(2021, 06, 15);
        warning.RequiredSendEmail__c = 'No';
        warning.TCF_HSEQWarning__c = 'No';
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
        
        ContentVersion cv = [SELECT id, ContentDocumentId FROM ContentVersion WHERE id= :arquivo.id LIMIT 1];        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cv.ContentDocumentId;
        cdl.Visibility = 'InternalUsers';
        cdl.LinkedEntityId = warning.id;
        insert cdl;
    }
    
    @isTest
    public static void TestMethod_manageShareFilesVisibility(){
        T_UpdateFilesVisibility.manageShareFilesVisibility();
    }
}