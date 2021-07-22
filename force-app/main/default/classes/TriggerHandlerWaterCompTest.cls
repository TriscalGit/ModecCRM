@isTest
public with sharing class TriggerHandlerWaterCompTest {
    
    @isTest
    public static void afterInsertUpdateTest()
    {
        WaterCompensation__c waterComp = new WaterCompensation__c();
        Test.startTest();

        insert waterComp;
        update waterComp;
        
        Test.stopTest();
    }
}