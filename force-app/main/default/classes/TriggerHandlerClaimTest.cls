@isTest
public with sharing class TriggerHandlerClaimTest {

    @isTest
    public static void beforeInsertUpdateTest()
    {
        Claim__c claim = new Claim__c();
        Test.startTest();

        insert claim;
        update claim;
        
        Test.stopTest();
    }
}