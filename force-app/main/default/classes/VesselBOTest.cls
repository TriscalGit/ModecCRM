@isTest
public with sharing class VesselBOTest {

    @isTest
    public static void populateVesselClientHistoryTest()
    {
        List<Vessel__c> lstVessel = new List<Vessel__c>();
        Map<Id, Vessel__c> mapIdVessel = new Map<Id, Vessel__c>();

        Test.startTest();
        Client__c management = new Client__c();
        management.Name = 'Management-Test';
        insert management;

        Client__c newManagement = new Client__c();
        newManagement.Name = 'Management-Test-New';
        insert newManagement;

        Vessel__c vessel = new Vessel__c();
        vessel.Name = 'Vessel-Test';
        vessel.ShortName__c = 'Test';
        vessel.Management__c = management.Id;
        vessel.Status__c = 'In Operation'; 
        vessel.Country__c = 'Brazil';
        insert vessel;

        Vessel__c oldVessel = [SELECT Id, Name, ShortName__c, Management__c, Status__c, Country__c, ManagementName__c from Vessel__c where Vessel__c.Id = :vessel.Id];
        oldVessel.Management__c = newManagement.Id;
        update vessel;

        lstVessel.add(vessel);
        mapIdVessel.put(oldVessel.Id, oldVessel);

        VesselBO.getInstance().populateVesselClientHistory(lstVessel, mapIdVessel);
        Test.stopTest();
    }
}