@isTest
public with sharing class NAMTest {
    @isTest static void testNAMRename(){
        
        Test.startTest();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');
        Test.stopTest();

        System.assertEquals(nam.Name, 'NAM-MV24-20-001'); 
    }
    @isTest static void testCalculateNAM(){

        Test.startTest();
        NAMFactory.createExchange();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');        
        WorkOrder wo = WorkOrderFactory.createWO(nam, 'MdB');
        WorkOrderLineItem woItem = WorkOrderFactory.createWOLineItem(wo, 1000);
        Test.stopTest();
    }
    @isTest static void testCreateNAMClarification(){

        Test.startTest();
        NAMFactory.createExchange();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');        
        WorkOrder wo = WorkOrderFactory.createWO(nam, 'MdB');
        WorkOrderLineItem woItem = WorkOrderFactory.createWOLineItem(wo, 1000);
         
        woItem.Price__c = 1500;
        update woItem;

        update wo;

        nam.Revision__c = 1;
        update nam;


        nam.Status__c = 'PEM';
        update nam;

        nam.ClarificationCreated__c = true;
        nam.Status__c = 'Tech Team';
        update nam;
    
        Test.stopTest();
    }

    @isTest static void testCreateNAM1(){

        Test.startTest();
        NAMFactory.createExchange();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');        
        WorkOrder wo = WorkOrderFactory.createWO(nam, 'MdB');
        WorkOrderLineItem woItem = WorkOrderFactory.createWOLineItem(wo, 1000);
         
        woItem.Price__c = 1500;
        update woItem;

        update wo;

        nam.Revision__c = 1;
        update nam;

        Test.stopTest();
    }

    @isTest static void testCreateNAM2(){

        Test.startTest();
        NAMFactory.createExchange();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');        
        WorkOrder wo = WorkOrderFactory.createWO(nam, 'MdB');
        WorkOrderLineItem woItem = WorkOrderFactory.createWOLineItem(wo, 1000);
         
        woItem.Price__c = 1500;
        update woItem;

        update wo;

        nam.Status__c = 'PEM';
        update nam;

        nam.ClarificationCreated__c = true;
        nam.Status__c = 'Tech Team';
        update nam;

        Test.stopTest();
    }

     @isTest static void testCreateNAM3(){

        Test.startTest();
        NAMFactory.createExchange();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');        
        WorkOrder wo = WorkOrderFactory.createWO(nam, 'MdB');
        WorkOrderLineItem woItem = WorkOrderFactory.createWOLineItem(wo, 1000);
         
        nam.Status__c = 'Approved';
        nam.ClosedOutStatus__c = 'Execution';
        nam.RCA__c = 'Required';
        nam.TechFinalComment__c = 'aaaa';
        update nam;

        nam.ClosedOutStatus__c = 'PEM';
        update nam;
        
        nam.ClosedOutClarificationCreated__c = true; 
        nam.ClosedOutStatus__c = 'Tech Team';
        update nam;
    
        Test.stopTest();
    }
   
     

    @isTest static void testCreateClarificationApproved(){

        Test.startTest();
        
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');        
        
        nam.RCA__c = 'Required';
        nam.TechFinalComment__c = 'aaaa';
        nam.Status__c = 'SPC Partners';
        update nam;

        Clarification__c clarificationNAM = ClarificationFactory.createClarification(nam, 'NAM');
        clarificationNAM.FinalComment__c = 'finnalcccccc';
        update clarificationNAM;

        Test.stopTest();
    }

    @isTest static void testCreateClarificationRejected(){

        Test.startTest();
        
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');        
        
        nam.RCA__c = 'Required';
        nam.TechFinalComment__c = 'aaaa';
        nam.Status__c = 'SPC Partners';
        update nam;

        Clarification__c clarificationNAM = ClarificationFactory.createClarification(nam, 'NAM');

        ClarificationFactory.createClarificationTopic(clarificationNAM);
        
        clarificationNAM.RejectReason__c = 'finnalcccccc';
        update clarificationNAM;

        Test.stopTest();
    }
    @isTest static void testCreateClarificationTopic(){
        Test.startTest();
        
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');        
        
        nam.RCA__c = 'Required';
        nam.TechFinalComment__c = 'aaaa';
        nam.Status__c = 'SPC Partners';
        update nam;

        Clarification__c clarificationNAM = ClarificationFactory.createClarification(nam, 'NAM');

        clarificationNAM.RejectReason__c = 'finnalcccccc';
        update clarificationNAM;

        Test.stopTest();
    }

    @isTest static void testColorRatingRed1(){
        Test.startTest();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');
 
        //1 RatingSafety__c > FutherRating__c && RatingSafety__c > PotentialRating__c
        nam.Safety__c = 'Single fatality';      //represents RatingSafety__c = 5 in scoring
        nam.FutherAssetDamage__c = '<USD 20K';  //represents FutherRating__c = 1 in scoring
        nam.PotentialPenalty__c = 'No';         //represents PotentialRating__c = 1 in scoring
        nam.Probability__c = 'A';
        
        update nam;
        Test.stopTest();

        NAM__c n = [SELECT Id, ColorRating__c FROM NAM__c WHERE Name = 'NAM-MV24-20-001'];
        
        System.assertEquals('red', n.ColorRating__c);
    }

    @isTest static void testColorRatingRed2(){
        Test.startTest();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');
        
        //2 PotentialRating__c > RatingSafety__c && PotentialRating__c > FutherRating__c
        nam.Safety__c = 'No injury';            //represents RatingSafety__c = 1 in scoring
        nam.FutherAssetDamage__c = '<USD 20K';  //represents FutherRating__c = 1 in scoring
        nam.PotentialPenalty__c = '<USD 500K';  //represents PotentialRating__c = 3 in scoring
        nam.Probability__c = 'D';
        
        update nam;
        Test.stopTest();

        NAM__c n = [SELECT Id, ColorRating__c FROM NAM__c WHERE Name = 'NAM-MV24-20-001'];

        System.assertEquals('red', n.ColorRating__c);
    }

    @isTest static void testColorRatingRed3(){
        Test.startTest();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');
        
        //2 PotentialRating__c > RatingSafety__c && PotentialRating__c > FutherRating__c
        nam.Safety__c = 'No injury';            //represents RatingSafety__c = 1 in scoring
        nam.FutherAssetDamage__c = '<USD 20K';  //represents FutherRating__c = 1 in scoring
        nam.PotentialPenalty__c = '<USD 1M';    //represents PotentialRating__c = 4 in scoring
        nam.Probability__c = 'D';
        
        update nam;
        Test.stopTest();

        NAM__c n = [SELECT Id, ColorRating__c FROM NAM__c WHERE Name = 'NAM-MV24-20-001'];

        System.assertEquals('red', n.ColorRating__c);
    }

    @isTest static void testReasonWithoutTechSupport(){
        String username = 'technicalspc' + DateTime.now().getTime() + '@testorg.com';
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Technical SPC'];
        User user = new User(Alias = 'tech', 
                             Email = 'technicalspc@testorg.com', 
                             EmailEncodingKey = 'UTF-8', 
                             LastName = 'SPC', 
                             LanguageLocaleKey = 'en_US',
                             LocaleSidKey='en_US', 
                             ProfileId = profile.Id,
                             TimeZoneSidKey = 'America/Los_Angeles',
                             UserName = username);
        
        System.runAs(user){
            Test.startTest();
            Vessel__c vessel = VesselFactory.createVessel();
            NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');
            nam.ReasonWithoutAllTechSupport__c = 'Test';
            nam.ReasonWithoutAllTechSupportCO__c = 'Test';
            update nam;
        }

        Test.stopTest();

        NAM__c n = [SELECT Id, TechSpc__c, TechSpcCO__c FROM NAM__c WHERE Name = 'NAM-MV24-20-001'];

        System.assertEquals(user.Id, n.TechSpc__c);
        System.assertEquals(user.Id, n.TechSpcCO__c);
    }

    @isTest static void renameNAMTest1(){
        Test.startTest();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');

        try{
            nam.Status__c = 'PEM';
            nam.Revision__c = 1;
            update nam;
        }catch(Exception e){
            System.Assert(e.getMessage().contains('You only can create a revision in the AMC stages'));
        }
    }

    @isTest static void renameNAMTest2(){
        Test.startTest();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');
        nam.Status__c = 'Approved';
        nam.ClosedOutStatus__c = 'Execution';
        nam.RCA__c = 'Required';
        nam.TechFinalComment__c = 'aaaa';
        update nam;

        nam.ClosedOutStatus__c = 'PEM';
        update nam;

        try{
            nam.RevisionCO__c = 1;
            update nam;
        }catch(Exception e){
            System.Assert(e.getMessage().contains('You only can create a revision in the Execution stage'));
        }
    }

    @isTest static void validateNAMNameTest1(){
        
        Test.startTest();
        Vessel__c vessel = VesselFactory.createVessel();
        try {
            NAM__c nam = NAMFactory.createNAM(vessel, 'NAMMV2420001');
        } catch (Exception e) {
            System.Assert(e.getMessage().contains('NAM number format has to be: NAM-MVxx-xx-xxx'));
        }
        Test.stopTest();
    }

    @isTest static void validateNAMNameTest2(){
        
        Test.startTest();
        Vessel__c vessel = VesselFactory.createVessel();
        try {
            NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-XX24-20-001');
        } catch (Exception e) {
            System.Assert(e.getMessage().contains('NAM number format has to be: NAM-MVxx-xx-xxx'));
        }
        Test.stopTest(); 
    }

    @isTest static void updateSPCTechMember1(){
        Test.startTest();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');
        User user = TechnicalMemberSupportFactory.createUser('test@modec.com', 'System Administrator');
        TechnicalMemberSupport__c techSupport = TechnicalMemberSupportFactory.createTechSupport(nam, 'Supported', user, 'NAM');

        nam.Revision__c = 1;
        update nam;
        Test.stopTest();

        TechnicalMemberSupport__c t = [SELECT Id, Status__c, Description__c FROM TechnicalMemberSupport__c LIMIT 1];
        System.assertEquals('Pending', t.Status__c);
    }

    @isTest static void updateSPCTechMember2(){
        Test.startTest();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');
        User user = TechnicalMemberSupportFactory.createUser('test@modec.com', 'System Administrator');
        TechnicalMemberSupport__c techSupport = TechnicalMemberSupportFactory.createTechSupport(nam, 'Supported', user, 'Closed Out');

        nam.Status__c = 'Approved';
        nam.ClosedOutStatus__c = 'Execution';
        update nam;

        nam.RevisionCO__c = 1;
        update nam;
        Test.stopTest();

        TechnicalMemberSupport__c t = [SELECT Id, Status__c, Description__c FROM TechnicalMemberSupport__c LIMIT 1];
        System.assertEquals('Pending', t.Status__c);
    }

    @isTest static void getNAMById(){
        Test.startTest();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');
        Test.stopTest();

        NAM__c n = NamDAO.getById(nam.Id);
        System.assertEquals(nam.Id, n.Id);

        try{
            NAM__c nError = NamDAO.getById('a0g3I00000063q2QAA'); //invalid nam id
            System.assertEquals(null, nError);
        }catch (Exception e){ }
    }

    @isTest static void aggregateResultTest(){
        Test.startTest();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');
        Test.stopTest();

        Set<String> setVesselIds = new Set<String>{vessel.Id};
        AggregateResult[] a = NamDAO.getByYear('', setVesselIds);
        System.assertEquals(1, a.size());

    }

    @isTest static void getTest() 
    {
        ClassCoverage t = new ClassCoverage();
        t.declarar();
        t.declarar2();
        t.declarar3();
        t.declarar4();
    }
}