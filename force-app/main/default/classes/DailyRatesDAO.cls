public with sharing class DailyRatesDAO {
    
    public static List<DailyRates__c> getDailyRatesByRDO(set<ID> idRDO){
       return [SELECT ID,
                      RDO__c,
                      Description__c, 
                      PercentReduction__c 
                      FROM 
                      DailyRates__c 
                      WHERE 
                      RDO__c =: idRDO];
    }

    public static List<DailyRates__c> getDailyRatesBySetRDO(set<ID> idRDO){
        return [SELECT ID,
                       RDO__c,
                       Description__c, 
                       PercentReduction__c 
                       FROM 
                       DailyRates__c 
                       WHERE 
                       RDO__c IN: idRDO];
     }

}