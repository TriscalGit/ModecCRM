global class BatchUpdateVesselContractAnniverssary implements Database.Batchable<sObject> {

    global static void init() {
        Database.executeBatch(new BatchUpdateVesselContractAnniverssary());
    }

    global BatchUpdateVesselContractAnniverssary() {

    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query;
        Datetime filterDate = System.today();

        query = 'SELECT Id, ContractAnniversary__c FROM VesselContract__c WHERE ContractAnniversary__c < TODAY';

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<VesselContract__c> lstVesselContract) {
        
        for(VesselContract__c contract : lstVesselContract)
        {
           contract.ContractAnniversary__c = contract.ContractAnniversary__c.addYears(1);
        }

        update lstVesselContract;
    }

    global void finish(Database.BatchableContext BC) {}

}