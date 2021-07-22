public with sharing class LVAssociationBO {
    
    private static final LVAssociationBO instance = new LVAssociationBO();

	public static LVAssociationBO getInstance() {
		return instance;
    }

    public void generateLetterCode(List<LetterVesselAssociation__c> lstLVAssociation)
    {
        LetterVesselAssociation__c LVAssociationInstance = new LetterVesselAssociation__c();
        LetterGroup__c letterGroupInstance = new LetterGroup__c();
        Letter__c letterInstance = new Letter__c();
        Vessel__c vesselInstance = new Vessel__c();
        List<LetterGroup__c> lstLetterGroup = new List<LetterGroup__c>();
        List<Letter__c> lstLetter = new List<Letter__c>();
        List<Vessel__c> lstVessel = new List<Vessel__c>();
        String letterCode;
        String numberLastLetter;

        if(!lstLVAssociation.isEmpty())
        {
            LVAssociationInstance = lstLVAssociation[0];
        }
        else 
        {
            return;
        }

        lstLetter = LetterDAO.getLetterById(LVAssociationInstance.Letter__c);

        if(!lstLetter.isEmpty())
        {
            letterInstance = lstLetter[0];
        }

        if(letterInstance.RecordType.DeveloperName != 'Sent')
        {
            return;
        }
        else 
        {
            if(letterInstance.LetterGroup__c != null)
            {
                lstLetterGroup = LetterGroupDAO.getLetterGroupById(letterInstance.LetterGroup__c);
            }
        }

        if(!lstLetterGroup.isEmpty())
        {
            letterGroupInstance = lstLetterGroup[0];
        }

        if(letterGroupInstance.RecordType.DeveloperName != 'Vessel')
        {
            return;
        }
        else 
        {
            lstVessel = VesselDAO.getInstance().getVesselById(LVAssociationInstance.Vessel__c);
        }

        if(!lstVessel.isEmpty())
        {
            vesselInstance = lstVessel[0];
        }

        if(vesselInstance.NumberLastSentLetter__c == null || vesselInstance.NumberLastSentLetter__c < 1)
        {
            vesselInstance.NumberLastSentLetter__c = 1;
            numberLastLetter = '000' + String.valueOf(vesselInstance.NumberLastSentLetter__c);

            if(vesselInstance.VesselCode__c != null)
            {
                letterCode = vesselInstance.VesselCode__c + '-LET-' + numberLastLetter + '-' + System.Today().year(); 

                letterInstance.LetterCode__c = letterCode;
                
                update letterInstance;
                update vesselInstance;
            }
        }
        else 
        {
            System.debug('entrei no else');
            vesselInstance.NumberLastSentLetter__c ++;
            System.debug('vesselInstance.NumberLastSentLetter__c -- ' + vesselInstance.NumberLastSentLetter__c);
            numberLastLetter = '000' + String.valueOf(vesselInstance.NumberLastSentLetter__c);

            if(vesselInstance.VesselCode__c != null)
            {
                letterCode = vesselInstance.VesselCode__c + '-LET-' + numberLastLetter.right(4) + '-' + System.Today().year(); 

                letterInstance.LetterCode__c = letterCode;
                
                update letterInstance;
                update vesselInstance;
            }

        }
    }

    public void fillVesselName(List<LetterVesselAssociation__c> lstLVAssociation, Map<Id, LetterVesselAssociation__c> oldMap){

        List<Letter__c> lstLetter = new List<Letter__c>();
        List<LetterVesselAssociation__c> lstLetterVessels = new List<LetterVesselAssociation__c>();
        List<Letter__c> lstUpdate = new List<Letter__c>();
        Vessel__c vesselRecord = new Vessel__c();
        String idLetter;
        String vesselId = '';
        String vessel = '';
        Integer contador = 0;

        System.debug('user id -> ' + UserInfo.getUserId());
    
        if(oldMap == null){

            for(LetterVesselAssociation__c lst : lstLVAssociation){

                if(!lstLVAssociation.isEmpty()){
                    idLetter = lst.Letter__c;
                }
            }

            lstLetter = LetterDAO.getLetterById(idLetter);
            lstLetterVessels = LetterVesselAssociationDAO.getLetterVesselById(idLetter);

            for(LetterVesselAssociation__c lstLV : lstLetterVessels){

                for(Letter__c letter : lstLetter){
            
                    if(contador == 0){
                        letter.Vessel__c = '';
                    }
                    letter.Vessel__c = letter.Vessel__c + ' ' + lstLV.VesselShortName__c;
                    vessel = letter.Vessel__c;
                    vesselId = lstLV.Vessel__c;
                    contador ++;
                    
                }
            }

            vesselRecord = VesselDAO.getInstance().getVesselById(vesselId)[0];

            Letter__c letter = new Letter__c();
            letter = lstLetter[0];
            letter.Vessel__c = vessel;

            if(vesselRecord.ContractResponsible__c != null){
                letter.ContractAdministrator__c = String.ValueOf(vesselRecord.ContractResponsible__c).subString(0,15);
            }

            update letter;

        } else 
        {
            String letterId = oldMap.values().Letter__c;
            idLetter = letterId;

            lstLetter = LetterDAO.getLetterById(idLetter);
            lstLetterVessels = LetterVesselAssociationDAO.getLetterVesselById(idLetter);

            for(LetterVesselAssociation__c lstLV : lstLetterVessels){

                for(Letter__c letter : lstLetter){
                
                    if(contador == 0){
                        letter.Vessel__c = '';
                    }
                        letter.Vessel__c = letter.Vessel__c + ' ' + lstLV.VesselShortName__c;
                        vessel = letter.Vessel__c;
                        contador ++;
                }
            }

            Letter__c letterDelete = new Letter__c();
            letterDelete = lstLetter[0];
            letterDelete.Vessel__c = vessel;
            update letterDelete;
        } 
    }  
}