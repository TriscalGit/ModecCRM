@isTest
public with sharing class BOMDAOTest {
    
    @isTest
    public static void BOMDAOTest(){
       
        Vessel__c vessel = TestUtil.createVessel();
        Date startDate = System.Today();
        Date endDate = System.Today();

        BOMDAO.getBOMByVesselAndDate(vessel.Id, startDate, endDate);
        BOMDAO.getBOMByVesselAndPastDate(vessel.Id, startDate);
        BOMDAO.getBOMById(vessel.Id);
    }
}