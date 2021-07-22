public class TriggerHandlerVesselContract extends TriggerHandler 
{
    public override void afterInsert(){
        VesselContractBO.getInstance().populateDailyRateHistory(Trigger.new, null);
    }

    public override void afterUpdate(){
        VesselContractBO.getInstance().populateDailyRateHistory(Trigger.new,  (Map<Id, VesselContract__c>) Trigger.oldMap);
    }
        
}