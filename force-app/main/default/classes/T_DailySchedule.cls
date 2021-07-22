global class T_DailySchedule implements Schedulable {

    global void execute(SchedulableContext sc){
        T_WarningApp.warningEmailAlertToSuppliers();
    }
    
    public static void startJob() {
        if(!Test.isRunningTest()){
            System.schedule('T_DailySchedule', '0 0 4 * * ?', new T_DailySchedule());
        } else {
            System.schedule('T_DailySchedule_TST', '0 0 4 * * ?', new T_DailySchedule());
        }
    }
    
    public static void deleteJob(){
        List<CronTrigger> jobs = [select id from CronTrigger where CronJobDetail.Name like 'T_DailySchedule%'];
        for(CronTrigger job: jobs){
            System.abortJob(job.Id);
        }
    }
}