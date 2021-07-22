@isTest
public with sharing class BackchargeBOTest {
    
    @isTest
    public static void backchargeBOTest()
    {
        List<Backcharge__c> lstBackcharge = new List<Backcharge__c>();

        Test.startTest();

        Backcharge__c backcharge = new Backcharge__c();
        insert backcharge;
        update backcharge;

        lstBackcharge.add(backcharge);
        BackchargeBO.getInstance().calculateDollar(lstBackcharge);

        Test.stopTest();
    }
}