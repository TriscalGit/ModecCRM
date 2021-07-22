@isTest
public with sharing class WorkOrderBOTest {

    @TestSetup
    static void mincAcc(){
        Account minc = AccountFactory.insertAcc(Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId(), 'MINC');
    }
    
    @isTest static void cloneWOTest() {
        Test.startTest();
        NAMFactory.createExchange();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');        
        WorkOrder wo = WorkOrderFactory.createWO(nam, 'MdB');
        WorkOrderLineItem woItem1 = WorkOrderFactory.createWOLineItem(wo, 1000);
        WorkOrderLineItem woItem2 = WorkOrderFactory.createWOLineItem(wo, 1000);
        WorkOrderLineItem woItem3 = WorkOrderFactory.createWOLineItem(wo, 1000);

        WorkOrder woClone = new WorkOrder(
            ClonedWO__c = wo.Id
        );

        insert woClone;

        Test.stopTest();

        WorkOrder w = [SELECT Id FROM WorkOrder WHERE ClonedWO__c =: wo.Id];
        List<WorkOrderLineItem> woliLst = [SELECT Id FROM WorkOrderLineItem WHERE WorkOrderId =: w.Id];

        System.assertEquals(3, woliLst.size());
    }

    @isTest static void summarizingNAMValuesTest(){
        Test.startTest();
        NAMFactory.createExchange();
        Vessel__c vessel = VesselFactory.createVessel();
        //Mdb Cenario
        NAM__c namMdB = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');        
        WorkOrder woMdB = WorkOrderFactory.createWO(namMdB, 'MdB');
        WorkOrderLineItem woItemMdb = WorkOrderFactory.createWOLineItem(woMdB, 1000);

        //MII cenario
        NAM__c namMII = NAMFactory.createNAM(vessel, 'NAM-MV24-20-002');        
        WorkOrder woMII = WorkOrderFactory.createWO(namMII, 'MII');
        WorkOrderLineItem woItemMII = WorkOrderFactory.createWOLineItem(woMII, 2000);

        //MINC cenario
        NAM__c namMINC = NAMFactory.createNAM(vessel, 'NAM-MV24-20-003');        
        WorkOrder woMINC = WorkOrderFactory.createWO(namMINC, 'MINC');
        WorkOrderLineItem woItemMINC = WorkOrderFactory.createWOLineItem(woMINC, 3000);
        Test.stopTest();

        Set<String> setNAMIds = new Set<String> {namMdB.Id, namMII.Id, namMINC.Id};
        List<NAM__c> lstNAM = NamDAO.getById(setNAMIds);

        System.debug('lstNAM[0].MdbAmount__c >> '+lstNAM[0].MdbAmount__c);
        System.debug('lstNAM[1].MdbAmount__c >> '+lstNAM[1].MdbAmount__c);
        System.debug('lstNAM[2].MdbAmount__c >> '+lstNAM[2].MdbAmount__c);

        System.debug('lstNAM[0].MIIAmount__c >> '+lstNAM[0].MIIAmount__c);
        System.debug('lstNAM[1].MIIAmount__c >> '+lstNAM[1].MIIAmount__c);
        System.debug('lstNAM[2].MIIAmount__c >> '+lstNAM[2].MIIAmount__c);

        System.debug('lstNAM[0].MINCAmount__c >> '+lstNAM[0].MINCAmount__c);
        System.debug('lstNAM[1].MINCAmount__c >> '+lstNAM[1].MINCAmount__c);
        System.debug('lstNAM[2].MINCAmount__c >> '+lstNAM[2].MINCAmount__c);
    }

    @isTest static void beforeInsertWOTest(){
        Test.startTest();
        NAMFactory.createExchange();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');        
        WorkOrder wo = WorkOrderFactory.createWO(nam, 'MdB');
        WorkOrderLineItem woItem = WorkOrderFactory.createWOLineItem(wo, 1000);
        WorkOrder wo2 = WorkOrderFactory.createWO(nam, 'MdB');
        WorkOrderLineItem woItem2 = WorkOrderFactory.createWOLineItem(wo2, 1000);
        Test.stopTest();

        WorkOrder w = [SELECT Id, WorkOrder__c, CurrencyIsoCode FROM WorkOrder WHERE Id =: wo.Id];
        WorkOrder w2 = [SELECT Id, WorkOrder__c, CurrencyIsoCode FROM WorkOrder WHERE Id =: wo2.Id];
        System.assertEquals('USD', w.CurrencyIsoCode);
        System.assertEquals('WO-MV24-20-001-1_r0', w.WorkOrder__c);
        System.assertEquals('WO-MV24-20-001-2_r0', w2.WorkOrder__c);
    }

    @isTest static void getWorkOrderTest(){
        Test.startTest();
        NAMFactory.createExchange();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');        
        WorkOrder wo = WorkOrderFactory.createWO(nam, 'MdB');
        WorkOrder wo2 = WorkOrderFactory.createWO(nam, 'MdB');
        Test.stopTest();

        Set<Id> setNamId = new Set<Id>{nam.Id};
        List<WorkOrder> woLst = WorkOrderDAO.getByNAMId(setNamId);
        WorkOrder w = WorkOrderDAO.getById(wo.Id);

        System.assertEquals(2, woLst.size());
        System.assertEquals('WO-MV24-20-001-1_r0', w.WorkOrder__c);

        try{
            WorkOrder wError = WorkOrderDAO.getById('a0h3I000001lSYxQAM'); //invalid wo id
            System.assertEquals(null, wError);
        }catch (Exception e){ }
    }

    @isTest static void getWorkOrderLineTest(){
        Test.startTest();
        NAMFactory.createExchange();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');        
        WorkOrder wo = WorkOrderFactory.createWO(nam, 'MdB');
        WorkOrderLineItem woItem1 = WorkOrderFactory.createWOLineItem(wo, 1000);
        WorkOrderLineItem woItem2 = WorkOrderFactory.createWOLineItem(wo, 2000);
        Test.stopTest();
        
        List<WorkOrderLineItem> woliLst = WorkOrderLineItemDAO.getWorkOrderLineItemByNAM(nam.Id);
        System.assertEquals(2, woliLst.size());
    }

    @isTest static void fillWOPrimaryNumberInNAMTest(){
        Test.startTest();
        NAMFactory.createExchange();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');        
        WorkOrder wo1 = WorkOrderFactory.createWO(nam, 'MdB');
        WorkOrder wo2 = WorkOrderFactory.createWO(nam, 'MdB');
        Test.stopTest();

        WorkOrder w1 = [SELECT Id, WorkOrderPrimaryNumber__c FROM WorkOrder WHERE Id =: wo1.Id];
        WorkOrder w2 = [SELECT Id, WorkOrderPrimaryNumber__c FROM WorkOrder WHERE Id =: wo2.Id];
        NAM__c n = [SELECT Id, WorkOrderPrimaryNumber__c FROM NAM__c WHERE Id =: nam.Id];
        System.assertEquals('WO-MV24-20-001', w1.WorkOrderPrimaryNumber__c);
        System.assertEquals('WO-MV24-20-001', w2.WorkOrderPrimaryNumber__c);
        System.assertEquals('WO-MV24-20-001', n.WorkOrderPrimaryNumber__c);
    }

    @isTest static void outsideOfBrazilWOLineItem(){
        Test.startTest();
        NAMFactory.createExchange();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');        
        WorkOrder wo = WorkOrderFactory.createWO(nam, 'MdB');
        WorkOrderLineItem woItem = WorkOrderFactory.createWOLineItem(wo, 1000, 'Outside of Brazil');
        Test.stopTest();

        WorkOrderLineItem w = [SELECT Id, BRL__c, BRLRate__c FROM WorkOrderLineItem WHERE Id =: woItem.Id];
        System.assertEquals(w.BRL__c, null);
        System.assertEquals(w.BRLRate__c, null);
    }
}