public class TriggerHandlerLVAssociation extends TriggerHandler {
   
    public override void afterInsert(){
        //LVAssociationBO.getInstance().generateLetterCode(Trigger.new);
        LVAssociationBO.getInstance().fillVesselName(trigger.new, null);
    }
    
    public override void afterUpdate(){
        LVAssociationBO.getInstance().fillVesselName(trigger.new, null);
    }

    public override void afterDelete(){
        LVAssociationBO.getInstance().fillVesselName(trigger.new, (Map<Id, LetterVesselAssociation__c>) Trigger.oldMap);
    }
}