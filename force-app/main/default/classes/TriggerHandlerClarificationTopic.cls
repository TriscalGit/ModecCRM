public class TriggerHandlerClarificationTopic extends TriggerHandler {
	
	public override void beforeInsert() {
		ClarificationTopicBO.getInstance().fillClarification(trigger.new);
	}
}