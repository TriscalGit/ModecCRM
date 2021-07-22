@isTest
public with sharing class SchedulerUpdateBOMStartDateTest {
    
    @isTest
    public static void schedulerUpdateBOMStartDateTest() {
        
        Test.startTest();
        SchedulerUpdateBOMStartDate sh1 = new SchedulerUpdateBOMStartDate();
        String sch = '0 0 2 * * ?';
        //system.schedule('Test Contract', sch, sh1);
        Test.stopTest();
    }
}