trigger TriggerDailyRates on DailyRates__c (before insert, before update, after insert, after update) {
	new TriggerHandlerDailyRates().run();
}