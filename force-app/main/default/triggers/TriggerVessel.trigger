trigger TriggerVessel on Vessel__c (before insert, before update, after insert, after update) {
	new TriggerHandlerVessel().run();
}