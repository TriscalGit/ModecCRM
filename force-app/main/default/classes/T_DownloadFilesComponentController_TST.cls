@isTest
public class T_DownloadFilesComponentController_TST {

    Private static Id RTAccount = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Vendor').getRecordTypeId();
    
    @TestSetup
    static void makeContentDocument(){
        
        ContentVersion ContVer = new ContentVersion();
        ContVer.Title = 'Teste Raphael';
        ContVer.VersionData = Blob.toPdf('o');
        ContVer.PathOnClient = 'Teste.pdf';
        insert ContVer;
        
        ContentDocument doc = [Select id from ContentDocument limit 1];
        
        Account Acc = new Account();
        Acc.Name = 'Testando';
        Acc.RecordTypeId = RTAccount;
        insert Acc;
        
        ContentDocumentLink CDL = new ContentDocumentLink();
        CDL.LinkedEntityId = Acc.Id;
        CDL.ContentDocumentId = doc.Id;
        insert CDL;
    }
    
    @isTest
    public static void TestMethod1(){
        Account conta = [Select id from Account limit 1];
        List<ContentDocument> docs = T_DownloadFilesComponentController.getContentDocumentLinks(conta.id);
        System.assertEquals('Teste Raphael', docs.get(0).Title);
    }
    
    @isTest
    public static void TestMethod2(){
        String link = T_DownloadFilesComponentController.getOrgURL();
        System.assertNotEquals(null, link);
    }
}