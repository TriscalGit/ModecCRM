public with sharing class ContractDailyRateHistBO {

    private static final ContractDailyRateHistBO instance = new ContractDailyRateHistBO();

	public static ContractDailyRateHistBO getInstance() {
		return instance;
    }

    public void atualizarTaxasBOM(List<ContractDailyRateHistory__c> lstDailyRateHistory)
    {
        List<ContractDailyRateHistory__c> lstVesselContractDetails = new List<ContractDailyRateHistory__c>();
        List<BOM__c> lstBOM = new List<BOM__c>();
        List<BOM__c> lstBOMUpdate = new List<BOM__c>();
        Set<Id> setIds = new Set<Id>();
        Date bomStartDate;
        Date bomEndDate;
        Id vesselId;
        String contractType;
        String rdo;


        for(ContractDailyRateHistory__c rateHistory : lstDailyRateHistory){
            setIds.add(rateHistory.Id);
        }

        lstVesselContractDetails = ContractDailyRateHistoryDAO.getInfosByContractDailyRateHistory(setIds);

        for(ContractDailyRateHistory__c contractRate : lstVesselContractDetails){
            bomStartDate = contractRate.VesselContract__r.BOMStartDate__c;
            bomEndDate = contractRate.VesselContract__r.BOMEndDate__c;
            vesselId = contractRate.VesselContract__r.Vessel__c;
            contractType = contractRate.VesselContract__r.Type__c;
        }

        lstBOM = BOMDAO.getBOMByVesselAndDate(vesselId, bomStartDate, bomEndDate);

        for(BOM__c bom : lstBOM){
            if(contractType == 'Services'){
                BOM__c newBOM = new BOM__c(
                    Id = bom.Id,
                    DailyRateBRL__c = lstVesselContractDetails[0].DailyRate__c);

                    lstBOMUpdate.add(newBOM);
            }

            if(contractType == 'Charter'){
                BOM__c newBOM = new BOM__c(
                    Id = bom.Id,
                    DailyRateUSD__c = lstVesselContractDetails[0].DailyRate__c);

                    lstBOMUpdate.add(newBOM);
            }
        }

        if(!lstBOMUpdate.isEmpty()){
            update lstBOMUpdate;
        }

        if(!lstBOMUpdate.isEmpty()){
            List<RDO__c> rdoRegister = RDODAO.getRDOsByIdBOM(lstBOMUpdate[0].Id, 'Inactive');
            
            if(rdoRegister != null && !rdoRegister.isEmpty()){
                rdo = rdoRegister[0].Id;
            }

            RDOBO.getInstance().createOrUpdateBOM(rdo);
        }
    }
}