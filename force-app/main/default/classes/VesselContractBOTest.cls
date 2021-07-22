@isTest
public with sharing class VesselContractBOTest {
    
    @isTest
    public static void populateDailyRateHistoryTestCharter(){
        
        List<VesselContract__c> lstVessel = new List<VesselContract__c>();
        Map<Id, VesselContract__c> mapVessel = new Map<Id, VesselContract__c>();

        Test.startTest();

        VesselContract__c vessel = new VesselContract__c();
        vessel.ActualDailyRateUSD__c = 1.0;
        vessel.ActualDailyRateBRL__c = 2.0;
        vessel.Type__c = 'Charter';
        Insert vessel;
        System.debug('LST: '+ lstVessel);


        vessel.ActualDailyRateUSD__c = 5.0; 
        vessel.ActualDailyRateBRL__c = 15.0;
        update vessel;
   
        Test.stopTest();
    }

    @isTest
    public static void populateDailyRateHistoryTestServices(){
        
        List<VesselContract__c> lstVessel = new List<VesselContract__c>();
        Map<Id, VesselContract__c> mapVessel = new Map<Id, VesselContract__c>();

        Test.startTest();

        VesselContract__c vessel2 = new VesselContract__c();
        vessel2.ActualDailyRateUSD__c = 1.0;
        vessel2.ActualDailyRateBRL__c = 2.0;
        vessel2.Pilot__c = 500;
        vessel2.Type__c = 'Services';
        Insert vessel2;
        System.debug('LST: '+ lstVessel);


        vessel2.ActualDailyRateUSD__c = 5.0; 
        vessel2.ActualDailyRateBRL__c = 15.0;
        update vessel2;
   
        Test.stopTest();

    }
}