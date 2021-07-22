public with sharing class LGVAssociationBO {
    

    private static final LGVAssociationBO instance = new LGVAssociationBO();


    public static LGVAssociationBO getInstance() {
		return instance;
    }

    public void FillVesselName(List<LetterGroupVesselAssociation__c> lstLGVAssociation, Map<Id, LetterGroupVesselAssociation__c> oldMap){

        List<LetterGroup__c> lstLetterGroup = new List<LetterGroup__c>();
        List<LetterGroupVesselAssociation__c> lstLetterGroupVessels = new List<LetterGroupVesselAssociation__c>();
        List<LetterGroup__c> lstUpdate = new List<LetterGroup__c>();
        set<Id> idLetterGroup = new set<Id>();
        String vessel = '';
        Integer contador = 0;
    
        if(oldMap == null){

            for(LetterGroupVesselAssociation__c lst : lstLGVAssociation){

                if(!lstLGVAssociation.isEmpty()){
                    idLetterGroup.add(lst.LetterGroup__c);
                }

            }

            lstLetterGroup = LetterGroupDAO.getLetterGroupBySetId(idLetterGroup);
            lstLetterGroupVessels = LetterGroupVesselAssociationDAO.getLetterGroupVesselById(idLetterGroup);
            system.debug( 'lstLetterGroup: '+ lstLetterGroup );

            for(LetterGroupVesselAssociation__c lstLGV : lstLetterGroupVessels){

                for(LetterGroup__c lstLG : lstLetterGroup){
            
                    if(contador == 0){
                    lstLG.Vessel__c = '';
                    }
                    lstLG.Vessel__c = lstLG.Vessel__c + ' ' + lstLGV.VesselShortName__c;
                    //lstUpdate.add(lstLG); 
                    vessel = lstLG.Vessel__c;
                    contador ++;
                    
                }
            }

            system.System.debug('LIST UPDATE ' + lstUpdate);
            LetterGroup__c letterGroup = new LetterGroup__c();
            letterGroup = lstLetterGroup[0];
            letterGroup.Vessel__c = vessel;
            update letterGroup;
    } else 
    {
        String letterGroup = oldMap.values().LetterGroup__c;
        idLetterGroup.add(letterGroup);

        lstLetterGroup = LetterGroupDAO.getLetterGroupBySetId(idLetterGroup);
        lstLetterGroupVessels = LetterGroupVesselAssociationDAO.getLetterGroupVesselById(idLetterGroup);
        system.debug( 'lstLetterGroup: '+ lstLetterGroup );

        for(LetterGroupVesselAssociation__c lstLGV : lstLetterGroupVessels){

            for(LetterGroup__c lstLG : lstLetterGroup){
            
                if(contador == 0){
                    lstLG.Vessel__c = '';
                }
                    lstLG.Vessel__c = lstLG.Vessel__c + ' ' + lstLGV.VesselShortName__c;
                    //lstUpdate.add(lstLG); 
                    vessel = lstLG.Vessel__c;
                    contador ++;
            }
        }

            system.System.debug('LIST UPDATE ' + lstUpdate);
            LetterGroup__c letterGroupDelete = new LetterGroup__c();
            letterGroupDelete = lstLetterGroup[0];
            letterGroupDelete.Vessel__c = vessel;
            update letterGroupDelete;
        } 
    }  
}