public with sharing class ClarificationDAO {
   public static Clarification__c getById(String idCla){
        List<Clarification__c> lst = getById(new Set<String> {idCla});
        if(lst.size() > 0) return lst[0];
        else return null;
   }
   public static List<Clarification__c> getById(Set<String> ids){
        return [SELECT OwnerId, 
                        Owner.Email ,
                        Name,
                        NAM__c
                FROM Clarification__c
                WHERE ID IN : ids];
   }
}