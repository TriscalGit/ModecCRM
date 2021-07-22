@isTest
public class T_HourlySchedule_TST {

    @isTest
    public static void TestMethod_Schedule(){
        T_HourlySchedule.startJob();
    }
    
    @isTest
    public static void TestMethod_Schedule_Delete(){
        T_HourlySchedule.startJob();
        T_HourlySchedule.deleteJob();
    }
}