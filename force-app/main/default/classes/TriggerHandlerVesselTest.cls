@isTest
public with sharing class TriggerHandlerVesselTest {

    @isTest
    public static void afterInsertUpdateTest()
    {
        Vessel__c vessel = new Vessel__c();
        vessel.Name = 'Vessel Test';
        vessel.ShortName__c = 'Test';
        vessel.Status__c = 'In Operation'; 
        vessel.Country__c = 'Brazil';

        Test.startTest();

        insert vessel;
        update vessel;
        
        Test.stopTest();
    }
}