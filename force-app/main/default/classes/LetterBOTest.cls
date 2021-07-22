@isTest
public with sharing class LetterBOTest {
    
    @isTest
    public static void letterBOTest()
    {
        List<Letter__c> lstLetter = new List<Letter__c>();
        List<Letter__c> lstLetterReceived = new List<Letter__c>();
        List<Letter__c> lstLetterReceived2 = new List<Letter__c>();

        Test.startTest();

        Letter__c letter = TestUtil.createLetterSent();
        Letter__c letterReceived = TestUtil.createLetterReceived();
        Letter__c letterReceived2 = TestUtil.createLetterReceived2();

        lstLetter.add(letter);
        lstLetterReceived.add(letterReceived);
        lstLetterReceived2.add(letterReceived2);

        LetterBO.getInstance().createVesselAssociations(lstLetter);
        LetterBO.getInstance().updateDeadlineLetterGroup(lstLetterReceived);
        LetterBO.getInstance().updateDeadlineLetterGroup(lstLetterReceived2);

        Test.stopTest();
    }
}