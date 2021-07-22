@isTest
public class T_WarningViewScreenController_TST {
    
    Private static Id VendorHomologated = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('TW1_Vendor_Homologated').getRecordTypeId();
    
    @TestSetup
    public static void TestSetup(){
        List<SObject> listSObject = new List<SObject>();
        
        Account acc = new Account();
        acc.RecordTypeId = VendorHomologated;
        acc.TW1_CNPJ__c = '00151720000158';
        acc.TW1_CPF__c = '17582277023';
        acc.Name = 'TestAcc HPB';
        acc.TW1_Contact_Name__c = 'TestCont HPB';
        acc.TW1_Contact_Phone__c = '(11) 1 1111-1111';
        acc.TW1_Contact_email_address__c = 'test@test.com.br';        
        insert acc;        
        
        Contact cont = new Contact();
        cont.LastName = 'TestCont HPB';
        cont.Email = 'test@test.com.br';
        cont.Phone = '(11) 1 1111-1111';
        cont.AccountId = acc.id;
        insert cont;        
        
        User newUser = new User();
        newUser.profileId = '00e3i000000uGicAAE';
        newUser.username = 'userTest@test.com';
        newUser.email = 'test@test.com';
        newUser.emailencodingkey = 'ISO-8859-1';
        newUser.localesidkey = 'pt_BR';
        newUser.languagelocalekey = 'en_US';
        newUser.timezonesidkey = 'America/Sao_Paulo';
        newUser.alias='nuser';
        newUser.lastname='lastname';
        newUser.contactId = cont.id;
        listSObject.add(newUser);
        
        TOBJ_Warning__c warning = new TOBJ_Warning__c();
        warning.PublicationDate__c = Date.newInstance(2021, 04, 01);        
        warning.TCF_DueDate__c = Date.newInstance(2021, 06, 15);
        warning.RequiredSendEmail__c = 'No';
        warning.TCF_HSEQWarning__c = 'No';
        warning.TCF_Subject__c = 'Teste de Setup 1';
        warning.TCF_Notice__c = '<p>Teste com warnings 1</p>';
        warning.TCF_RequiresConfirmation__c = 'No';
		listSObject.add(warning);
        
              
        
        warning = new TOBJ_Warning__c();
        warning.PublicationDate__c = Date.newInstance(2021, 04, 28);        
        warning.TCF_DueDate__c = Date.newInstance(2021, 05, 18);
        warning.RequiredSendEmail__c = 'No';
        warning.TCF_HSEQWarning__c = 'No';
        warning.TCF_Subject__c = 'Teste de Setup 2';
        warning.TCF_Notice__c = '<p>Teste com warnings 2</p>';
        warning.TCF_RequiresConfirmation__c = 'No';
		listSObject.add(warning);
        
        warning = new TOBJ_Warning__c();
        warning.PublicationDate__c = Date.newInstance(2021, 04, 15);        
        warning.TCF_DueDate__c = Date.newInstance(2021, 08, 20);
        warning.RequiredSendEmail__c = 'No';
        warning.TCF_HSEQWarning__c = 'No';
        warning.TCF_Subject__c = 'Teste de Setup 3';
        warning.TCF_Notice__c = '<p>Teste com warnings 3</p>';
        warning.TCF_RequiresConfirmation__c = 'No';
		listSObject.add(warning);
        
        insert listSObject;
        
        acc.TW1_Step_Owner__c = newUser.id;
        update acc;        
       
        TOBJ_Participants__c participant = new TOBJ_Participants__c();
        participant.TCF_Supplier__c = acc.id;
        participant.Warning__c = warning.id; 
        insert participant;
    }
    
    @isTest
    public static void TestMethod_getWarningsSettings(){
        WarningSettings__c warningS = T_WarningViewScreenController.getWarningsSettings();
    }
    
    @isTest
    public static void TestMethod_getWarning(){
        List<SObject> listWarning = T_WarningViewScreenController.getWarning('TCF_DueDate__c', 'asc');
    }
    
    @isTest
    public static void TestMethod_getWarning_UserNull(){
        User usuario = [SELECT id FROM User WHERE Contact.AccountId != null LIMIT 1];
        
        System.runAs(usuario){
            List<SObject> listWarning = T_WarningViewScreenController.getWarning('TCF_DueDate__c', 'asc'); 
        }
    }
}