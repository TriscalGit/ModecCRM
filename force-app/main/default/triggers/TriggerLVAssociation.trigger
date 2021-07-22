trigger TriggerLVAssociation on LetterVesselAssociation__c (before insert, before update, after insert, after update, after delete) {
	new TriggerHandlerLVAssociation().run();
}