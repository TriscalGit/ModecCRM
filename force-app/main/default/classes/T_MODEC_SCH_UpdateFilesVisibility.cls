/**
 * @description       :
 * @author            : Rafael Hadama
 * @group             :
 * @last modified on  : 07-17-2020
 * @last modified by  : Rafael Hadama
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   07-16-2020   Rafael Hadama   Initial Version
 * 1.1   28-10-2020   Gabriel Uchoa   Metodos novos startJob and deleteJob
 **/
public class T_MODEC_SCH_UpdateFilesVisibility implements schedulable {
    public void execute(SchedulableContext paSchedulableContext) {
        //T_SDK_DebugLog.EscreverLog('Iniciando Schedule Enviar Anexos');
        Id batchUpdateFiles = Database.executeBatch(new T_MODEC_BAT_UpdateFilesVisibility(), 10);
        system.debug('Batch process id:' + batchUpdateFiles);
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
                System.schedule('T_MODEC_SCH_UpdateFilesVisibility_'+minuto, '0 '+String.valueOF(start.minute())+' * * * ?', new T_MODEC_SCH_UpdateFilesVisibility());
            } else {
                System.schedule('T_MODEC_SCH_UpdateFilesVisibility_Test_'+minuto, '0 '+String.valueOF(start.minute())+' * * * ?', new T_MODEC_SCH_UpdateFilesVisibility());
            }
            Start = start.addMinutes(3);
        }
    }
    
    public static void deleteJob(){
        List<CronTrigger> jobs = [select id from CronTrigger where CronJobDetail.Name like 'T_MODEC_SCH_UpdateFilesVisibility%'];
        for(CronTrigger job: jobs){
            System.abortJob(job.Id);
        }
    }
}