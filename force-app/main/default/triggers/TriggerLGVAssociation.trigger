trigger TriggerLGVAssociation on LetterGroupVesselAssociation__c (before insert, before update, after insert, after update, after delete) {
	new TriggerHandlerLGVAssociation().run();
}