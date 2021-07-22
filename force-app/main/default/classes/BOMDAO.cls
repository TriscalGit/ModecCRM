public with sharing class BOMDAO {
    
    public static List<BOM__c> getBOMByVesselAndDate(Id idVessel, Date startDate, Date endDate) {
        return [SELECT 
                    Id,
                    EndDate__c,
                    Observations__c,
                    RDOsDailyRateSum__c,
                    ReferenceMonth__c,
                    RevenueCharter__c,
                    RevenueServices__c,
                    RMCharterAmountUSD__c,
                    RMCharterNumber__c,
                    RMServicesAmountBRL__c,
                    RMServicesNumber__c,
                    StartDate__c,
                    Vessel__c,
                    VesselShortName__c,
                    SumDailyRates__c,
                    SumDieselConsumed__c,
                    TotalLossesBRLAuto__c,
                    TotalLossesUSDAuto__c,
                    DailyRateLosses__c
                    FROM
                    BOM__c
                    WHERE
                    Vessel__c =: idVessel
                    AND
                    StartDate__c =: startDate
                    AND 
                    EndDate__c =: endDate];
    }

    public static List<BOM__c> getBOMByVesselAndPastDate(Id idVessel, Date pastDate) {
        return [SELECT 
                    Id,
                    EndDate__c,
                    Observations__c,
                    RDOsDailyRateSum__c,
                    ReferenceMonth__c,
                    RevenueCharter__c,
                    RevenueServices__c,
                    RMCharterAmountUSD__c,
                    RMCharterNumber__c,
                    RMServicesAmountBRL__c,
                    RMServicesNumber__c,
                    StartDate__c,
                    Vessel__c,
                    VesselShortName__c,
                    TotalLossesBRLAuto__c,
                    TotalLossesUSDAuto__c
                    FROM
                    BOM__c
                    WHERE
                    Vessel__c =: idVessel
                    AND
                    StartDate__c <=: pastDate
                    AND 
                    EndDate__c >=: pastDate];
    }

    public static List<BOM__c> getBOMById(String idBOM) {
        return [SELECT 
                    Id,
                    EndDate__c,
                    DailyRateBRL__c,
                    DailyRateUSD__c,
                    Observations__c,
                    RDOsDailyRateSum__c,
                    ReferenceMonth__c,
                    RevenueCharter__c,
                    RevenueServices__c,
                    RMCharterAmountUSD__c,
                    RMCharterNumber__c,
                    RMServicesAmountBRL__c,
                    RMServicesNumber__c,
                    StartDate__c,
                    Vessel__c,
                    VesselShortName__c,
                    SumDailyRates__c,
                    SumDieselConsumed__c,
                    TotalLossesBRLAuto__c,
                    TotalLossesUSDAuto__c,
                    TotalReductionIUGAAuto__c,
                    TotalReductionOffloadingdDelayAuto__c,
                    TotalReductionPartialShutdownAuto__c,
                    TotalReductionShutdownAuto__c,
                    DailyRateLosses__c,
                    TotalReductionTotalWIStopAuto__c,
                    TotalReductionWIPartialStopAuto__c,
                    N__c,
                    TotalDailyRateLossesServices__c
                    FROM
                    BOM__c
                    WHERE
                    Id =: idBOM];
    }
}