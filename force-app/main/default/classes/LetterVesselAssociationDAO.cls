public with sharing class LetterVesselAssociationDAO {
    
    public static List<LetterVesselAssociation__c> getLetterVesselById(String idLetter) {
        return [SELECT 
                    Id,
                    Vessel__c,
                    VesselShortName__c
                    FROM
                    LetterVesselAssociation__c
                    WHERE
                    Letter__c =: idLetter];
    }
}