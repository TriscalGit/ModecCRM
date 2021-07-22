@isTest
public with sharing class TriggerHandlerOccurrenceTest {

    @isTest
    public static void beforeInsertUpdateTest()
    {
        RDO__c rdo = TestUtil.createRDO();
        Occurrences__c occ = new Occurrences__c(RDO__c = rdo.Id);

        Test.startTest();

        insert occ;
        update occ;
        
        Test.stopTest();
    }
}