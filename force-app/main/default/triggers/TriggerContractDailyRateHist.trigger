trigger TriggerContractDailyRateHist on ContractDailyRateHistory__c (before insert, before update, after insert, after update) {
    new TriggerHandlerContractDailyRateHist().run();
}