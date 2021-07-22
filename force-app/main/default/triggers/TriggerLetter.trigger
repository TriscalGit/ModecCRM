trigger TriggerLetter on Letter__c (before insert, before update, after insert, after update) {
    new TriggerHandlerLetter().run();
}