trigger TriggerOccurrence on Occurrences__c (before insert, before update, after insert, after update) {
    new TriggerHandlerOccurrence().run();
}