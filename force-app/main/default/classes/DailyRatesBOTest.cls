@isTest
public with sharing class DailyRatesBOTest {
    
    @isTest
    public static void FillNReportTest()
    {
        Test.startTest();
        DailyRates__c dailyRate = TestUtil.createDailyRate();
        update dailyRate;
        List<DailyRates__c> lstDailyRate = new List<DailyRates__c>();

        lstDailyRate.add(dailyRate);

        DailyRatesBO.getInstance().FillNReport(lstDailyRate);

        Test.stopTest();
    }

    @isTest
    public static void formatTimeFields()
    {
        Test.startTest();

        DailyRates__c dailyRate = TestUtil.createDailyRate();
        update dailyRate;

        List<DailyRates__c> lstDailyRate = new List<DailyRates__c>();

        dailyRate.ExtraTime__c = Time.newInstance(11, 1, 0, 0);
        dailyRate.TimeOccurrence__c = Time.newInstance(11, 1, 0, 0);

        lstDailyRate.add(dailyRate);
        DailyRatesBO.getInstance().formatTimeFields(lstDailyRate);
        lstDailyRate.clear();

        dailyRate.ExtraTime__c = Time.newInstance(11, 1, 0, 0);
        dailyRate.TimeOccurrence__c = Time.newInstance(11, 1, 0, 0);
        
        lstDailyRate.add(dailyRate);
        DailyRatesBO.getInstance().formatTimeFields(lstDailyRate);
        lstDailyRate.clear();

        dailyRate.ExtraTime__c = Time.newInstance(11, 11, 0, 0);
        dailyRate.TimeOccurrence__c = Time.newInstance(11, 11, 0, 0);
        
        lstDailyRate.add(dailyRate);
        DailyRatesBO.getInstance().formatTimeFields(lstDailyRate);
        lstDailyRate.clear();

        dailyRate.ExtraTime__c = null;
        dailyRate.ExtraTimeFrm__c = '11:01:00';
        dailyRate.TimeOccurrence__c = null;
        dailyRate.TimeOcurrenceFrm__c = '11:01:00';

        lstDailyRate.add(dailyRate);
        DailyRatesBO.getInstance().formatTimeFields(lstDailyRate);

        Test.stopTest();
    }
}