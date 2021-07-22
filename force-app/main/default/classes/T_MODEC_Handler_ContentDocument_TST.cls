@isTest
public class T_MODEC_Handler_ContentDocument_TST {

    @TestSetup
    public static void TestSetUp(){
        TW1_Documentation__c doc = new TW1_Documentation__c();
        doc.RecordTypeId = Schema.SObjectType.TW1_Documentation__c.getRecordTypeInfosByDeveloperName().get('TW1_Inspection_Documentation').getRecordTypeId();
        //doc.Name = 'TESTECLASS';
        insert doc;
        
        ContentVersion cv = new ContentVersion();
        cv.PathOnClient = 'Test';
        cv.Title = 'Test';
        cv.VersionData = Blob.valueOf('Test');
        insert cv;
        
        cv = [select ContentDocumentId from ContentVersion where id =: cv.id limit 1];
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cv.ContentDocumentId;
        cdl.LinkedEntityId = doc.Id;
        insert cdl;
    }
    
    @isTest
    public static void TestMethod1(){
        ContentDocument cd = [select id from ContentDocument limit 1];
        User u = [select id from User where Profile.UserLicense.Name = 'External Apps' and isActive = true limit 1];
        cd.OwnerId = u.id;
        update cd;
        System.runAs(u){
            delete cd;
        }
    }
}