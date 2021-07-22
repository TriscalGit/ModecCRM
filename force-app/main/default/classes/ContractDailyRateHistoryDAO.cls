public with sharing class ContractDailyRateHistoryDAO {
    
    public static List<ContractDailyRateHistory__c> getContractDailyRateHistoryByContractAndBOMDate(Id idContract, Date endDate) {
        return [SELECT 
                    Id,
                    Comments__c,
                    DailyRate__c,
                    EndDate__c,
                    EscalationIndex__c,
                    Name,
                    Index2__c,
                    Index3__c,
                    Index1__c,
                    StartDate__c,
                    VesselContract__c
                    FROM
                    ContractDailyRateHistory__c
                    WHERE
                    VesselContract__c =: idContract
                    AND
                    StartDate__c <=: endDate
                    AND 
                    EndDate__c >=: endDate];
    }

    public static List<ContractDailyRateHistory__c> getInfosByContractDailyRateHistory(Set<Id> setIds){
        return [SELECT 
                    Id,
                    Comments__c,
                    DailyRate__c,
                    EndDate__c,
                    EscalationIndex__c,
                    Name,
                    Index2__c,
                    Index3__c,
                    Index1__c,
                    StartDate__c,
                    VesselContract__c,
                    VesselContract__r.Name,
                    VesselContract__r.Type__c,
                    VesselContract__r.BOMStartDate__c,
                    VesselContract__r.BOMEndDate__c,
                    VesselContract__r.VesselShortName__c,
                    VesselContract__r.Vessel__c
                    FROM
                    ContractDailyRateHistory__c
                    WHERE
                    Id IN: setIds];
    }
}