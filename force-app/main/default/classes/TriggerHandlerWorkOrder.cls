public with sharing class TriggerHandlerWorkOrder extends TriggerHandler 
{
    public override void beforeInsert(){
        WorkOrderBO.getInstance().beforeInsertWO(Trigger.new);
    }
    public override void afterInsert(){
        WorkOrderBO.getInstance().summarizingNAMValues(Trigger.new);
        WorkOrderBO.getInstance().cloneWO(Trigger.new);
        WorkOrderBO.getInstance().fillWOPrimaryNumberInNAM(Trigger.new);
    }
    public override void afterUpdate(){
        LogHistoryBO.createLog('WorkOrder', 'Update', Trigger.new, Trigger.oldMap);
        WorkOrderBO.getInstance().summarizingNAMValues(Trigger.new);
    }
    public override void beforeUpdate(){
        WorkOrderBO.getInstance().generateNewPdf(Trigger.new, (Map<Id, WorkOrder>) Trigger.oldMap);
    }
}