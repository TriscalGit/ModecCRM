global class T_HourlySchedule implements Schedulable {

    global void execute(SchedulableContext sc){
        T_WarningApp.warningEmailAlertToSuppliers();
    }
    
    public static void startJob() {
        if(!Test.isRunningTest()){
            System.schedule('T_HourlySchedule', '0 0 * * * ?', new T_HourlySchedule());
        } else {
            System.schedule('T_HourlySchedule_TST', '0 0 * * * ?', new T_HourlySchedule());
        }
    }
    
    public static void deleteJob(){
        List<CronTrigger> jobs = [select id from CronTrigger where CronJobDetail.Name like 'T_HourlySchedule%'];
        for(CronTrigger job: jobs){
            System.abortJob(job.Id);
        }
    }
}