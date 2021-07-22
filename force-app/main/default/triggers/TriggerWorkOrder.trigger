trigger TriggerWorkOrder on WorkOrder (before insert, after insert, after update, before update, after delete) {
    new TriggerHandlerWorkOrder().run();
}