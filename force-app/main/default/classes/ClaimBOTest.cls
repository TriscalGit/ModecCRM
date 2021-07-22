@isTest
public with sharing class ClaimBOTest {
    
    @isTest
    public static void claimBOTest()
    {
        List<Claim__c> lstClaim = new List<Claim__c>();

        Test.startTest();

        Claim__c claim = TestUtil.createClaim('Letter');
        lstClaim.add(claim);
        ClaimBO.getInstance().calculateDollar(lstClaim);
        ClaimBO.getInstance().fillLetterGroup(lstClaim);

        lstClaim.clear();
        Claim__c claimRDO = TestUtil.createClaim('RDO');
        lstClaim.add(claimRDO);
        ClaimBO.getInstance().createRDOAssociation(lstClaim);

        Test.stopTest();
    }
}