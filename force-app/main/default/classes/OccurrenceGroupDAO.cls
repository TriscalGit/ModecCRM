public with sharing class OccurrenceGroupDAO {
    
    
    public static List<OccurrenceGroup__c> getOccurrenceGroupById(set<Id> idOccurrenceGroup){
        return [SELECT 
                  id,   
                  LastOccurrence__c
                  FROM
                  OccurrenceGroup__c
                  WHERE
                  id =: idOccurrenceGroup];
    }
}