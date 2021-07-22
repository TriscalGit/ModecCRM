public with sharing class LetterGroupDAO {
    
    public static List<LetterGroup__c> getLetterGroupById(String idLetterGroup){
        return [SELECT 
                  id,   
                  Comments__c,
                  Deadline__c,
                  ReceiveSendDate__c,
                  RecordType.DeveloperName,
                  RecordType.Name,
                  Source__c,
                  Status__c,
                  Subject__c
                  FROM
                  LetterGroup__c
                  WHERE
                  id =: idLetterGroup];
    }

    public static List<LetterGroup__c> getLetterGroupBySetId(set<Id> idLetterGroup){
        return [SELECT 
                  id, 
                  Vessel__c,  
                  Comments__c,
                  Deadline__c,
                  ReceiveSendDate__c,
                  RecordType.DeveloperName,
                  RecordType.Name,
                  Source__c,
                  Status__c,
                  Subject__c
                  FROM
                  LetterGroup__c
                  WHERE
                  id =: idLetterGroup];
    }
}