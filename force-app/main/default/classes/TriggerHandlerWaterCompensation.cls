public class TriggerHandlerWaterCompensation extends TriggerHandler{

    public override void afterInsert(){
        WaterCompensationBO.getInstance().updateRDOs(Trigger.new);
    }

    public override void afterUpdate(){
        WaterCompensationBO.getInstance().updateRDOs(Trigger.new);
    }
}