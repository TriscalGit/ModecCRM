trigger TriggerWorkOrderLineItem on WorkOrderLineItem (before insert, before update) {
    new TriggerHandlerWorkOrderLineItem().run();
}