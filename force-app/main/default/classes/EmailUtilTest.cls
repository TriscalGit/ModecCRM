@isTest
public with sharing class EmailUtilTest {
    @isTest
    public static void sendNAMEmailsPdfTest(){
        Test.startTest();
        NAMFactory.createExchange();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');
        Contact c = new Contact(LastName = 'Test', Email = 'test@salesforce.com');
        VesselContact__c vesselContact = new VesselContact__c(Vessel__c = vessel.Id, Contact__c = c.Id, PDFAlert__c = true);
        WorkOrder wo = WorkOrderFactory.createWO(nam, 'MdB');
        WorkOrderLineItem woItem = WorkOrderFactory.createWOLineItem(wo, 1000);

        Map<String, List<String>> mapVesselVsContacts = new Map<String, List<String>>();
        Map<String, List<String>> mapIdVsContacts = new Map<String, List<String>>();
        Map<String, String> mapNAMvsName = new Map<String, String>();
        Map<String, String> mapIdVsName = new Map<String, String>();
        Map<String, String> mapIdVsWOName = new Map<String, String>();

        mapVesselVsContacts.put(nam.Vessel__c, new List<String>());
        mapIdVsContacts.put(nam.Id, mapVesselVsContacts.get(nam.Vessel__c));
        mapNAMvsName.put(nam.Id, nam.Name + ' - ' + nam.Subject__c);
        mapIdVsName.put(nam.Id, nam.Name + ' - ' + nam.Subject__c);
        mapIdVsWOName.put(wo.Id, wo.WorkOrder__c);

        GeneratePdfController.savePdf(nam.Id, 'NAM__c');
        GeneratePdfController.savePdfFuture(JSON.serialize(mapIdVsName), 'NAM__c');
        
        EmailUtil.sendNAMEmailsPdf(JSON.serialize(mapIdVsContacts), JSON.serialize(mapNAMvsName), nam.Name);
        Test.stopTest();
    }
}