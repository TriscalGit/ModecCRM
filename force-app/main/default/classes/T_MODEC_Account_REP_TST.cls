@isTest
public class T_MODEC_Account_REP_TST {
    Private static Id vendorHomologated = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('TW1_Vendor_Homologated').getRecordTypeId();
    Private static Id material = Schema.SObjectType.TW1_Category__c.getRecordTypeInfosByDeveloperName().get('TW1_Material').getRecordTypeId();
  	Private static Id service = Schema.SObjectType.TW1_Category__c.getRecordTypeInfosByDeveloperName().get('TW1_Service').getRecordTypeId();

    @TestSetup
    public static void TestSetup(){
		List<SObject> listSObject = new List<SObject>();        
        
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
        
        TW1_Category__c categm = new TW1_Category__c();
        categm.RecordTypeId = material;
		categm.TW1_Category__c = 'TesteCategoriaMaterial';
    	categm.TW1_Sub_Category__c  = 'TesteSubCategoriaMaterial';
        listSObject.add(categm);
        
        TW1_Category__c categs = new TW1_Category__c();
        categs.RecordTypeId = service;
		categs.TW1_Category__c = 'TesteCategoriaService';
    	categs.TW1_Sub_Category__c  = 'TesteSubCategoriaService'; 
        listSObject.add(categs);       
        
        insert listSObject;
        
        TW1_Vendor_Category__c  supplierCategory = new TW1_Vendor_Category__c();        
    	supplierCategory.TW1_Category__c = categm.id;
        supplierCategory.TW1_Vendor__c = acc.id;
        insert supplierCategory;
        
        
        supplierCategory = new TW1_Vendor_Category__c();        
    	supplierCategory.TW1_Category__c = categs.id;
        supplierCategory.TW1_Vendor__c = acc.id;
        insert supplierCategory;
        
        acc.TW1_Step_Owner__c = newUser.id;
        update acc;
    }
    
    @isTest
    public static void TestMethod_getPicklistVendorVetting(){        
        Account acc = [SELECT id, TW1_CNPJ__c  FROM Account LIMIT 1];
         List<Schema.PicklistEntry> entries = T_MODEC_Account_REP.getPicklistVendorVetting('TW1_Vendor_Vetting__c');
    }
    
    
    @isTest
    public static void TestMethod_getVendorCategoryById(){        
        Account acc = [SELECT id, TW1_CNPJ__c  FROM Account LIMIT 1];
        List<TW1_Vendor_Category__c> listVendorCategory = T_MODEC_Account_REP.getVendorCategoryById(acc.id);
    }
    
    @isTest
    public static void TestMethod_buscarContasExpiradas(){
        
        list<Account> listAccount = T_MODEC_Account_REP.buscarContasExpiradas();
    }
    
    @isTest
    public static void TestMethod_SearchAccountByCNPJ(){
        Account acc = [SELECT id, TW1_CNPJ__c  FROM Account LIMIT 1];
        T_MODEC_Account_REP accRep = new T_MODEC_Account_REP();       
        list<Account> listAccount = accRep.SearchAccountByCNPJ(acc.TW1_CNPJ__c);
    }
    
    @isTest
    public static void TestMethod_getSuppliersByNameAndCategoryType_Service(){
        
        list<Account> listAccount = T_MODEC_Account_REP.getSuppliersByNameAndCategoryType('TestAcc HPB', 'TW1_Service', 'Active');
    }
    
    @isTest
    public static void TestMethod_getSuppliersByNameAndCategoryType_Material(){
        
        list<Account> listAccount = T_MODEC_Account_REP.getSuppliersByNameAndCategoryType('TestAcc HPB', 'TW1_Material', 'Active');
    }
    
    @isTest
    public static void TestMethod_getSuppliersByCategoryAndSubCategory(){
        list<Account> listAccount = T_MODEC_Account_REP.getSuppliersByCategoryAndSubCategory('TesteCategoriaService', 'TesteSubCategoriaService', ' ');
    }
}