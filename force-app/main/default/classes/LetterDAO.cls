public with sharing class LetterDAO {
    
    public static List<Letter__c> getLetterById(String idLetter){
        return [SELECT 
                  id,   
                  AnswerNeeded__c,
                  Comments__c,
                  Deadline__c,
                  LetterGroup__c,
                  Penalty__c,
                  ReceivedDate__c,
                  RecordType.DeveloperName,
                  RecordType.Name,
                  SendDate__c,
                  Status__c,
                  Subject__c,
                  Vessel__c
                  FROM
                  Letter__c
                  WHERE
                  id =: idLetter];
    }
}