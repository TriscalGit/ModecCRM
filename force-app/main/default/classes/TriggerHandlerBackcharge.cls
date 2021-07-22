public with sharing class TriggerHandlerBackcharge extends TriggerHandler{

    public override void beforeInsert(){
        BackchargeBO.getInstance().calculateDollar(Trigger.new);
    }

    public override void beforeUpdate(){
        BackchargeBO.getInstance().calculateDollar(Trigger.new);
    }
}