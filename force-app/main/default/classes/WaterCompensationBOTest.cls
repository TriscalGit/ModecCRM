@isTest
public with sharing class WaterCompensationBOTest {
     
    @isTest
    public static void waterCompensationBOTest()
    {
        List<WaterCompensation__c> lstWComp = new List<WaterCompensation__c>();

        Test.startTest();
        WaterCompensation__c waterComp = TestUtil.createWaterComp();
        lstWComp.add(waterComp);

        WaterCompensationBO.getInstance().updateRDOs(lstWComp);

        Test.stopTest();

    }

}