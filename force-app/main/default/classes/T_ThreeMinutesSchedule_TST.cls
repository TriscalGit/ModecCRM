@isTest
public class T_ThreeMinutesSchedule_TST {       
    
    @isTest
    public static void TestMethod_Schedule(){
        T_ThreeMinutesSchedule.startJob();
    }
    
    @isTest
    public static void TestMethod_Schedule_Delete(){
        T_ThreeMinutesSchedule.startJob();
        T_ThreeMinutesSchedule.deleteJob();
    }
    
}