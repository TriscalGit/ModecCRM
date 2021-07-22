@isTest
public with sharing class RDOBOTest {
    
    @isTest
    public static void startRDOTransferTest()
    {
        Test.startTest();
        //Vessel__c vessel = TestUtil.createVessel();
        VesselContract__c services = TestUtil.createVesselContractServices();
        VesselContract__c charter = TestUtil.createVesselContractCharter();

        String json = '{"Vessel":"Test","NumRDO":3557,"DateRDO":"2020-05-19T03:00:00.000Z","CharterContract":"2400.0041968.08.2@","ServiceContract":"2400.0041967.08.2@","CharterTotalTime":1,"ServiceTotalTime":1,"Wells":5,"K":1,"ExpedtecVolumeVe":1336.0118,"DeltaPercent":5.06546499065352,"TotalReduction": 0.504,"DailyRate":0.997,"DailyQuota":2898.95833333333,"InjectedVolume":3099.45,"UninjectedVolume":0,"AboveQuotaVolume":200.491666666667,"TimeTotalStop":"0000","TimeParcialStop":"0000","TimeCleaningSRU":"0000","InitialInventoryClient":1617,"ConsumedClient":0,"ReceivedClient":0,"TransferClientContract":1576,"ConsumedContracted":41,"InitialInventoryTotal":1617,"ConsumedTotal":41,"ReceivedTotal":0,"TransferClientContractTotal":1576,"TransferContractClientTotal":1576,"GasProduced":1789.2327,"GasExported":1560.0697,"GasLPFlare":31.758,"GasHPFlare":0,"GasFuel":197.405,"VolumeImpToClientGas":0,"VolumeImpToContractedGas":31.248,"TotalPOB":84,"FixedPOB":53,"NationalPOB":53,"NationalPercentPOB":1,"ClientCont":0,"Client":1,"OcurrencesContracted":[{"Item":8,"Reference":"CONTRATO","Contract":"AMBOS","OcurrenceType":"Petrobras","Notes":"Em referencia ao comentario 5 inserido pela CONTRATADA no RDO 3555 de 06/04/2020, considerando o cenario de PANDEMIA do COVID-19, a PETROBRAS esta de acordo com o plano apresentado pela CONTRATADA, no qual e informado o retorno operacional da bomba PBE- 6362-B (HeatingMedium de baixa) ate a data de 30/05/2020. No caso do nao atendimento deste prazo, fica ciente a CONTRATADA que estara sujeita a aplicacao das sancoes previstas contratualmente."},{"Item":8,"Reference":"CONTRATO","Contract":"AMBOS","OcurrenceType":"Petrobras","Notes":"Em referencia ao comentario 5 inserido pela CONTRATADA no RDO 3555 de 06/04/2020, considerando o cenario de PANDEMIA do COVID-19, a PETROBRAS esta de acordo com o plano apresentado pela CONTRATADA, no qual e informado o retorno operacional da bomba PBE- 6362-B (HeatingMedium de baixa) ate a data de 30/05/2020. No caso do nao atendimento deste prazo, fica ciente a CONTRATADA que estara sujeita a aplicacao das sancoes previstas contratualmente."},{"Item":8,"Reference":"CONTRATO","Contract":"AMBOS","OcurrenceType":"Petrobras","Notes":"Em referencia ao comentario 5 inserido pela CONTRATADA no RDO 3555 de 06/04/2020, considerando o cenario de PANDEMIA do COVID-19, a PETROBRAS esta de acordo com o plano apresentado pela CONTRATADA, no qual e informado o retorno operacional da bomba PBE- 6362-B (HeatingMedium de baixa) ate a data de 30/05/2020. No caso do nao atendimento deste prazo, fica ciente a CONTRATADA que estara sujeita a aplicacao das sancoes previstas contratualmente."},{"Item":8,"Reference":"CONTRATO","Contract":"AMBOS","OcurrenceType":"Petrobras","Notes":"Em referencia ao comentario 5 inserido pela CONTRATADA no RDO 3555 de 06/04/2020, considerando o cenario de PANDEMIA do COVID-19, a PETROBRAS esta de acordo com o plano apresentado pela CONTRATADA, no qual e informado o retorno operacional da bomba PBE- 6362-B (HeatingMedium de baixa) ate a data de 30/05/2020. No caso do nao atendimento deste prazo, fica ciente a CONTRATADA que estara sujeita a aplicacao das sancoes previstas contratualmente."},{"Item":8,"Reference":"CONTRATO","Contract":"AMBOS","OcurrenceType":"Petrobras","Notes":"Em referencia ao comentario 5 inserido pela CONTRATADA no RDO 3555 de 06/04/2020, considerando o cenario de PANDEMIA do COVID-19, a PETROBRAS esta de acordo com o plano apresentado pela CONTRATADA, no qual e informado o retorno operacional da bomba PBE- 6362-B (HeatingMedium de baixa) ate a data de 30/05/2020. No caso do nao atendimento deste prazo, fica ciente a CONTRATADA que estara sujeita a aplicacao das sancoes previstas contratualmente."},{"Item":8,"Reference":"CONTRATO","Contract":"AMBOS","OcurrenceType":"Petrobras","Notes":"Em referencia ao comentario 5 inserido pela CONTRATADA no RDO 3555 de 06/04/2020, considerando o cenario de PANDEMIA do COVID-19, a PETROBRAS esta de acordo com o plano apresentado pela CONTRATADA, no qual e informado o retorno operacional da bomba PBE- 6362-B (HeatingMedium de baixa) ate a data de 30/05/2020. No caso do nao atendimento deste prazo, fica ciente a CONTRATADA que estara sujeita a aplicacao das sancoes previstas contratualmente."},{"Item":8,"Reference":"CONTRATO","Contract":"AMBOS","OcurrenceType":"Petrobras","Notes":"Em referencia ao comentario 5 inserido pela CONTRATADA no RDO 3555 de 06/04/2020, considerando o cenario de PANDEMIA do COVID-19, a PETROBRAS esta de acordo com o plano apresentado pela CONTRATADA, no qual e informado o retorno operacional da bomba PBE- 6362-B (HeatingMedium de baixa) ate a data de 30/05/2020. No caso do nao atendimento deste prazo, fica ciente a CONTRATADA que estara sujeita a aplicacao das sancoes previstas contratualmente."},{"Item":8,"Reference":"CONTRATO","Contract":"AMBOS","OcurrenceType":"Petrobras","Notes":"Em referencia ao comentario 5 inserido pela CONTRATADA no RDO 3555 de 06/04/2020, considerando o cenario de PANDEMIA do COVID-19, a PETROBRAS esta de acordo com o plano apresentado pela CONTRATADA, no qual e informado o retorno operacional da bomba PBE- 6362-B (HeatingMedium de baixa) ate a data de 30/05/2020. No caso do nao atendimento deste prazo, fica ciente a CONTRATADA que estara sujeita a aplicacao das sancoes previstas contratualmente."},{"Item":8,"Reference":"CONTRATO","Contract":"AMBOS","OcurrenceType":"Petrobras","Notes":"Em referencia ao comentario 5 inserido pela CONTRATADA no RDO 3555 de 06/04/2020, considerando o cenario de PANDEMIA do COVID-19, a PETROBRAS esta de acordo com o plano apresentado pela CONTRATADA, no qual e informado o retorno operacional da bomba PBE- 6362-B (HeatingMedium de baixa) ate a data de 30/05/2020. No caso do nao atendimento deste prazo, fica ciente a CONTRATADA que estara sujeita a aplicacao das sancoes previstas contratualmente."},{"Item":8,"Reference":"CONTRATO","Contract":"AMBOS","OcurrenceType":"Petrobras","Notes":"Em referencia ao comentario 5 inserido pela CONTRATADA no RDO 3555 de 06/04/2020, considerando o cenario de PANDEMIA do COVID-19, a PETROBRAS esta de acordo com o plano apresentado pela CONTRATADA, no qual e informado o retorno operacional da bomba PBE- 6362-B (HeatingMedium de baixa) ate a data de 30/05/2020. No caso do nao atendimento deste prazo, fica ciente a CONTRATADA que estara sujeita a aplicacao das sancoes previstas contratualmente."},{"Item":8,"Reference":"CONTRATO","Contract":"AMBOS","OcurrenceType":"Petrobras","Notes":"Em referencia ao comentario 5 inserido pela CONTRATADA no RDO 3555 de 06/04/2020, considerando o cenario de PANDEMIA do COVID-19, a PETROBRAS esta de acordo com o plano apresentado pela CONTRATADA, no qual e informado o retorno operacional da bomba PBE- 6362-B (HeatingMedium de baixa) ate a data de 30/05/2020. No caso do nao atendimento deste prazo, fica ciente a CONTRATADA que estara sujeita a aplicacao das sancoes previstas contratualmente."},{"Item":8,"Reference":"CONTRATO","Contract":"AMBOS","OcurrenceType":"Petrobras","Notes":"Em referencia ao comentario 5 inserido pela CONTRATADA no RDO 3555 de 06/04/2020, considerando o cenario de PANDEMIA do COVID-19, a PETROBRAS esta de acordo com o plano apresentado pela CONTRATADA, no qual e informado o retorno operacional da bomba PBE- 6362-B (HeatingMedium de baixa) ate a data de 30/05/2020. No caso do nao atendimento deste prazo, fica ciente a CONTRATADA que estara sujeita a aplicacao das sancoes previstas contratualmente."},{"Item":8,"Reference":"CONTRATO","Contract":"AMBOS","OcurrenceType":"Petrobras","Notes":"Em referencia ao comentario 5 inserido pela CONTRATADA no RDO 3555 de 06/04/2020, considerando o cenario de PANDEMIA do COVID-19, a PETROBRAS esta de acordo com o plano apresentado pela CONTRATADA, no qual e informado o retorno operacional da bomba PBE- 6362-B (HeatingMedium de baixa) ate a data de 30/05/2020. No caso do nao atendimento deste prazo, fica ciente a CONTRATADA que estara sujeita a aplicacao das sancoes previstas contratualmente."},{"Item":8,"Reference":"CONTRATO","Contract":"AMBOS","OcurrenceType":"Petrobras","Notes":"Em referencia ao comentario 5 inserido pela CONTRATADA no RDO 3555 de 06/04/2020, considerando o cenario de PANDEMIA do COVID-19, a PETROBRAS esta de acordo com o plano apresentado pela CONTRATADA, no qual e informado o retorno operacional da bomba PBE- 6362-B (HeatingMedium de baixa) ate a data de 30/05/2020. No caso do nao atendimento deste prazo, fica ciente a CONTRATADA que estara sujeita a aplicacao das sancoes previstas contratualmente."},{"Item":8,"Reference":"CONTRATO","Contract":"AMBOS","OcurrenceType":"Petrobras","Notes":"Em referencia ao comentario 5 inserido pela CONTRATADA no RDO 3555 de 06/04/2020, considerando o cenario de PANDEMIA do COVID-19, a PETROBRAS esta de acordo com o plano apresentado pela CONTRATADA, no qual e informado o retorno operacional da bomba PBE- 6362-B (HeatingMedium de baixa) ate a data de 30/05/2020. No caso do nao atendimento deste prazo, fica ciente a CONTRATADA que estara sujeita a aplicacao das sancoes previstas contratualmente."},{"Item":8,"Reference":"CONTRATO","Contract":"AMBOS","OcurrenceType":"Petrobras","Notes":"Em referencia ao comentario 5 inserido pela CONTRATADA no RDO 3555 de 06/04/2020, considerando o cenario de PANDEMIA do COVID-19, a PETROBRAS esta de acordo com o plano apresentado pela CONTRATADA, no qual e informado o retorno operacional da bomba PBE- 6362-B (HeatingMedium de baixa) ate a data de 30/05/2020. No caso do nao atendimento deste prazo, fica ciente a CONTRATADA que estara sujeita a aplicacao das sancoes previstas contratualmente."}],"DailyRatesReduction":[{"StartTime":"1555","EndTime":"1700","OcurrenceTime":"1:05","ExtraTime":"","PercentReduction":"0,23%","Description":"TAXA DE ESPERA (*); ","AnnexTo":"REF 103","Contract":"Ambos"}]}';
        RDOTO rdo1 = RDOTO.parse(json);
        RDOBO.getInstance().startRDOTransfer(rdo1, 'Active');

        Test.stopTest();
    }
    
    @isTest
    public static void createOrUpdateBOMTest()
    {
        Test.startTest();
        RDO__c rdo = TestUtil.createRDO();
        RDOBO.getInstance().createOrUpdateBOM(rdo.Id);
        RDOBO.fillTotalLossesFields(rdo);
        RDOBO.fillRevenueField(JSON.serialize(rdo));
        Test.stopTest();
    }

    @isTest
    public static void calculateRDOfieldsTest()
    {
        Test.startTest();
        RDO__c rdo = TestUtil.createRDO();
        RDOBO.getInstance().createOrUpdateBOM(rdo.Id);
        Test.stopTest();
    }

    @isTest
    public static void recalculateSumFieldsTest()
    {
        Test.startTest();
        RDO__c rdo = TestUtil.createRDO();
        List<RDO__c> lstRDO = new List<RDO__c>();

        lstRDO.add(rdo);
        RDOBO.getInstance().recalculateSumFields(lstRDO);
        Test.stopTest();
    }

    @isTest
    public static void formatTimeFieldsTest(){
        Test.startTest();

        RDO__c rdo = TestUtil.createRDO();
        List<RDO__c> lstRDO = new List<RDO__c>();

        rdo.WaterInjectionTimeTotalStop__c = Time.newInstance(11, 1, 0, 0);
        rdo.TotalTimeService__c = Time.newInstance(11, 1, 0, 0);
        rdo.TotalTimeCharter__c = Time.newInstance(11, 1, 0, 0);
        rdo.WaterInjectionTimeParcialStop__c = Time.newInstance(1, 1, 0, 0);
        rdo.WaterInjectionTimeCleanSRU__c = Time.newInstance(1, 1, 0, 0);
        
        lstRDO.add(rdo);
        RDOBO.getInstance().formatTimeFields(lstRDO);
        lstRDO.clear();

        rdo.WaterInjectionTimeTotalStop__c = Time.newInstance(11, 11, 0, 0);
        rdo.TotalTimeService__c = Time.newInstance(11, 11, 0, 0);
        rdo.TotalTimeCharter__c = Time.newInstance(11, 11, 0, 0);
        rdo.WaterInjectionTimeParcialStop__c = Time.newInstance(11, 1, 0, 0);
        rdo.WaterInjectionTimeCleanSRU__c = Time.newInstance(11, 1, 0, 0);
        
        lstRDO.add(rdo);
        RDOBO.getInstance().formatTimeFields(lstRDO);
        lstRDO.clear();

        rdo.WaterInjectionTimeTotalStop__c = null;
        rdo.WITimeTotalStop__c = '11:01:00';
        rdo.TotalTimeService__c = null;
        rdo.TTService__c = '11:01:00';
        rdo.TotalTimeCharter__c = null;
        rdo.TTCharter__c = '11:01:00';
        rdo.WaterInjectionTimeParcialStop__c = Time.newInstance(11, 11, 0, 0);
        rdo.WaterInjectionTimeCleanSRU__c = Time.newInstance(11, 11, 0, 0);
        
        lstRDO.add(rdo);
        RDOBO.getInstance().formatTimeFields(lstRDO);
        lstRDO.clear();



        Test.stopTest();
    }
}