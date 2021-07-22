@isTest
public with sharing class LetterGroupVesselAssociationDAOTest {
    
    @isTest
    public static void daoTest()
    {
        LetterGroup__c letterGroup = TestUtil.createLetterGroup();
        Vessel__c vessel = TestUtil.createVessel2();

        LetterGroupVesselAssociation__c letterGroupAssoc = new LetterGroupVesselAssociation__c();
        letterGroupAssoc.LetterGroup__c = letterGroup.Id;
        letterGroupAssoc.Vessel__c = vessel.Id;

        Test.startTest();

        Set<Id> setId = new Set<Id>();
        insert letterGroupAssoc;

        setId.add(letterGroupAssoc.Id); 
        LetterGroupVesselAssociationDAO.getLetterGroupVesselById(letterGroupAssoc.Id);
        LetterGroupVesselAssociationDAO.getLetterGroupVesselById(setId);
        
        Test.stopTest();
    }
}