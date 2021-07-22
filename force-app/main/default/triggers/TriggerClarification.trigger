trigger TriggerClarification on Clarification__c (before update) {
    new TriggerHandlerClarification().run();
}