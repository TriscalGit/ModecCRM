global class SchedulerUpdateBOMStartDate implements Schedulable {

    private static String name = 'Update BOM Start Date on Vessel Contract';
    private static String expressionCron = '0 0 0 * * ?';

    public static void schedule() {
        System.schedule(name, expressionCron, new SchedulerUpdateBOMStartDate());
    }

    global void execute(SchedulableContext sc) {
        BatchUpdateBOMStartDate.init();
    }
}