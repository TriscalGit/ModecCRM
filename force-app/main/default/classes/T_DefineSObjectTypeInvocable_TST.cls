@isTest
public class T_DefineSObjectTypeInvocable_TST {
    
    Private static Id vendorHomologated = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('TW1_Vendor_Homologated').getRecordTypeId();
    
    @testSetup
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
    } 
    
    @isTest
    Public static void TestMethod_getSObjectType(){
        Account conta = [select id from Account limit 1];
        List<Id> ids = new List<Id>();
        ids.add(conta.id);
        List<String> retorno = T_DefineSObjectTypeInvocable.getSObjectType(ids);
        System.assertEquals('Account', retorno.get(0));
    }
}