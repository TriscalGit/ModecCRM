@isTest
public class T_MODEC_ContentDocumentApp_TST {

    Private static Id vendorHomologated = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('TW1_Vendor_Homologated').getRecordTypeId();
    Private static Id requestInspection = Schema.SObjectType.TW1_Request__c.getRecordTypeInfosByDeveloperName().get('Inspection').getRecordTypeId();
    Private static Id documentationInspection = Schema.SObjectType.TW1_Documentation__c.getRecordTypeInfosByDeveloperName().get('TW1_Inspection_Documentation').getRecordTypeId();
    
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
        
        TW1_Request__c request = new TW1_Request__c();
        request.TW1_Vendor__c = acc.id;
        request.OwnerId = newUser.id;
        request.RecordTypeId = requestInspection;
        insert request;
        
        ContentVersion arquivo = new ContentVersion();
        arquivo.Title = 'Titulo do arquivo';
        arquivo.VersionData = Blob.toPdf('Classe de teste');
        arquivo.Description = 'Texto comum';
        arquivo.PathOnClient = 'Qualquer texto';
        insert arquivo;
        
        TW1_Documentation__c doc = new TW1_Documentation__c();
        doc.RecordTypeId = documentationInspection;
        doc.TW1_Request__c = request.id;
        insert doc;
        
        ContentVersion versao = [select id, contentDocumentId from ContentVersion where Title= 'Titulo do arquivo' limit 1];
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.Visibility = 'AllUsers';
        cdl.ShareType = 'V';
        cdl.LinkedEntityId = doc.id;
        cdl.ContentDocumentId = versao.ContentDocumentId;
        insert cdl;
        
        ContentDocument cd = [select id from ContentDocument limit 1];
        cd.OwnerId = newUser.id;
        update cd;
    }
    
    @isTest
    public static void TestMethod1(){
        User oUser = [select id from User where username = 'supplierUser@test.com' limit 1];
        
        System.runAs(oUser){
            try{
                ContentDocument cd = [select id from ContentDocument limit 1];
                delete cd;
                System.assertEquals(true, false);
            } catch(Exception e){
                IF(e.getMessage().contains('Não é possível deletar o arquivo da inspeção. Por favor, entre em contato com a Modec.')){
                    //no error
                } else {
                    System.assertEquals(true, false);
                }
            }
        }
    }
}