trigger TriggerClaim on Claim__c (before insert, before update, after insert, after update) {
    new TriggerHandlerClaim().run();
}