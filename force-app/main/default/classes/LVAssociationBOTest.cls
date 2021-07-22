@isTest
public with sharing class LVAssociationBOTest {
   
    @isTest
    public static void lVAssociationBONoMapTest()
    {
        List<LetterVesselAssociation__c> lstLVAssoc = new List<LetterVesselAssociation__c>();

        Test.startTest();

        LetterVesselAssociation__c lVAssoc = TestUtil.createLVAssociation();
        lstLVAssoc.add(lVAssoc);
        LVAssociationBO.getInstance().generateLetterCode(lstLVAssoc);
        LVAssociationBO.getInstance().fillVesselName(lstLVAssoc, null);

        Test.stopTest();
    }

    @isTest
    public static void lVAssociationBOWithMapTest ()
    {
        Map<Id, LetterVesselAssociation__c> mapLVAssoc = new Map<Id, LetterVesselAssociation__c>();
        List<LetterVesselAssociation__c> lstLVAssoc = new List<LetterVesselAssociation__c>();

        Test.startTest();

        LetterVesselAssociation__c lVAssoc = TestUtil.createLVAssociation();
        lstLVAssoc.add(lVAssoc);
        mapLVAssoc.put(lVAssoc.Id, lVAssoc);

        LVAssociationBO.getInstance().fillVesselName(lstLVAssoc, mapLVAssoc);

        delete lstLVAssoc;

        Test.stopTest();
    }
}