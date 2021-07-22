trigger TriggerWaterCompensation on WaterCompensation__c (before insert, before update, after insert, after update) {
    new TriggerHandlerWaterCompensation().run();
}