public class TriggerHandlerWorkOrderLineItem extends TriggerHandler 
{    
    public override void beforeUpdate(){
        WorkOrderLineItemBO.getInstance().updateFields(trigger.new, (Map<Id, WorkORderLIneItem>)trigger.oldMap);
    }
    public override void beforeInsert(){
        WorkOrderLineItemBO.getInstance().updateFields(trigger.new, null);
    }
}