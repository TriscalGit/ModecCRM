public with sharing class VesselContractDAO {

    public static List<VesselContract__c> getVesselContractById(Id vesselContractId) {
		return [SELECT
                    Id,
                    ActualDailyRateBRL__c,
                    ActualDailyRateUSD__c,
                    BOMStartDate__c,
                    BOMEndDate__c,
                    Client__c,
                    ContractAnniversary__c,
                    ContractTotalAmountBRL__c,
                    ContractTotalAmountUSD__c,
                    Contracted__c,
                    Contractor__c,
                    EndDate__c,
                    Object__c,
                    StartDate__c,
                    Status__c,
                    Type__c,
                    Vessel__c,
                    VesselShortName__c
				FROM
                    VesselContract__c
				WHERE
                    Id =: vesselContractId];
     }

     public static List<VesselContract__c> getContractByVesselID(String vesselID, String type1){
          return [SELECT 
                    id,
                    Name, 
                    VesselShortName__c 
                    FROM 
                    VesselContract__c 
                    WHERE 
                    Vessel__c =: vesselID
                    AND
                    Type__c =: type1];
     }
     
     public static List<VesselContract__c> getVesselContractByContractNumber(String nrContract, String shortName, String type1){
          return [SELECT 
                    id,
                    Name, 
                    VesselShortName__c 
                    FROM 
                    VesselContract__c 
                    WHERE 
                    Name =: nrContract 
                    AND 
                    VesselShortName__c =: shortName
                    AND
                    Type__c =: type1];
     }

     public static List<VesselContract__c> getVesselContractByIdAndType(String vesselContractId, String type) {
		return [SELECT
                    Id,
                    ActualDailyRateBRL__c,
                    ActualDailyRateUSD__c,
                    BOMStartDate__c,
                    BOMEndDate__c,
                    Client__c,
                    ContractAnniversary__c,
                    ContractTotalAmountBRL__c,
                    ContractTotalAmountUSD__c,
                    Contracted__c,
                    Contractor__c,
                    EndDate__c,
                    Object__c,
                    StartDate__c,
                    Status__c,
                    Type__c,
                    Vessel__c,
                    VesselShortName__c,
                    MealAllowance__c
				FROM
                    VesselContract__c
				WHERE
                    Id =: vesselContractId
                    AND
                    Type__c =: type];
     }

     public static List<VesselContract__c> getMealAllowanceByNumber(String contractNumber){
          return [SELECT
                    Id,
                    ActualDailyRateBRL__c,
                    ActualDailyRateUSD__c,
                    BOMStartDate__c,
                    BOMEndDate__c,
                    Client__c,
                    ContractAnniversary__c,
                    ContractTotalAmountBRL__c,
                    ContractTotalAmountUSD__c,
                    Contracted__c,
                    Contractor__c,
                    EndDate__c,
                    Object__c,
                    StartDate__c,
                    Status__c,
                    Type__c,
                    Vessel__c,
                    VesselShortName__c,
                    MealAllowance__c,
                    Pilot__c
                    FROM
                    VesselContract__c
                    WHERE
                    Name =: contractNumber];
     }
}