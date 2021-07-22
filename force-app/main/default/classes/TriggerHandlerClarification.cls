public without sharing class TriggerHandlerClarification extends TriggerHandler 
{
    public override void beforeUpdate(){
        ClarificationBO.getInstance().finalComments(Trigger.new, (Map<Id,Clarification__c>) Trigger.oldMap);
    }
}