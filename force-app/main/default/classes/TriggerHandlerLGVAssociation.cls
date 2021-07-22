public class TriggerHandlerLGVAssociation extends TriggerHandler {
   
    public override void afterInsert(){
        LGVAssociationBO.getInstance().FillVesselName(trigger.new, null);
    }
   
    public override void afterDelete(){
        LGVAssociationBO.getInstance().FillVesselName(trigger.new, (Map<Id, LetterGroupVesselAssociation__c>) Trigger.oldMap);
    }
}