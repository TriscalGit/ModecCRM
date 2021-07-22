public class TriggerHandlerVessel extends TriggerHandler 
{
    public override void afterInsert(){
        VesselBO.getInstance().populateVesselClientHistory(Trigger.new, null);
    }

    public override void afterUpdate(){
        VesselBO.getInstance().populateVesselClientHistory(Trigger.new, (Map<Id, Vessel__c>) Trigger.oldMap);
    }
}