@isTest
public with sharing class VesselDAOTest {
    
    @isTest
    public static void VesselDAOTest(){

        String shortName = 'Teste';
        
        VesselDAO.getInstance().getVesselbyShortName(shortName);      

    }
}