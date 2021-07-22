@isTest
public with sharing class TriggerHandlerDailyRatesTest {

    @isTest
    public static void handlerTest()
    {
        RDO__c rdo = TestUtil.createRDO();
        DailyRates__c dailyRate = new DailyRates__c(RDO__c = rdo.Id,
                                                    Description__c = 'Test',
                                                    PercentReduction__c = '0.05%');
        Test.startTest();

        insert dailyRate;
        update dailyRate;
        
        Test.stopTest();
    }
}