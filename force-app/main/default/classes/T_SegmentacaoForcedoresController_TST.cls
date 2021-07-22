@isTest
public class T_SegmentacaoForcedoresController_TST {
    
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
        
        TOBJ_Participants__c participante = new TOBJ_Participants__c();
        participante.TCF_Supplier__c = acc.id;
        participante.Warning__c = warning.id; 
        insert participante;
        
    }
    
    @isTest
    public static void TestMethod_searchForSuppliers_NameFull(){
        T_SegmentacaoForcedoresController.SearchDTO pesquisa = new T_SegmentacaoForcedoresController.SearchDTO();
        pesquisa.SearchType = 'Name'; 
        pesquisa.recordId = [SELECT id FROM TOBJ_Warning__c WHERE TCF_Subject__c = 'Teste de Setup 2' LIMIT 1].id;
        pesquisa.SupplierName = 'TestAcc HPB';
        
        List<SObject> lista = T_SegmentacaoForcedoresController.searchForSuppliers(pesquisa);
		System.assertEquals( 'TestAcc HPB', (String) lista.get(0).get('Name'));         
        
    }
    @isTest
    public static void TestMethod_searchForSuppliers_ImcompleteName(){
        T_SegmentacaoForcedoresController.SearchDTO pesquisa = new T_SegmentacaoForcedoresController.SearchDTO();
        pesquisa.SearchType = 'Name'; 
        pesquisa.recordId = [SELECT id FROM TOBJ_Warning__c WHERE TCF_Subject__c = 'Teste de Setup 2' LIMIT 1].id;
        pesquisa.SupplierName = 'Test';
        
        List<SObject> lista = T_SegmentacaoForcedoresController.searchForSuppliers(pesquisa); 
  		System.assertEquals( 'TestAcc HPB', (String) lista.get(0).get('Name'));         

    }
    
    @isTest
    public static void TestMethod_searchForSuppliers_CategoryRT(){
        T_SegmentacaoForcedoresController.SearchDTO pesquisa = new T_SegmentacaoForcedoresController.SearchDTO();
        pesquisa.SearchType = 'Name'; 
        pesquisa.recordId = [SELECT id FROM TOBJ_Warning__c WHERE TCF_Subject__c = 'Teste de Setup 2' LIMIT 1].id;
        pesquisa.CategoryRT = 'TW1_Material';
        
        List<SObject> lista = T_SegmentacaoForcedoresController.searchForSuppliers(pesquisa);  
        System.assertEquals( 'TestAcc HPB', (String) lista.get(0).get('Name'));         

    }
    
    @isTest
    public static void TestMethod_searchForSuppliers_Category(){
        T_SegmentacaoForcedoresController.SearchDTO pesquisa = new T_SegmentacaoForcedoresController.SearchDTO();
        pesquisa.SearchType = 'Category'; 
        pesquisa.recordId = [SELECT id FROM TOBJ_Warning__c WHERE TCF_Subject__c = 'Teste de Setup 2' LIMIT 1].id;
        pesquisa.Category = 'TesteCategoriaService';        
                
        List<SObject> lista = T_SegmentacaoForcedoresController.searchForSuppliers(pesquisa);
		System.debug('HG - lista: ' + lista);
        System.assertEquals( 'TestAcc HPB', (String) lista.get(0).get('Name'));         
        
    }
    
    @isTest
    public static void TestMethod_searchForSuppliers_SubCategory(){
        T_SegmentacaoForcedoresController.SearchDTO pesquisa = new T_SegmentacaoForcedoresController.SearchDTO();
        pesquisa.SearchType = 'Category';   
        pesquisa.recordId = [SELECT id FROM TOBJ_Warning__c WHERE TCF_Subject__c = 'Teste de Setup 2' LIMIT 1].id;
        pesquisa.SubCategory = 'TesteSubCategoriaMaterial';
        
        List<SObject> lista = T_SegmentacaoForcedoresController.searchForSuppliers(pesquisa);
        System.debug('GUFS: '+(String) lista.get(0).get('Name'));
		System.assertEquals( 'TestAcc HPB', (String) lista.get(0).get('Name'));
    }
    
    @isTest
    public static void TestMethod_searchForSuppliers_CategoryAndSubCategory(){
        T_SegmentacaoForcedoresController.SearchDTO pesquisa = new T_SegmentacaoForcedoresController.SearchDTO();
        pesquisa.SearchType = 'Category';
        pesquisa.recordId = [SELECT id FROM TOBJ_Warning__c WHERE TCF_Subject__c = 'Teste de Setup 2' LIMIT 1].id;
        pesquisa.Category = 'TesteCategoriaService';
        pesquisa.SubCategory = 'TesteSubCategoriaService';
        
        List<SObject> lista = T_SegmentacaoForcedoresController.searchForSuppliers(pesquisa);
		System.assertEquals( 'TestAcc HPB', (String) lista.get(0).get('Name'));        
    }
    
     @isTest
    public static void TestMethod_searchForSuppliers_Participantes(){
        
        T_SegmentacaoForcedoresController.SearchDTO pesquisa = new T_SegmentacaoForcedoresController.SearchDTO();
        pesquisa.SearchType = 'Participantes';
        pesquisa.recordId = [SELECT Warning__c FROM TOBJ_Participants__c limit 1].Warning__c;
        
        List<SObject> lista = T_SegmentacaoForcedoresController.searchForSuppliers(pesquisa); 
        System.assertEquals( 'TestAcc HPB', (String) lista.get(0).getSObject('TCF_Supplier__r').get('Name'));
    }

    @isTest
    public static void TestMethod_addParticipantesApex(){
        TOBJ_Warning__c warning = [SELECT id FROM TOBJ_Warning__c WHERE TCF_Subject__c = 'Teste de Setup 1' LIMIT 1];
        T_SegmentacaoForcedoresController.SearchDTO pesquisa = new T_SegmentacaoForcedoresController.SearchDTO();
        pesquisa.SearchType = 'Name'; 
        pesquisa.SupplierName = 'TestAcc HPB';        
        List<Account> lista = T_SegmentacaoForcedoresController.searchForSuppliers(pesquisa); 
		        
        String resp = T_SegmentacaoForcedoresController.addParticipantesApex(lista, warning.id);
    }
    
    
    @isTest
    public static void TestMethod_removeParticipantesApex(){
        /*TOBJ_Participants__c part = [select id from TOBJ_Participants__c limit 1];
        String jsonStr = JSON.serialize(part);
        Object mapa = (Object) JSON.deserialize(jsonStr, Object.class);
        
        List<Object> objs = new List<Object>();
        objs.add(mapa);
        T_SegmentacaoForcedoresController.removeParticipantesApex(objs);*/
    }
    
    @isTest
    public static void TestMethod_getCategoryRecordTypes(){
        List<RecordType> listRecord = T_SegmentacaoForcedoresController.getCategoryRecordTypes();
        System.assertNotEquals(null, listRecord);
    }
    
    @isTest
    public static void TestMethod_getPicklistVendorVetting(){
        String Entries = T_SegmentacaoForcedoresController.getPicklistVendorVetting('TW1_Vendor_Vetting__c');
        System.assertNotEquals(null, Entries);
    }
    
}