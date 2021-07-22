public with sharing class VesselDAO {
    private static final VesselDAO instance = new VesselDAO();

    private VesselDAO() { }

    public static VesselDAO getInstance(){
        return instance;
    }

    public List<Vessel__c> getVesselbyShortName(String shortName){
        return [SELECT id, ShortName__c, Name FROM Vessel__c WHERE ShortName__c =: shortName LIMIT 1];
    }

    public List<Vessel__c> getVesselById(String idVessel){
        return [SELECT 
                  id,   
                  ChaterPeriod__c,
                  Client__c,
                  ContractResponsible__c,
                  Country__c,
                  CreatedByMe__c,
                  FieldLocation__c,
                  FirstOil__c,
                  GasProduction__c,
                  Management__c,
                  ManagementName__c,
                  MooringType__c,
                  NumberLastSentLetter__c,
                  OilProduction__c,
                  OperationManager__c,
                  ResponsibleManagement__c,
                  ScopeOfWork__c,
                  ShortName__c,
                  Status__c,
                  Type__c,
                  VesselCode__c,
                  Name,
                  WaterDepth__c
                  FROM
                  Vessel__c
                  WHERE
                  id =: idVessel];
    }
}