@isTest
public class TriggerHandlerLGVAssociationTest {
    
    @isTest
    public static void handlerTest()
    {
        LetterGroup__c letterGroup = TestUtil.createLetterGroup();
        Vessel__c vessel = TestUtil.createVessel2();

        LetterGroupVesselAssociation__c letterGroupAssoc = new LetterGroupVesselAssociation__c();
        letterGroupAssoc.LetterGroup__c = letterGroup.Id;
        letterGroupAssoc.Vessel__c = vessel.Id;

        Test.startTest();

        insert letterGroupAssoc;
        update letterGroupAssoc;
               
        Test.stopTest();
    }

    @isTest
    public static void handlerDelete()
    {

        LetterGroup__c letterGroup = TestUtil.createLetterGroup();
        Vessel__c vessel = TestUtil.createVessel2();

        LetterGroupVesselAssociation__c letterGroupAssoc = new LetterGroupVesselAssociation__c();
        letterGroupAssoc.LetterGroup__c = letterGroup.Id;
        letterGroupAssoc.Vessel__c = vessel.Id;
        insert letterGroupAssoc;

        Test.startTest();

        List<LetterGroupVesselAssociation__c> lstAssoc = [SELECT Id, Vessel__c FROM LetterGroupVesselAssociation__c WHERE Id =: letterGroupAssoc.Id];

        delete lstAssoc;
        
        Test.stopTest();
    }

    @isTest
    public static void boDelete()
    {
        LetterGroup__c letterGroup = TestUtil.createLetterGroup();
        Vessel__c vessel = TestUtil.createVessel2();
        List<LetterGroupVesselAssociation__c> lstAssoc = new List<LetterGroupVesselAssociation__c>();
        Map<Id, LetterGroupVesselAssociation__c> mapAssoc = new Map<Id, LetterGroupVesselAssociation__c>();

        LetterGroupVesselAssociation__c letterGroupAssoc = new LetterGroupVesselAssociation__c();
        letterGroupAssoc.LetterGroup__c = letterGroup.Id;
        letterGroupAssoc.Vessel__c = vessel.Id;
        insert letterGroupAssoc;

        lstAssoc.add(letterGroupAssoc);
        mapAssoc.put(letterGroupAssoc.Id, letterGroupAssoc);

        Test.startTest();
        
        LGVAssociationBO.getInstance().FillVesselName(lstAssoc, mapAssoc);
        
        Test.stopTest();
    }
}