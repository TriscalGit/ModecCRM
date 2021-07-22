trigger TriggerClarificationTopic on ClarificationTopic__c (before insert) {
	new TriggerHandlerClarificationTopic().run();
}