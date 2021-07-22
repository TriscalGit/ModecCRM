trigger TriggerVORVO on VORVO__c (before insert, before update, after insert, after update) {
    new TriggerHandlerVORVO().run();
}