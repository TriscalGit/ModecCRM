trigger TriggerBackcharge on Backcharge__c (before insert, before update, after insert, after update) {
    new TriggerHandlerBackcharge().run();
}