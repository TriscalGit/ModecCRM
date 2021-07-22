public with sharing class LetterBO {

    private static final LetterBO instance = new LetterBO();

	public static LetterBO getInstance() {
		return instance;
    }

    public void createVesselAssociations (List<Letter__c> lstLetter)
    {
        List<LetterGroup__c> lstGroup = new List<LetterGroup__c>();
        List<LetterGroupVesselAssociation__c> lstGroupVessels = new List<LetterGroupVesselAssociation__c>();
        List<LetterVesselAssociation__c> lstLetterVessels = new List<LetterVesselAssociation__c>();
        String groupId;
        String letterId;

        for(Letter__c letter : lstLetter)
        {
            if(letter.LetterGroup__c != null)
            {   
                groupId = letter.LetterGroup__c;
                letterId = letter.Id;
            }
        }

        if(groupId != null)
            lstGroupVessels = LetterGroupVesselAssociationDAO.getLetterGroupVesselById(groupId);

        if(lstGroupVessels != null)
        {
            for(LetterGroupVesselAssociation__c groupVessel : lstGroupVessels)
            {
                LetterVesselAssociation__c  letterVessel = new LetterVesselAssociation__c();
                letterVessel.Letter__c = letterId;
                letterVessel.Vessel__c = groupVessel.Vessel__c;

                lstLetterVessels.add(letterVessel);
            }
            insert lstLetterVessels;
        }
    }
    
    public void updateDeadlineLetterGroup(List<Letter__c> lstLetter)
    {
        List<LetterGroup__c> lstGroup = new List<LetterGroup__c>();
        LetterGroup__c letterGroup = new LetterGroup__c();
        Letter__c letterInstance = new Letter__c();
        String idGroup;

        RecordType received = [SELECT Id FROM RecordType WHERE Name = 'Received'];
        
        for(Letter__c letter : lstLetter)
        {
            if(letter.RecordTypeId != received.Id)
            {
                return;
            }
            else 
            {
                if(letter.LetterGroup__c == null)
                {
                    return;
                }

                if(letter.Deadline__c == null)
                {
                    return;
                }
                else
                {
                    idGroup = letter.LetterGroup__c;
                }
            }
        }

        lstGroup = LetterGroupDAO.getLetterGroupById(idGroup);
        letterInstance = lstLetter[0];

        if(!lstGroup.isEmpty())
        {
            letterGroup = lstGroup[0];
            letterGroup.Deadline__c = letterInstance.Deadline__c;

            update letterGroup;
        }
    }
}