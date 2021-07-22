public class TriggerHandlerRDO extends TriggerHandler{
    public override void beforeInsert(){
        RDOBO.getInstance().calculatePrioritization(Trigger.new);
        RDOBO.getInstance().fillTanksValues(Trigger.new);
        RDOBO.getInstance().fillMV15ServicesFields(Trigger.new);
    }

    public override void beforeUpdate(){
        RDOBO.getInstance().calculatePrioritization(Trigger.new);
        RDOBO.getInstance().fillTanksValues(Trigger.new);
        RDOBO.getInstance().fillMV15ServicesFields(Trigger.new);
    }

    public override void afterInsert(){
        RDOBO.getInstance().setContractsByVessel(Trigger.new);
        RDOBO.getInstance().callCreateOrUpdateBOM(Trigger.new);
        RDOBO.getInstance().formatTimeFields(Trigger.new);
    }

    public override void afterUpdate(){
        RDOBO.getInstance().recalculateSumFields(Trigger.new);
    }
}