@isTest
public class T_MODEC_Request_Rep_TST {
    @TestSetup
    Public static void TestSetup(){
        Account conta = new Account();
        conta.name = 'TestClass';
        insert conta;
        
        TW1_Request__c req = new TW1_Request__c();
        req.TW1_Supplier_Email__c = 'teste@teste.com';
        req.TW1_Modec_Requester_Email__c = 'suportemodec@triscal.com.br';
        req.TW1_Supplier_Reference_Number_for_BM__c = '4334fdff';
        req.TW1_PO__c = 'dk489hg';
        req.TW1_Purchase_Item__c = 'fgfd';
        req.TW1_Final_Measurement__c = 'Yes';
        req.TW1_Service_Start_Date__c = Date.today();
        req.TW1_Service_End_Date__c = Date.today().addDays(5);
        req.TW1_Service_Description__c = 'dahfdfskdfhd';
        insert req;
    }
    
    @isTest
    Public static void testMethod1(){
        TW1_Request__c req = [select id from TW1_Request__c limit 1];
        T_MODEC_Request_Rep rep = new T_MODEC_Request_Rep();
        rep.getRequestBMStatus(req.id);
        rep.getRequestNFStatus(req.id);
        rep.getRequestById(req.id);
        rep.getRequestByListIds(new List<String>());
        rep.getBMsEnvioAnexos();
        rep.getInspectionAndInspectionLines(req.id);
        rep.getInspectionAndInspectionLinesCLONE(req.id);
    }
}