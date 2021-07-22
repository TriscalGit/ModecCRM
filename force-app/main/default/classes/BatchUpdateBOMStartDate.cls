global class BatchUpdateBOMStartDate implements Database.Batchable<sObject> {

    private static final BatchUpdateBOMStartDate instance = new BatchUpdateBOMStartDate();

    public static BatchUpdateBOMStartDate getInstance() {
		return instance;
    }

    global static void init() {
        Database.executeBatch(new BatchUpdateBOMStartDate(), 2);
    }

    global BatchUpdateBOMStartDate() {

    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query;
        Datetime filterDate = System.today();

        query = 'SELECT Id, BOMStartDate__c, BOMEndDate__c FROM VesselContract__c WHERE BOMEndDate__c < TODAY';

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<VesselContract__c> lstVesselContract) {
        
        for(VesselContract__c contract : lstVesselContract)
        {
            contract.BOMStartDate__c = System.today();
        }

        update lstVesselContract;
    }

    global void finish(Database.BatchableContext BC) {}

}