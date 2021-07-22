@isTest
public class T_DailySchedule_TST {

    @isTest
    public static void TestMethod_Schedule(){
        T_DailySchedule.startJob();
    }
    
    @isTest
    public static void TestMethod_Schedule_Delete(){
        T_DailySchedule.startJob();
        T_DailySchedule.deleteJob();
    }
}