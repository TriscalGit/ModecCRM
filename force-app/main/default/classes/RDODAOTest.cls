@isTest
public with sharing class RDODAOTest {
    
    @isTest
    public static void rdoDAOTest(){

        RDO__c rdo = TestUtil.createRDO();

        Test.startTest();
        RDODAO.getRDOById(rdo.Id);
        RDODAO.getRDOsByIdBOM(rdo.BOM__c, ' ');
        RDODAO.getRDOByName(rdo.Name);
        Test.stopTest();
    }
}