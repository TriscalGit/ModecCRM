public with sharing class VesselContractBO {
    
    private static final VesselContractBO instance = new VesselContractBO();

	public static VesselContractBO getInstance() {
		return instance;
    }

    public void populateDailyRateHistory(List<VesselContract__c> triggerNew, Map<Id, VesselContract__c> oldMap){

        List<ContractDailyRateHistory__c> historyToInsert = new List<ContractDailyRateHistory__c>();      

        for(VesselContract__c lst : triggerNew){

            if(oldMap == null){

                if(lst.ActualDailyRateUSD__c != null && lst.ActualDailyRateUSD__c > 0 && lst.Type__c == 'Charter'){
                    ContractDailyRateHistory__c dailyRateHistory = new ContractDailyRateHistory__c();
                    dailyRateHistory.VesselContract__c = lst.Id;
                    dailyRateHistory.DailyRate__c =  lst.ActualDailyRateUSD__c;
                    dailyRateHistory.StartDate__c = System.today();
                    
                    historyToInsert.add(dailyRateHistory);
                }
    
                if(lst.ActualDailyRateBRL__c != null && lst.ActualDailyRateBRL__c > 0 && lst.Type__c == 'Services'){
                    ContractDailyRateHistory__c dailyRateHistoryBRL = new ContractDailyRateHistory__c();
                    dailyRateHistoryBRL.VesselContract__c = lst.Id;
                    dailyRateHistoryBRL.DailyRate__c = lst.ActualDailyRateBRL__c;
                    dailyRateHistoryBRL.StartDate__c = System.today();
                    
                    historyToInsert.add(dailyRateHistoryBRL);
                }
            } else{

                Decimal rateUSDOldMap = oldMap.get(lst.Id).ActualDailyRateUSD__c;
                Decimal rateBRLOldMap = oldMap.get(lst.Id).ActualDailyRateBRL__c;

                if(lst.ActualDailyRateUSD__c != rateUSDOldMap && lst.ActualDailyRateUSD__c != null && lst.ActualDailyRateUSD__c > 0 && lst.Type__c == 'Charter'){
                    ContractDailyRateHistory__c dailyRateHistory = new ContractDailyRateHistory__c();
                    dailyRateHistory.VesselContract__c = lst.Id;
                    dailyRateHistory.DailyRate__c =  lst.ActualDailyRateUSD__c;
                    dailyRateHistory.StartDate__c = System.today();
                    
                    historyToInsert.add(dailyRateHistory);
                }

                if(lst.ActualDailyRateBRL__c != rateBRLOldMap && lst.ActualDailyRateBRL__c != null && lst.ActualDailyRateBRL__c > 0 && lst.Type__c == 'Services'){
                    ContractDailyRateHistory__c dailyRateHistoryBRL = new ContractDailyRateHistory__c();
                    dailyRateHistoryBRL.VesselContract__c = lst.Id;
                    dailyRateHistoryBRL.DailyRate__c = lst.ActualDailyRateBRL__c;
                    dailyRateHistoryBRL.StartDate__c = System.today();
                    
                    historyToInsert.add(dailyRateHistoryBRL);
                }
            }
        }

        insert historyToInsert;
    }
}