public with sharing class TestUtil {

    public static Vessel__c createVessel()
    {
        Vessel__c vessel = new Vessel__c(
            Name = 'Vessel Test',
            ShortName__c = 'Test1',
            VesselCode__c = 'Test-Vessel2',
            Status__c = 'In Operation'
        );

        insert vessel;
        return vessel;
    }

    public static Vessel__c createVessel2()
    {
        Vessel__c vessel = new Vessel__c(
            Name = 'Vessel Test',
            ShortName__c = 'Test',
            VesselCode__c = 'Test-Vessel',
            Status__c = 'In Operation'
        );

        insert vessel;
        return vessel;
    }

    public static VesselContract__c createVesselContractServices()
    {
        Vessel__c vessel = createVessel2();

        VesselContract__c vesselContract = new VesselContract__c(
            Name = '2400.0041967.08.2',
            Type__c = 'Services',
            ActualDailyRateBRL__c = 10,
            MealAllowance__c = 100,
            Pilot__c = 500,
            BOMStartDate__c = System.today(),
            Vessel__c = vessel.Id
        );

        insert vesselContract;
        return vesselContract;
    }

    public static VesselContract__c createVesselContractCharter()
    {
        List<Vessel__c> vessel = [SELECT Id FROM Vessel__c WHERE VesselCode__c = 'Test-Vessel' LIMIT 1];

        VesselContract__c vesselContract = new VesselContract__c(
            Name = '2400.0041968.08.2',
            Type__c = 'Charter',
            ActualDailyRateUSD__c = 10,
            MealAllowance__c = 100,
            Pilot__c = 500,
            BOMStartDate__c = System.today(),
            Vessel__c = vessel[0].Id
        );

        insert vesselContract;
        return vesselContract;
    }

    public static Claim__c createClaim(String source)
    {
        Letter__c letter = createLetterSent();
        RDO__c rdo = createRDO();

        Claim__c claim = new Claim__c(
            Source__c = source, 
            Letter__c = letter.Id,
            RDO__c = rdo.Id
        );

        insert claim;
        return claim;
    }

    public static LetterGroup__c createLetterGroup()
    {
        LetterGroup__c letterGroup = new LetterGroup__c();

        insert letterGroup;

        Vessel__c vessel = createVessel();

        LetterGroupVesselAssociation__c lGVesselAssoc = new LetterGroupVesselAssociation__c(
            LetterGroup__c = letterGroup.Id,
            Vessel__c = vessel.Id
        );

        insert lGVesselAssoc;

        return letterGroup;
    }

    public static Letter__c createLetterSent()
    {
        String recordTypeId;
        LetterGroup__c LetterGroup = createLetterGroup();
        List<RecordType> lstRecord = new List<RecordType>();

        lstRecord = [SELECT Id from RecordType WHERE DeveloperName = 'sent'];

        for(RecordType record : lstRecord)
        {
            recordTypeId = record.Id;
        }

        Letter__c letter = new Letter__c(
            Subject__c = 'Test',
            LetterGroup__c = LetterGroup.Id,
            RecordTypeId = recordTypeId,
            ContractAdministrator__c = ''
        );

        insert letter;
        return letter;
    }

    public static Letter__c createLetterReceived()
    {
        String recordTypeId;
        LetterGroup__c LetterGroup = createLetterGroup();
        List<RecordType> lstRecord = new List<RecordType>();

        lstRecord = [SELECT Id from RecordType WHERE DeveloperName = 'received'];

        for(RecordType record : lstRecord)
        {
            recordTypeId = record.Id;
        }

        Letter__c letter = new Letter__c(
            Subject__c = 'Test',
            LetterGroup__c = LetterGroup.Id,
            Deadline__c = System.today(),
            RecordTypeId = recordTypeId
        );

        insert letter;
        return letter;
    }

    public static Letter__c createLetterReceived2()
    {
        String recordTypeId;
        List<RecordType> lstRecord = new List<RecordType>();

        lstRecord = [SELECT Id from RecordType WHERE DeveloperName = 'received'];

        for(RecordType record : lstRecord)
        {
            recordTypeId = record.Id;
        }

        Letter__c letter = new Letter__c(
            Subject__c = 'Test',
            RecordTypeId = recordTypeId
        );

        insert letter;
        return letter;
    }

    public static RDO__c createRDO()
    {
        VesselContract__c services = createVesselContractServices();
        VesselContract__c charter = createVesselContractCharter();
        BOM__c bom = createBOM();

        RDO__c rdo = new RDO__c(
            Name = '123',
            BOM__c = bom.Id,
            ServicesContract__c = services.Id,
            CharterContract__c = charter.Id,
            WaterInjectionDailyQuota__c = 5000,
            WaterInjectionInjectedVolume__c = 4000,
            WaterInjectionUninjectedVolume__c = 1000,
            WaterInjectionAboveQuotaVolume__c = 0,
            LocalContentPetr__c = 10,
            LocalContentPetrCont__c = 10,
            NaturalGasHPFlareBurn__c = 10,
            NaturalGasLPFlareBurn__c = 10,
            NaturalGasProduced__c = 10,
            NaturalGasExported__c = 10,
            BurningGasPetrVolume__c = 10,
            BurningGasContrVolume__c = 10,
            WaterInjectionTimeTotalStop__c = Time.newInstance(1, 2, 3, 4),
            RateDeltaDaily__c = 1,
            DieselConsumCtrlContrConsumed__c = 1
        );

        insert rdo;
        return rdo;
    }

    public static RDO__c createRDO2()
    {
        VesselContract__c services = createVesselContractServices();
        VesselContract__c charter = createVesselContractCharter();

        RDO__c rdo = new RDO__c(
            Name = '456',
            CharterContract__c = charter.Id,
            ServicesContract__c = services.Id,
            WaterInjectionDailyQuota__c = 5000,
            WaterInjectionInjectedVolume__c = 4000,
            WaterInjectionUninjectedVolume__c = 1000,
            WaterInjectionAboveQuotaVolume__c = 0,
            LocalContentPetr__c = 10,
            LocalContentPetrCont__c = 10,
            NaturalGasHPFlareBurn__c = 10,
            NaturalGasLPFlareBurn__c = 10,
            NaturalGasProduced__c = 10,
            NaturalGasExported__c = 10,
            BurningGasPetrVolume__c = 10,
            BurningGasContrVolume__c = 10,
            WaterInjectionTimeTotalStop__c = Time.newInstance(1, 2, 3, 4)
        );

        insert rdo;
        return rdo;
    }

    public static LetterVesselAssociation__c createLVAssociation()
    {
        Letter__c letter = createLetterSent();
        Vessel__c vessel = createVessel();

        LetterVesselAssociation__c lVAssoc = new LetterVesselAssociation__c(
            Letter__c = letter.Id,
            Vessel__c = vessel.Id
        );

        insert lVAssoc;
        return lVAssoc;
    }

    public static VORVO__c createVORVO()
    {
        Letter__c letter = createLetterSent();

        VORVO__c vor = new VORVO__c(
            Letter__c = letter.Id
        );

        insert vor;
        return vor;
    }

    public static WaterCompensation__c createWaterComp()
    {
        RDO__c rdo1 = createRDO();
        RDO__c rdo2 = createRDO2();

        WaterCompensation__c waterComp = new WaterCompensation__c(
            ReceivingRDO__c = rdo1.Id,
            SendingRDO__c = rdo2.Id,
            Amount__c = 100
        );

        insert waterComp;
        return waterComp;
    }

    public static BOM__c createBOM()
    {
        List<Vessel__c> vessel = [SELECT Id FROM Vessel__c WHERE VesselCode__c = 'Test-Vessel' LIMIT 1];

        BOM__c bom = new BOM__c(
            StartDate__c = System.today(),
            EndDate__c = System.today() + 30,
            Vessel__c = vessel[0].Id
        );

        insert bom;
        return bom;
    }

    public static DailyRates__c createDailyRate()
    {
        RDO__c rdo = createRDO();

        DailyRates__c dailyRate = new DailyRates__c(
            RDO__c = rdo.Id,
            Description__c = 'IUGA',
            PercentReduction__c = '3%'
        );

        insert dailyRate;
        return dailyRate;
    }
}