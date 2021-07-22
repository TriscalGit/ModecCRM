@isTest
public with sharing class VesselContractDAOTest {
    
    @isTest
    public static void VesselContractDAOTest(){

        VesselContract__c vesselContract = TestUtil.createVesselContractServices();

        Test.startTest();
        VesselContractDAO.getVesselContractById(vesselContract.Id);
        VesselContractDAO.getVesselContractByContractNumber(vesselContract.Name, 'Teste', vesselContract.Type__c);
        VesselContractDAO.getVesselContractByIdAndType(vesselContract.Id, vesselContract.Type__c);
        VesselContractDAO.getMealAllowanceByNumber(vesselContract.Name);
        Test.stopTest();
    }
}