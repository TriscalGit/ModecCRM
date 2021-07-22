global class SchedulerUpdateContractAnniverssary implements Schedulable {

    private static String name = 'Update Vessel Contract Anniverssary';
    private static String expressionCron = '0 0 0 * * ?';

    public static void schedule() {
        System.schedule(name, expressionCron, new SchedulerUpdateContractAnniverssary());
    }

    global void execute(SchedulableContext sc) {
        BatchUpdateVesselContractAnniverssary.init();
    }
}