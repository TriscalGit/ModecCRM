public with sharing class RDODAO {
    
    public static List<RDO__c> getRDOById(String idRDO){
        return [SELECT 
                  id,   
                  CharterContract__c,
                  Date__c,
                  Name,
                  RateDeltaDaily__c,
                  ServicesContract__c,
                  Status__c,
                  Vessel__c,
                  BOM__c,
                  LocalContentPetrCont__c,
                  LocalContentPetr__c,
                  NaturalGasHPFlareBurn__c,
                  NaturalGasLPFlareBurn__c,
                  NaturalGasProduced__c,
                  NaturalGasExported__c,
                  BurningGasPetrVolume__c,
                  Prioritization__c,
                  WIAmountReceived__c,
                  WIAmountSent__c,
                  WITotal__c,
                  LimitDate__c,
                  WaterInjectionTimeTotalStop__c,
                  WaterInjectionTimeParcialStop__c,
                  DieselConsumCtrlContrConsumed__c
                  FROM
                  RDO__c
                  WHERE
                  id =: idRDO];
    }

    public static List<RDO__c> getRDOsByIdBOM(String idBOM, String inactive){
        return [SELECT 
                  id,   
                  CharterContract__c,
                  Date__c,
                  Name,
                  RateDeltaDaily__c,
                  DailyRateServices__c,
                  DieselConsumCtrlContrConsumed__c,
                  ServicesContract__c,
                  LocalContentPetrCont__c,
                  LocalContentPetr__c,
                  Status__c,
                  Vessel__c,
                  BOM__c,
                  NaturalGasHPFlareBurn__c,
                  NaturalGasLPFlareBurn__c,
                  NaturalGasProduced__c,
                  NaturalGasExported__c,
                  BurningGasPetrVolume__c,
                  BurningGasContrVolume__c,
                  Prioritization__c,
                  WIAmountReceived__c,
                  WIAmountSent__c,
                  WITotal__c,
                  LimitDate__c
                  FROM
                  RDO__c
                  WHERE
                  BOM__c =: idBOM
                  AND
                  Status__c !=: inactive];
    }

    public static List<RDO__c> getRDOByName(String nameRDO){
        return [SELECT 
                  id,   
                  CharterContract__c,
                  Date__c,
                  Name,
                  RateDeltaDaily__c,
                  ServicesContract__c,
                  Status__c,
                  Vessel__c,
                  BOM__c
                  FROM
                  RDO__c
                  WHERE
                  Name =: nameRDO];
    }


    public static List<RDO__c> getRDOByNameAndShortName(String nameRDO, String vessel){
        return [SELECT 
                  id,   
                  CharterContract__c,
                  Date__c,
                  Name,
                  RateDeltaDaily__c,
                  ServicesContract__c,
                  Status__c,
                  Vessel__c,
                  BOM__c
                  FROM
                  RDO__c
                  WHERE
                  Name =: nameRDO
                  AND
                  VesselShortName__c =: vessel];
    }

    public static List<RDO__c> getRDOsByIdBOMList(Set<Id> setIdBOM, String inactive){
        return [SELECT 
                  id,   
                  CharterContract__c,
                  Date__c,
                  Name,
                  RateDeltaDaily__c,
                  DieselConsumCtrlContrConsumed__c,
                  ServicesContract__c,
                  LocalContentPetrCont__c,
                  LocalContentPetr__c,
                  Status__c,
                  Vessel__c,
                  BOM__c,
                  NaturalGasHPFlareBurn__c,
                  NaturalGasLPFlareBurn__c,
                  NaturalGasProduced__c,
                  NaturalGasExported__c,
                  BurningGasPetrVolume__c,
                  Prioritization__c,
                  WIAmountReceived__c,
                  WIAmountSent__c,
                  WITotal__c,
                  LimitDate__c
                  FROM
                  RDO__c
                  WHERE
                  BOM__c IN: setIdBOM
                  AND
                  Status__c !=: inactive];
    }
}