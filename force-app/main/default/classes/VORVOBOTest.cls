@isTest
public with sharing class VORVOBOTest {
   
    @isTest
    public static void VORVOBOTest()
    {
        List<VORVO__c> lstVORVO = new List<VORVO__c>();
        VORVO__c vor = TestUtil.createVORVO();

        lstVORVO.add(vor);

        Test.startTest();
        VORVOBO.getInstance().fillLetterGroup(lstVORVO);
        Test.stopTest();
    }
}