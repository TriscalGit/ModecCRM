trigger TriggerRDO on RDO__c (before insert, before update, after insert, after update) {
    new TriggerHandlerRDO().run();
}