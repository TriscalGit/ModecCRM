public class TriggerHandlerLetter extends TriggerHandler
{
    public override void afterInsert(){
        LetterBO.getInstance().createVesselAssociations(Trigger.new);
        LetterBO.getInstance().updateDeadlineLetterGroup(Trigger.new);
    }

    public override void afterUpdate(){
        //LetterBO.getInstance().createVesselAssociations(Trigger.new);
    }
}