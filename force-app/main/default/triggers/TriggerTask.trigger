trigger TriggerTask on Task (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        new TaskBO().createMultipleUsers(Trigger.new);
    }
}