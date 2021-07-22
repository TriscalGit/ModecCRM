@isTest
public with sharing class TriggerHandlerVORVOTest {
    
    @isTest
    public static void triggerHandlerVORVOTest()
    {
        VORVO__c vor = TestUtil.createVORVO();

        Test.startTest();
        update vor;
        Test.stopTest();
    }
}