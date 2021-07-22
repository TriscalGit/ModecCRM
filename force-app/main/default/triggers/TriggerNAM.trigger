trigger TriggerNAM on NAM__c (before insert, before update, after insert, after update) {
     new TriggerHandlerNAM().run();
}