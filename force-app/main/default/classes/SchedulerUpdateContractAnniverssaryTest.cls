@isTest
public with sharing class SchedulerUpdateContractAnniverssaryTest {
    
    @isTest
    public static void schedulerUpdateContractAnniverssaryTest() {
        
        Test.startTest();
        SchedulerUpdateContractAnniverssary sh1 = new SchedulerUpdateContractAnniverssary();
        String sch = '0 0 2 * * ?';
        system.schedule('Test Anniverssary', sch, sh1);
        Test.stopTest();
    }
}