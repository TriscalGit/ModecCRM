/**
 * @description       :
 * @author            : Gabriel Uchoa
 * @group             :
 * @last modified on  : 04-20-2021
 * @last modified by  : Gabriel Uchoa
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   04-20-2021   Gabriel Uchoa   Restruturação do Schedule - Schedule generico
 **/
public class T_ThreeMinutesSchedule implements schedulable {
    
    public void execute(SchedulableContext paSchedulableContext) {
        Database.executeBatch(new T_MODEC_BAT_UpdateFilesVisibility(), 10);
        T_UpdateFilesVisibility.manageShareFilesVisibility();
    }
    
    public static void startJob() {
        Datetime start = Datetime.newInstanceGmt(Date.today().Year(), Date.today().Month(), Date.today().Day(), 0, 0, 0);
        Integer y = 1;
        If(Test.isRunningTest()){
            y = 20;
        }
        for(Integer x = y; x<=20; x++){
            String minuto;
            IF(String.valueOF(start.minute()).length() == 1){minuto = '0'+String.valueOF(start.minute());}else{minuto = String.valueOF(start.minute());}
            if(!Test.isRunningTest()){
                System.schedule('T_ThreeMinutesSchedule_'+minuto, '0 '+String.valueOF(start.minute())+' * * * ?', new T_ThreeMinutesSchedule());
            } else {
                System.schedule('T_ThreeMinutesSchedule_Test_'+minuto, '0 '+String.valueOF(start.minute())+' * * * ?', new T_ThreeMinutesSchedule());
            }
            Start = start.addMinutes(3);
        }
    }
    
    public static void deleteJob(){
        List<CronTrigger> jobs = [select id from CronTrigger where CronJobDetail.Name like 'T_ThreeMinutesSchedule%'];
        for(CronTrigger job: jobs){
            System.abortJob(job.Id);
        }
    }
}