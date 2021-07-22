public without sharing class NamDAO {
    public static NAM__c getById(String idNAM){
        List<NAM__c> lst = getById(new Set<String> {idNAM});
        if(lst.size() > 0) return lst[0];
        else return null;
    }
    public static List<NAM__c> getById(List<String> lstIds){
        Set<String> setString = new Set<String>(lstIds);
        return getById(setString);
    }
    public static List<NAM__c> getById(Set<String> idNAM){

        return [SELECT OwnerId, 
                        Owner.Email ,
                        ActualAmountTotal__c,
                        Owner.Name,
                        Subject__c,
                        Name,
                        Vessel__r.WOAttention__c,
                        Vessel__r.WOAttentionMINC__c,
                        MdbAmount__c,
                        MIIAmount__c,
						MINCAmount__c,
						Description__c,
						BRLAmount__c,
						ClosedOutClarificationCreated__c,
						TypeEvent__c,
						ActionTaken__c,
                        RootCause__c,
                        Phase__c,
                        WorkOrderPrimaryNumber__c,
                        Status__c,
                        (SELECT 
                            Id,
                            WorkOrder__c,
                            Responsible__c,
                            PortionAmount__c,
                            Service__c,
                            Material__c,
                            TotalBRL__c,
                            // TotalAmountWithoutTax__c,
                            // TotalAmountWithTax__c,
                            TotalAmount__c,
                            // MIITotal__c,
                            // MINCTotal__c
                            ContractTerm__c                        
                         FROM WorkOrders__r),
                        (SELECT 
							Id,
							Partner__c,
							Status__c,
							Type__c
                         FROM Clarifications__r),
                         (SELECT
                            Id,
                            Status__c,
                            Type__c,
                            Description__c
                         FROM TechTeamsSupports__r)
                FROM NAM__c 
                WHERE Id in: idNAM];
    }
    public static List<NAM__c> getByName(Set<String> setNames){
        return [
            SELECT  
                NAME,
                NameWithoutRevision__c
            FROM 
                NAM__c
            WHERE 
                NameWithoutRevision__c IN : setNames
        ];
    }
    public static AggregateResult[] getByYear(String year, Set<String> setVessel){

        return [SELECT 
                    Count(NAME) total,
                    Vessel__r.ShortName__c,
                    Vessel__c,
                    Year__c
                FROM 
                    NAM__c 
                WHERE 
                    Year__c =: year
                AND Vessel__c in : setVessel
                GROUP BY 
                    Year__c,
                    Vessel__c,
                    Vessel__r.ShortName__c];
    }
}