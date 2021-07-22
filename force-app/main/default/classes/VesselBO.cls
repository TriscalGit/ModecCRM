public with sharing class VesselBO {

    private static final VesselBO instance = new VesselBO();

	public static VesselBO getInstance() {
		return instance;
    }

    public void populateVesselClientHistory (List<Vessel__c> lstVessel, Map<Id, Vessel__c> oldMap)
    {
        List<VesselClientHistory__c> historyToInsert = new List<VesselClientHistory__c>();

        if(oldMap == null)
        {
            for(Vessel__c vessel : lstVessel)
            {
                if(vessel.Management__c != null)
                {
                    VesselClientHistory__c clientHistory = new VesselClientHistory__c();
                    clientHistory.Vessel__c = vessel.Id;
                    clientHistory.Date__c = System.today();
                    clientHistory.Observation__c = 'Client set to ' + vessel.ManagementName__c + ' by ' + UserInfo.getName();
    
                    historyToInsert.add(clientHistory);
                }
            }

            insert historyToInsert;
        }
        else 
        {
            for(Vessel__c vessel : lstVessel)
            {
                if(vessel.Management__c != null)
                {
                    if(vessel.Management__c != oldMap.get(vessel.Id).Management__c)
                    {
                        VesselClientHistory__c clientHistory = new VesselClientHistory__c();
                        clientHistory.Vessel__c = vessel.Id;
                        clientHistory.Date__c = System.today();
                        clientHistory.Observation__c = 'Management was changed from ' + oldMap.get(vessel.Id).ManagementName__c + ' to ' + vessel.ManagementName__c + ' by ' + UserInfo.getName();
    
                        historyToInsert.add(clientHistory);
                    }
                }
            }

            insert historyToInsert;
        }
    }
}