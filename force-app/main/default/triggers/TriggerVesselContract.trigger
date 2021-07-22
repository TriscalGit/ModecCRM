trigger TriggerVesselContract on VesselContract__c (before insert, before update, after insert, after update) {
    new TriggerHandlerVesselContract().run();
}