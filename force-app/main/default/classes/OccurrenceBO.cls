public with sharing class OccurrenceBO {

    private static final OccurrenceBO instance = new OccurrenceBO();


    public static OccurrenceBO getInstance() {
		return instance;
    }
   
    public void fillLastOccurrence(List<Occurrences__c> lstOccurrence){

        List<OccurrenceGroup__c> lstUpdate = new List<OccurrenceGroup__c>();
        List<OccurrenceGroup__c> lstOccurrenceGroup = new List<OccurrenceGroup__c>();
        set<Id> idOccurrenceGroup = new set<Id>();

        for(Occurrences__c occ : lstOccurrence){

            if(!lstOccurrence.isEmpty()){
                idOccurrenceGroup.add(occ.OccurrenceGroup__c);
            }
        }

        lstOccurrenceGroup = OccurrenceGroupDAO.getOccurrenceGroupById(idOccurrenceGroup);

        for(Occurrences__c lst : lstOccurrence){

            for(OccurrenceGroup__c lstOG : lstOccurrenceGroup){

                if(!lstOccurrence.isEmpty()){
                    lstOG.LastOccurrence__c = lst.Id;
                    lstUpdate.add(lstOG);
                }
            }
        }

        update lstUpdate;

    }

}