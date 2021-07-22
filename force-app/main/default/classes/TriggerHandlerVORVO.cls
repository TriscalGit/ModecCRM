public class TriggerHandlerVORVO extends TriggerHandler 
{
    public override void beforeInsert(){
        VORVOBO.getInstance().fillLetterGroup(Trigger.new);
    }

    public override void beforeUpdate(){
        VORVOBO.getInstance().fillLetterGroup(Trigger.new);
    }
}