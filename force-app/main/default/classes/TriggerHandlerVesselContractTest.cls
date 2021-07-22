@isTest
public with sharing class TriggerHandlerVesselContractTest {

    @isTest
    public static void afterInsertUpdateTest(){

        VesselContract__c vessel = new VesselContract__c();

        Test.startTest();

        insert vessel;
        update vessel;

        Test.stopTest();

    }
}