/**
* @description       :
* @author            : Hugo Brito
* @group             :
* @last modified on  : 05-14-2021
* @last modified by  : Hugo Brito
* Modifications Log
* Ver   Date         Author       Modification
* 1.0   05-14-2021   Hugo Brito   Criação da classe
**/
@isTest
public class T_ContentDocumentLinkValidationApp_TST {

    Private static Id vendorHomologated = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('TW1_Vendor_Homologated').getRecordTypeId();
    Private static Id requestInspection = Schema.SObjectType.TW1_Request__c.getRecordTypeInfosByDeveloperName().get('Inspection').getRecordTypeId();
    Private static Id documentationInspection = Schema.SObjectType.TW1_Documentation__c.getRecordTypeInfosByDeveloperName().get('TW1_Inspection_Documentation').getRecordTypeId();
    
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
    }
    
    @isTest
    public static void TestMethod_ValidateInsertDocument(){
        
        User supplierUser = [select id, contact.AccountId from User where username = 'supplierUser@test.com' limit 1];
        ContentVersion versao = [select id, contentDocumentId from ContentVersion where Title= 'Titulo do arquivo' limit 1];
        TOBJ_Participants__c participante = [select id, Warning__c from TOBJ_Participants__c where TCF_Supplier__c =: supplierUser.contact.AccountId limit 1];
        
        try{
            System.runAs(supplierUser){
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.Visibility = 'AllUsers';
                cdl.LinkedEntityId = participante.Warning__c;
                cdl.ContentDocumentId = versao.ContentDocumentId;
                insert cdl;
            }
            System.assertEquals(true, false);
        } catch(Exception e){
            IF(e.getMessage().contains('Não é possível adicionar o arquivo. Por favor, entre em contato com a Modec.')){
                //no error
            } else {
                System.assertEquals(true, false);
            }
        }
    }
    
    @isTest
    public static void TestMethod_ValidateDeleteDocument(){
        
        Account conta = [select id from account limit 1];
        
        TW1_Request__c request = new TW1_Request__c();
        request.TW1_Vendor__c = conta.id;
        request.RecordTypeId = requestInspection;
        insert request;
        
        TW1_Documentation__c doc = new TW1_Documentation__c();
        doc.RecordTypeId = documentationInspection;
        doc.TW1_Request__c = request.id;
        insert doc;
        
        ContentVersion versao = [select id, contentDocumentId from ContentVersion where Title= 'Titulo do arquivo' limit 1];
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.Visibility = 'AllUsers';
        cdl.LinkedEntityId = doc.id;
        cdl.ContentDocumentId = versao.ContentDocumentId;
        insert cdl;
        
        TW1_Inspection_Item__c item = new TW1_Inspection_Item__c();
        item.TW1_Item_Description__c = '45546546';
        item.TW1_Quantity__c = 46;
        item.TW1_Tag_or_Certificate_Number__c = '446';
        item.TW5_PO_Item_Number__c = 4546;
        item.TW5_Isometric_Drawing__c = '4546';
        item.TW1_Request__c = request.id;
        insert item;
        
        request.TW1_Inspection_Status__c = 'Canceled';
        update request;
        
        try{
            delete cdl;
            System.assertEquals(true, false);
        } catch(Exception e){
            IF(e.getMessage().contains('Não é possível deletar o arquivo. Por favor, entre em contato com o administrador.')){
                //no error
            } else {
                System.assertEquals(true, false);
            }
        }
    }
}