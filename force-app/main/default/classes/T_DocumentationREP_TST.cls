@isTest
public class T_DocumentationREP_TST {
    
    Private static Id RTInspectionDocumentation = Schema.SObjectType.TW1_Documentation__c.getRecordTypeInfosByDeveloperName().get('TW1_Inspection_Documentation').getRecordTypeId();
    
    @TestSetup
    static void makeDocument(){
        
        TW1_Request__c Req = new TW1_Request__c();
        Req.TW1_Inspection_Status__c = 'Reproved';
        insert Req;
		
        TW1_Documentation__c Document = new TW1_Documentation__c();
        Document.RecordTypeId = RTInspectionDocumentation;
        Document.TW1_Request__c = Req.id;
        insert Document;
    }
    
    @isTest
    public static void TestMethod_getInspectionDocumentation(){
        
        TW1_Documentation__c doc = [Select id from TW1_Documentation__c limit 1];
        
        Set<String> ids = new Set<String>();
        ids.add(doc.id);
            
        List<TW1_Documentation__c> docs = T_DocumentationREP.getInspectionDocumentation(ids);
        
        System.assertEquals(doc.id, docs.get(0).id);
    }
    
    @isTest
    public static void TestMethod_getInspectionDocumentationMap(){
        
        TW1_Documentation__c doc = [Select id from TW1_Documentation__c limit 1];
        
        Set<String> ids = new Set<String>();
        ids.add(doc.id);
            
        Map<id, TW1_Documentation__c> mapaDocs = T_DocumentationREP.getInspectionDocumentationMap(ids);
        
        System.assertEquals(doc.id, mapaDocs.values().get(0).id);
    }
}