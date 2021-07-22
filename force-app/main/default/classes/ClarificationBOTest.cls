@isTest
public with sharing class ClarificationBOTest {

    @istest static void finalCommentsApproved() {
        Test.startTest();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');
        Clarification__c clarification = ClarificationFactory.createClarification(nam, 'NAM');
        Test.stopTest();

        nam.RCA__c = 'Required';
        nam.TechFinalComment__c = 'aaaa';
        nam.Status__c = 'SPC Partners';
        update nam;
        
        clarification.FinalComment__c = 'My test final comment';
        update clarification;
        
        Clarification__c c = [SELECT Id, FinalComment__c, Status__c, NAM__c FROM Clarification__c WHERE Id =: clarification.Id];
        System.assertEquals(null, c.FinalComment__c);
        System.assertEquals('Approved', c.Status__c);

        FinalClarification__c finalClarification = [SELECT Id, Clarification__c, NAM__c, FinalComment__c, Partner__c FROM FinalClarification__c WHERE Clarification__c =: clarification.Id LIMIT 1];
        System.assertEquals(finalClarification.Clarification__c, c.Id);
        System.assertEquals(finalClarification.NAM__c, c.NAM__c);
        System.assertEquals(finalClarification.FinalComment__c, clarification.FinalComment__c);
        System.assertEquals(finalClarification.Partner__c, 'Mitsui');
    }
    @istest static void finalCommentsApprovedError1() {
        Test.startTest();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');
        Clarification__c clarification = ClarificationFactory.createClarification(nam, 'NAM');
        
        try {
            clarification.FinalComment__c = 'My test final comment';
            update clarification;
        } catch (Exception e) {
            System.Assert(e.getMessage().contains('You only can edit the clarification when NAM record status is "SPC Partners"'));
            Clarification__c c = [SELECT Id, FinalComment__c FROM Clarification__c WHERE Id =: clarification.Id];
            System.assertEquals(null, c.FinalComment__c);
        }
        Test.stopTest();
    }

    @istest static void finalCommentsApprovedError2() {
        Test.startTest();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');
        Clarification__c clarification = ClarificationFactory.createClarification(nam, 'NAM');

        nam.RCA__c = 'Required';
        nam.TechFinalComment__c = 'aaaa';
        nam.Status__c = 'SPC Partners';
        update nam;
        
        try {
            clarification.Status__c = 'Rejected';
            clarification.FinalComment__c = 'My test final comment';
            update clarification;
        } catch (Exception e) {
            System.Assert(e.getMessage().contains('You cannot Approve a Rejected record'));
            Clarification__c c = [SELECT Id, FinalComment__c, RejectReason__c FROM Clarification__c WHERE Id =: clarification.Id];
            System.assertEquals(null, c.RejectReason__c);
        }
        Test.stopTest();
    }

    @istest static void finalCommentsRejectedError1() {
        Test.startTest();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');
        Clarification__c clarification = ClarificationFactory.createClarification(nam, 'NAM');
        
        try {
            clarification.RejectReason__c = 'My test rejected comment';
            update clarification;
        } catch (Exception e) {
            System.Assert(e.getMessage().contains('You only can edit the clarification when NAM record status is "SPC Partners"'));
            Clarification__c c = [SELECT Id, RejectReason__c FROM Clarification__c WHERE Id =: clarification.Id];
            System.assertEquals(null, c.RejectReason__c);
        }
        Test.stopTest();
    }

    @istest static void finalCommentsRejectedError2() {
        Test.startTest();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');
        Clarification__c clarification = ClarificationFactory.createClarification(nam, 'NAM');

        nam.RCA__c = 'Required';
        nam.TechFinalComment__c = 'aaaa';
        nam.Status__c = 'SPC Partners';
        update nam;
        
        try {
            clarification.Status__c = 'Approved';
            clarification.RejectReason__c = 'My test rejection comment';
            update clarification;
        } catch (Exception e) {
            System.Assert(e.getMessage().contains('You cannot Reject an Approved record'));
            Clarification__c c = [SELECT Id, FinalComment__c, RejectReason__c FROM Clarification__c WHERE Id =: clarification.Id];
            System.assertEquals(null, c.RejectReason__c);
        }
        Test.stopTest();
    }
    @isTest static void getClarification(){
        Test.startTest();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');
        Clarification__c clarification = ClarificationFactory.createClarification(nam, 'NAM');
        ClarificationTopic__c topic = ClarificationFactory.createClarificationTopic(clarification);
        Test.stopTest();

        Clarification__c c = ClarificationDAO.getById(clarification.Id);
        Set<String> setClarificationId = new Set<String>{clarification.Id};
        List<Clarification__c> lstC = ClarificationDAO.getById(setClarificationId);

        System.assertEquals(c.NAM__c, clarification.NAM__c);
        System.assertEquals(1, lstC.size());

        try{
            Clarification__c cError = ClarificationDAO.getById('a0h3I000001lSYxQAM'); //invalid clarification id
            System.assertEquals(null, cError);
        }catch (Exception e){ }
    }

    @isTest static void fillClarificationTopicTest(){
        Test.startTest();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');
        Clarification__c clarification = ClarificationFactory.createClarification(nam, 'NAM');
        Clarification__c clarification2 = ClarificationFactory.createClarificationPartner(nam, 'NAM', 'MINC');
        ClarificationTopic__c topic = ClarificationFactory.createClarificationTopic(clarification);
        Test.stopTest();

        ClarificationTopic__c clarificationTopic = new ClarificationTopic__c(
            NAM1__c = clarification.NAM__c,
            Name = 'Clarification 1'
        );
        insert clarificationTopic;
    }

    @isTest static void clarificationStatusAfterPartnerRejection1(){
        Test.startTest();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');
        Clarification__c clarificationMitsui = ClarificationFactory.createClarificationPartner(nam, 'NAM', 'Mitsui');
        Clarification__c clarificationMarubeni = ClarificationFactory.createClarificationPartner(nam, 'NAM', 'Marubeni');
        Clarification__c clarificationMOL = ClarificationFactory.createClarificationPartner(nam, 'NAM', 'MOL');
        Clarification__c clarificationMINC = ClarificationFactory.createClarificationPartner(nam, 'NAM', 'MINC');

        nam.RCA__c = 'Required';
        nam.TechFinalComment__c = 'aaaa';
        nam.Status__c = 'SPC Partners';
        update nam;
        
        clarificationMarubeni.status__c = 'Approved';
        clarificationMOL.status__c = 'Approved';
        clarificationMINC.status__c = 'Approved';

        List<Clarification__c> lstClarificationUpdate = new List<Clarification__c>{clarificationMarubeni, clarificationMOL, clarificationMINC};
        update lstClarificationUpdate;

        clarificationMitsui.RejectReason__c = 'My test rejection comment';
        update clarificationMitsui;

        Test.stopTest();
        
        NAM__c n = [SELECT MitsuiStatus__c, MarubeniStatus__c, MOLStatus__c, MINCStatus__c, MitsuiApprovalDate__c, MarubeniApprovalDate__c, MOLApprovalDate__c, MINCApprovalDate__c FROM NAM__c WHERE Id =: nam.Id];
        System.assertEquals('Rejected', n.MitsuiStatus__c);
        System.assertEquals('Pending',  n.MarubeniStatus__c);
        System.assertEquals( null,      n.MarubeniApprovalDate__c);
        System.assertEquals('Pending',  n.MOLStatus__c);
        System.assertEquals( null,      n.MOLApprovalDate__c);
        System.assertEquals('Pending',  n.MINCStatus__c);
        System.assertEquals( null,      n.MINCApprovalDate__c);        
    }

    @isTest static void clarificationStatusAfterPartnerRejection2(){
        Test.startTest();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');
        Clarification__c clarificationMitsui = ClarificationFactory.createClarificationPartner(nam, 'NAM', 'Mitsui');
        Clarification__c clarificationMarubeni = ClarificationFactory.createClarificationPartner(nam, 'NAM', 'Marubeni');
        Clarification__c clarificationMOL = ClarificationFactory.createClarificationPartner(nam, 'NAM', 'MOL');
        Clarification__c clarificationMINC = ClarificationFactory.createClarificationPartner(nam, 'NAM', 'MINC');

        nam.RCA__c = 'Required';
        nam.TechFinalComment__c = 'aaaa';
        nam.Status__c = 'SPC Partners';
        update nam;
        
        clarificationMitsui.status__c = 'Approved';
        clarificationMOL.status__c = 'Approved';
        clarificationMINC.status__c = 'Approved';

        List<Clarification__c> lstClarificationUpdate = new List<Clarification__c>{clarificationMitsui, clarificationMOL, clarificationMINC};
        update lstClarificationUpdate;

        clarificationMarubeni.RejectReason__c = 'My test rejection comment';
        update clarificationMarubeni;

        Test.stopTest();
        
        NAM__c n = [SELECT MitsuiStatus__c, MitsuiApprovalDate__c FROM NAM__c WHERE Id =: nam.Id];

        System.assertEquals('Pending', n.MitsuiStatus__c);
        System.assertEquals(null,      n.MitsuiApprovalDate__c);        
    }

    @isTest static void namStatusAfterAllFinalClarificationsApproved(){
        Test.startTest();
        Vessel__c vessel = VesselFactory.createVessel();
        NAM__c nam = NAMFactory.createNAM(vessel, 'NAM-MV24-20-001');
        Clarification__c clarificationMitsui = ClarificationFactory.createClarificationPartner(nam, 'Closed Out', 'Mitsui');
        Clarification__c clarificationMarubeni = ClarificationFactory.createClarificationPartner(nam, 'Closed Out', 'Marubeni');
        Clarification__c clarificationMOL = ClarificationFactory.createClarificationPartner(nam, 'Closed Out', 'MOL');
        Clarification__c clarificationMINC = ClarificationFactory.createClarificationPartner(nam, 'Closed Out', 'MINC');

        nam.Status__c = 'Approved';
        nam.ClosedOutStatus__c = 'Execution';
        nam.RCA__c = 'Required';
        nam.TechFinalComment__c = 'Tech comment test';
        update nam;

        clarificationMitsui.Status__c = 'Approved';
        clarificationMOL.Status__c = 'Approved';
        clarificationMINC.Status__c = 'Approved';
        clarificationMarubeni.Status__c = 'Approved';
        List<Clarification__c> lstClarification = new List<Clarification__c> {clarificationMitsui, clarificationMOL, clarificationMINC, clarificationMarubeni};
        update lstClarification;

        Test.stopTest();

        NAM__c n = [SELECT MitsuiClosedOutStatus__c, MitsuiClosedOutApprovalDate__c, MarubeniClosedOutStatus__c, MarubeniClosedOutApprovalDate__c, MOLClosedOutStatus__c, MOLClosedOutApprovalDate__c, MINCClosedOutStatus__c, MINCClosedOutApprovalDate__c FROM NAM__c WHERE Id =: nam.Id];
        Date approvedDate = Date.today();
        System.assertEquals('Approved', n.MitsuiClosedOutStatus__c);
        System.assertEquals(approvedDate, n.MitsuiClosedOutApprovalDate__c);
        System.assertEquals('Approved', n.MarubeniClosedOutStatus__c);
        System.assertEquals(approvedDate, n.MarubeniClosedOutApprovalDate__c);
        System.assertEquals('Approved', n.MOLClosedOutStatus__c);
        System.assertEquals(approvedDate, n.MOLClosedOutApprovalDate__c);
        System.assertEquals('Approved', n.MINCClosedOutStatus__c);
        System.assertEquals(approvedDate, n.MINCClosedOutApprovalDate__c);
    }
}