public with sharing class LetterGroupVesselAssociationDAO {
    
    public static List<LetterGroupVesselAssociation__c> getLetterGroupVesselById(String idGroup) {
        return [SELECT 
                    Id,
                    Vessel__c
                    FROM
                    LetterGroupVesselAssociation__c
                    WHERE
                    LetterGroup__c =: idGroup];
    }

    public static List<LetterGroupVesselAssociation__c> getLetterGroupVesselById(set<Id> setIdGroup) {
        return [SELECT 
                    Id,
                    VesselShortName__c,
                    Vessel__c
                    FROM
                    LetterGroupVesselAssociation__c
                    WHERE
                    LetterGroup__c IN: setIdGroup];
    }
}