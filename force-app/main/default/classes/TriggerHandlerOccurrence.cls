public class TriggerHandlerOccurrence extends TriggerHandler{
    public override void afterInsert(){
        OccurrenceBO.getInstance().fillLastOccurrence(trigger.new);
    }
    
    public override void afterUpdate(){
        OccurrenceBO.getInstance().fillLastOccurrence(trigger.new);
    }
}