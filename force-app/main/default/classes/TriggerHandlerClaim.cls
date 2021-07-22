public class TriggerHandlerClaim extends TriggerHandler 
{
    public override void beforeInsert(){
        ClaimBO.getInstance().calculateDollar(Trigger.new);
        ClaimBO.getInstance().fillLetterGroup(Trigger.new);
    }

    public override void beforeUpdate(){
        ClaimBO.getInstance().calculateDollar(Trigger.new);
        ClaimBO.getInstance().fillLetterGroup(Trigger.new);
    }

    public override void afterInsert(){
        ClaimBO.getInstance().createRDOAssociation(Trigger.new);
    }
}