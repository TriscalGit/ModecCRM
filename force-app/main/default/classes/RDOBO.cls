public with sharing class RDOBO {
    private static final RDOBO instance = new RDOBO();

	public static RDOBO getInstance() {
		return instance;
    }

    public List<String> startRDOTransfer(RDOTO rdoto, string reviewRDO){
        System.debug('entrou metodo');
        List<String> returnblob = new List<String>();
        List<String> splitTime = new List<String>();
        List<Vessel__c> vess = new List<Vessel__c>();
        List<VesselContract__c> vessConService = new List<VesselContract__c>();
        List<VesselContract__c> vessConCharter = new List<VesselContract__c>();
        List<DailyRates__c> dailyRatesList = new List<DailyRates__c>();
        List<Occurrences__c> occurencesList = new List<Occurrences__c>();

        vess = VesselDAO.getInstance().getVesselbyShortName(rdoto.Vessel);
        vessConService = VesselContractDAO.getVesselContractByContractNumber(rdoto.ServiceContract.substringBeforeLast('@'),rdoto.Vessel,'Services');
        vessConCharter = VesselContractDAO.getVesselContractByContractNumber(rdoto.CharterContract.substringBeforeLast('@'),rdoto.Vessel,'Charter');

        System.debug('fez as 3 pesquisas');

        //se existir vessel e os contratos insere rdo
        if(vess.size() > 0){
            System.debug('vessel ok');
            if(vessConService.size() > 0){
                System.debug('con service ok');
                if(vessConCharter.size() > 0){
                    System.debug('con charter ok');
                    //insere rdo

                    RDO__c insertRDO = new RDO__c();
                    insertRDO.Status__c = reviewRDO;
                    insertRDO.Vessel__c = vess[0].Id;
                    insertRDO.Name = String.valueOf(rdoto.NumRDO);
                    insertRDO.Date__c = Date.newInstance(Integer.valueOf(rdoto.DateRDO.substring(0,4)), Integer.valueOf(rdoto.DateRDO.substring(5,7)), Integer.valueOf(rdoto.DateRDO.substring(8,10)));
                    insertRDO.CharterContract__c = vessConCharter[0].Id;
                    insertRDO.ServicesContract__c = vessConService[0].Id;
                    
                    insertRDO.RateReductionDeltaK__c = rdoto.K;
                    insertRDO.RateReductionDeltaWells__c = rdoto.Wells;
                    insertRDO.RateReductionDeltaPercent__c = rdoto.DeltaPercent;
                    insertRDO.RateDeltaDaily__c = rdoto.DailyRate;
                    insertRDO.RateDeltaTotalReductions__c = rdoto.TotalReduction * 100;
                    insertRDO.RateReductionDeltaExpectedVolume__c = rdoto.ExpedtecVolumeVe;
                    insertRDO.RateReductionDeltaExpectedVolume24__c = rdoto.ExpectedVolumeVe24H;
                    insertRDO.WaterInjectionDailyQuota__c = rdoto.DailyQuota;
                    insertRDO.WaterInjectionInjectedVolume__c = rdoto.InjectedVolume;
                    insertRDO.WaterInjectionUninjectedVolume__c = rdoto.UninjectedVolume;
                    insertRDO.WaterInjectionAboveQuotaVolume__c = rdoto.AboveQuotaVolume;
                    insertRDO.RateReductionDeltaMeasuredVolume__c = rdoto.ActualVolume;

                    if (rdoto.CharterTotalTime == 1){
                        insertRDO.TotalTimeCharter__c = Time.newInstance(24, 0, 0, 0);
                    }else if(string.valueOf(rdoto.CharterTotalTime) != '' && string.valueOf(rdoto.CharterTotalTime) != '0' && string.valueOf(rdoto.CharterTotalTime) != null){
                        if(string.valueOf(rdoto.CharterTotalTime).length() == 3){
                            insertRDO.TotalTimeCharter__c = Time.newInstance(integer.valueOf(string.valueOf(rdoto.CharterTotalTime).substring(0,1)), integer.valueOf(string.valueOf(rdoto.CharterTotalTime).substring(1,3)), 0, 0);
                        }else if(string.valueOf(rdoto.CharterTotalTime).length() == 2){
                            insertRDO.TotalTimeCharter__c = Time.newInstance(0, rdoto.CharterTotalTime, 0, 0);
                        }else if(string.valueOf(rdoto.CharterTotalTime).length() == 1){
                            insertRDO.TotalTimeCharter__c = Time.newInstance(0, rdoto.CharterTotalTime, 0, 0);
                        }else{
                            insertRDO.TotalTimeCharter__c = Time.newInstance(integer.valueOf(string.valueOf(rdoto.CharterTotalTime).substring(0,2)), integer.valueOf(string.valueOf(rdoto.CharterTotalTime).substring(2,4)), 0, 0);
                        }
                    }

                    if (rdoto.ServiceTotalTime == 1){
                        insertRDO.TotalTimeService__c = Time.newInstance(24, 0, 0, 0);
                    }else if(string.valueOf(rdoto.ServiceTotalTime) != '' && string.valueOf(rdoto.ServiceTotalTime) != '0' && string.valueOf(rdoto.ServiceTotalTime) != null){
                        if(string.valueOf(rdoto.ServiceTotalTime).length() == 3){
                            insertRDO.TotalTimeService__c = Time.newInstance(integer.valueOf(string.valueOf(rdoto.ServiceTotalTime).substring(0,1)), integer.valueOf(string.valueOf(rdoto.ServiceTotalTime).substring(1,3)), 0, 0);
                        }else if(string.valueOf(rdoto.ServiceTotalTime).length() == 2){
                            insertRDO.TotalTimeService__c = Time.newInstance(0, rdoto.ServiceTotalTime, 0, 0);
                        }else if(string.valueOf(rdoto.ServiceTotalTime).length() == 1){
                            insertRDO.TotalTimeService__c = Time.newInstance(0, rdoto.ServiceTotalTime, 0, 0);
                        }else{
                            insertRDO.TotalTimeService__c = Time.newInstance(integer.valueOf(string.valueOf(rdoto.ServiceTotalTime).substring(0,2)), integer.valueOf(string.valueOf(rdoto.ServiceTotalTime).substring(2,4)), 0, 0);
                        }
                    }

                    if (rdoto.TimeTotalStop == 1){
                        insertRDO.WaterInjectionTimeTotalStop__c = Time.newInstance(24, 0, 0, 0);
                    }else if(string.valueOf(rdoto.TimeTotalStop) != '' && string.valueOf(rdoto.TimeTotalStop) != '0' && string.valueOf(rdoto.TimeTotalStop) != null){
                        if(string.valueOf(rdoto.TimeTotalStop).length() == 3){
                            insertRDO.WaterInjectionTimeTotalStop__c = Time.newInstance(integer.valueOf(string.valueOf(rdoto.TimeTotalStop).substring(0,1)), integer.valueOf(string.valueOf(rdoto.TimeTotalStop).substring(1,3)), 0, 0);
                        }else if(string.valueOf(rdoto.TimeTotalStop).length() == 2){
                            insertRDO.WaterInjectionTimeTotalStop__c = Time.newInstance(0, rdoto.TimeTotalStop, 0, 0);
                        }else if(string.valueOf(rdoto.TimeTotalStop).length() == 1){
                            insertRDO.WaterInjectionTimeTotalStop__c = Time.newInstance(0, rdoto.TimeTotalStop, 0, 0);
                        }else{
                            system.debug(rdoto.TimeTotalStop);
                            insertRDO.WaterInjectionTimeTotalStop__c = Time.newInstance(integer.valueOf(string.valueOf(rdoto.TimeTotalStop).substring(0,2)), integer.valueOf(string.valueOf(rdoto.TimeTotalStop).substring(2,4)), 0, 0);
                        }
                    }

                    if (rdoto.TimeParcialStop == 1){
                        insertRDO.WaterInjectionTimeParcialStop__c = Time.newInstance(24, 0, 0, 0);
                    }else if(string.valueOf(rdoto.TimeParcialStop) != '' && string.valueOf(rdoto.TimeParcialStop) != '0' && string.valueOf(rdoto.TimeParcialStop) != null){
                        if(string.valueOf(rdoto.TimeParcialStop).length() == 3){
                            insertRDO.WaterInjectionTimeParcialStop__c = Time.newInstance(integer.valueOf(string.valueOf(rdoto.TimeParcialStop).substring(0,1)), integer.valueOf(string.valueOf(rdoto.TimeParcialStop).substring(1,3)), 0, 0);
                        }else if(string.valueOf(rdoto.TimeParcialStop).length() == 2){
                            insertRDO.WaterInjectionTimeParcialStop__c = Time.newInstance(0, rdoto.TimeParcialStop, 0, 0);
                        }else if(string.valueOf(rdoto.TimeParcialStop).length() == 1){
                            insertRDO.WaterInjectionTimeParcialStop__c = Time.newInstance(0, rdoto.TimeParcialStop, 0, 0);
                        }else{
                            insertRDO.WaterInjectionTimeParcialStop__c = Time.newInstance(integer.valueOf(string.valueOf(rdoto.TimeParcialStop).substring(0,2)), integer.valueOf(string.valueOf(rdoto.TimeParcialStop).substring(2,4)), 0, 0);
                        }
                    }

                    if (rdoto.TimeCleaningSRU == 1){
                        insertRDO.WaterInjectionTimeCleanSRU__c = Time.newInstance(24, 0, 0, 0);
                    }else if(string.valueOf(rdoto.TimeCleaningSRU) != '' && string.valueOf(rdoto.TimeCleaningSRU) != '0' && string.valueOf(rdoto.TimeCleaningSRU) != null){
                        if(string.valueOf(rdoto.TimeCleaningSRU).length() == 3){
                            insertRDO.WaterInjectionTimeCleanSRU__c = Time.newInstance(integer.valueOf(string.valueOf(rdoto.TimeCleaningSRU).substring(0,1)), integer.valueOf(string.valueOf(rdoto.TimeCleaningSRU).substring(1,3)), 0, 0);
                        }else if(string.valueOf(rdoto.TimeCleaningSRU).length() == 2){
                            insertRDO.WaterInjectionTimeCleanSRU__c = Time.newInstance(0, rdoto.TimeCleaningSRU, 0, 0);
                        }else if(string.valueOf(rdoto.TimeCleaningSRU).length() == 1){
                            insertRDO.WaterInjectionTimeCleanSRU__c = Time.newInstance(0, rdoto.TimeCleaningSRU, 0, 0);
                        }else{
                            insertRDO.WaterInjectionTimeCleanSRU__c = Time.newInstance(integer.valueOf(string.valueOf(rdoto.TimeCleaningSRU).substring(0,2)), integer.valueOf(string.valueOf(rdoto.TimeCleaningSRU).substring(2,4)), 0, 0);
                        }
                    }

                    insertRDO.DieselConsumCtrlPetrInitialInventory__c = rdoto.InitialInventoryClient;
                    insertRDO.DieselConsumCtrlPetrConsumed__c = rdoto.ConsumedClient;
                    insertRDO.DieselConsumCtrlPetrReceived__c = rdoto.ReceivedClient;
                    insertRDO.DieselConsumCtrlPetrTransPContracted__c = rdoto.TransferClientContract;
                    insertRDO.DieselConsumCtrlContrTransPContracted__c = rdoto.TransferContractClient;
                    insertRDO.DieselConsumCtrlPetrTransContractedP__c = rdoto.TransferContractClient;
                    insertRDO.DieselConsumCtrlContrTransContractedP__c = rdoto.TransferClientContract;
                    insertRDO.DieselConsumCtrlPetrFinalInventory__c = rdoto.FinalInventoryClient;
                    insertRDO.DieselConsumCtrlContrInitialInventory__c = rdoto.InitialInventoryContracted;
                    insertRDO.DieselConsumCtrlContrConsumed__c = rdoto.ConsumedContracted;
                    insertRDO.DieselConsumCtrlContrReceived__c = rdoto.ReceivedContracted;
                    insertRDO.DieselConsumCtrlContrFinalInventory__c = rdoto.FinalInventoryContracted;
                    insertRDO.DieselConsumCtrlTotalInitialInventory__c = rdoto.InitialInventoryTotal;
                    insertRDO.DieselConsumCtrlTotalConsumed__c = rdoto.ConsumedTotal;
                    insertRDO.DieselConsumCtrlTotalReceived__c = rdoto.ReceivedTotal;
                    insertRDO.DieselConsumCtrlTotalTransPContracted__c = rdoto.TransferClientContractTotal;
                    insertRDO.DieselConsumCtrlTotalTransContractedP__c = rdoto.TransferContractClientTotal;
                    insertRDO.DieselConsumCtrlTotalFinalInventory__c = rdoto.FinalInventoryTotal;
                    
                    insertRDO.NaturalGasProduced__c = rdoto.GasProduced;
                    insertRDO.NaturalGasExported__c = rdoto.GasExported;
                    insertRDO.NaturalGasLPFlareBurn__c = rdoto.GasLPFlare;
                    insertRDO.NaturalGasHPFlareBurn__c = rdoto.GasHPFlare;
                    insertRDO.NaturalGasFuel__c = rdoto.GasFuel;
                    insertRDO.NaturalGasInjection__c = rdoto.GasInjected;
                    insertRDO.TotalFlare__c = rdoto.TotalFlare;
                    
                    insertRDO.BurningGasPetrVolume__c = rdoto.VolumeImpToClientGas;
                    insertRDO.BurningGasContrVolume__c = rdoto.VolumeImpToContractedGas;
                    insertRDO.BurningCO2PetrVolume__c = rdoto.VolumeImpToClientCO2;
                    insertRDO.BurningCO2ContrVolume__c = rdoto.VolumeImpToContractedCO2;
                    insertRDO.LocalContentTotalPob__c = rdoto.TotalPOB;
                    insertRDO.LocalContentFixedPob__c = rdoto.FixedPOB;
                    insertRDO.LocalContentNationalPob__c = rdoto.NationalPOB;
                    insertRDO.LocalContentPercentNational__c = rdoto.NationalPercentPOB * 100;
                    insertRDO.LocalContentPetr__c = rdoto.Client;
                    insertRDO.LocalContentPetrCont__c = rdoto.ClientCont;
                    
                    system.debug('insertdro ' + insertRDO);

                    insert insertRDO;

                    for (RDOTO.cls_OcurrencesContracted occurenceJson : rdoto.OcurrencesContracted) {
                        Occurrences__c occuContracted = new Occurrences__c();
                        occuContracted.RDO__c = insertRDO.Id;
                        occuContracted.Item__c = String.valueOf(occurenceJson.Item);
                        occuContracted.Reference__c = occurenceJson.Reference;
                        occuContracted.Contract__c = occurenceJson.Contract;
                        occuContracted.Notes__c = occurenceJson.Notes;
                        occuContracted.Type__c = occurenceJson.OcurrenceType;
                        occuContracted.Status__c = 'Ongoing';
                        //occuContracted.DateOccurrence__c = Date.today();
                        //occuContracted.EndDate__c = Date.today();
                        //occuContracted.Deadline__c = Date.today();
        
                        occurencesList.add(occuContracted);                                
                    }
        
                    /*for (RDOTO.cls_OcurrencesClient occurenceJson : rdoto.OcurrencesClient) {
                        Occurrences__c occuClient = new Occurrences__c();
                        occuClient.RDO__c = insertRDO.Id;
                        occuClient.Item__c = String.valueOf(occurenceJson.Item);
                        occuClient.Reference__c = occurenceJson.Reference;
                        occuClient.Contract__c = occurenceJson.Contract;
                        occuClient.Notes__c = occurenceJson.Notes;
                        occuClient.Type__c = 'Client';
                        occuClient.Status__c = 'Ongoing';
                        //occuClient.DateOccurrence__c = Date.today();
                        //occuClient.EndDate__c = Date.today();
                        //occuClient.Deadline__c = Date.today();
        
                        occurencesList.add(occuClient);
                    }*/
        
                    /*for (RDOTO.cls_DailyRatesRates dRateJson : rdoto.DailyRatesRates) {
                        DailyRates__c dRateRates = new DailyRates__c();
                        dRateRates.RDO__c = insertRDO.Id;
                        if (dRateJson.StartTime == 1){
                            dRateRates.Start__c = Time.newInstance(24, 0, 0, 0);
                        }else if(string.valueOf(dRateJson.StartTime) != '' && string.valueOf(dRateJson.StartTime) != '0' && string.valueOf(dRateJson.StartTime) != null){
                            if(string.valueOf(dRateJson.StartTime).length() == 3){
                                dRateRates.Start__c = Time.newInstance(integer.valueOf(string.valueOf(dRateJson.StartTime).substring(0,1)), integer.valueOf(string.valueOf(dRateJson.StartTime).substring(1,3)), 0, 0);
                            }else{
                                dRateRates.Start__c = Time.newInstance(integer.valueOf(string.valueOf(dRateJson.StartTime).substring(0,2)), integer.valueOf(string.valueOf(dRateJson.StartTime).substring(2,4)), 0, 0);
                            }
                        }
        
                        if (dRateJson.EndTime == 1){
                            dRateRates.End__c = Time.newInstance(24, 0, 0, 0);
                        }else if(string.valueOf(dRateJson.EndTime) != '' && string.valueOf(dRateJson.EndTime) != '0' && string.valueOf(dRateJson.EndTime) != null){    
                            if(string.valueOf(dRateJson.EndTime).length() == 3){
                                dRateRates.End__c = Time.newInstance(integer.valueOf(string.valueOf(dRateJson.EndTime).substring(0,1)) , integer.valueOf(string.valueOf(dRateJson.EndTime).substring(1,3)), 0, 0);
                            }else{
                                dRateRates.End__c = Time.newInstance(integer.valueOf(string.valueOf(dRateJson.EndTime).substring(0,2)) , integer.valueOf(string.valueOf(dRateJson.EndTime).substring(2,4)), 0, 0);
                            }
                        }
                        
                        if (dRateJson.OcurrenceTime == '1'){
                            dRateRates.TimeOccurrence__c = Time.newInstance(24, 0, 0, 0);
                        }else if(string.valueOf(dRateJson.OcurrenceTime) != '' && string.valueOf(dRateJson.OcurrenceTime) != '0' && string.valueOf(dRateJson.OcurrenceTime) != null){
                            splitTime = string.valueOf(dRateJson.OcurrenceTime).split(':');
                            dRateRates.TimeOccurrence__c = Time.newInstance(integer.valueOf(splitTime[0]), integer.valueOf(splitTime[1]), 0, 0);
                            
                        }
        
                        if (dRateJson.ExtraTime == '1'){
                            dRateRates.ExtraTime__c = Time.newInstance(24, 0, 0, 0);
                        }else if(string.valueOf(dRateJson.ExtraTime) != '' && string.valueOf(dRateJson.ExtraTime) != '0' && string.valueOf(dRateJson.ExtraTime) != null){
                            splitTime = string.valueOf(dRateJson.ExtraTime).split(':');
                            dRateRates.ExtraTime__c = Time.newInstance(integer.valueOf(splitTime[0]), integer.valueOf(splitTime[1]), 0, 0);
                        }
                        
                        if (string.valueof(dRateJson.PercentReduction) != ''){
                            dRateRates.PercentReduction__c = dRateJson.PercentReduction;
                        }
                        
                        dRateRates.Description__c = dRateJson.Description;
                        dRateRates.ItemAnnex__c = dRateJson.AnnexTo;
                        dRateRates.Contract__c = dRateJson.Contract;                                
                        dRateRates.Type__c = 'Rate';
        
                        dailyRatesList.add(dRateRates);
                    }*/
        
                    for (RDOTO.cls_DailyRatesReduction dReductionJson : rdoto.DailyRatesReduction) {
                        DailyRates__c dRateReduction = new DailyRates__c();
                        dRateReduction.RDO__c = insertRDO.Id;

                        if (dReductionJson.StartTime == '1'){
                            dRateReduction.Start__c = Time.newInstance(24, 0, 0, 0);
                        }else if(string.valueOf(dReductionJson.StartTime) != '' && string.valueOf(dReductionJson.StartTime) != null){
                            if(string.valueOf(dReductionJson.StartTime).length() == 3){
                                dRateReduction.Start__c = Time.newInstance(integer.valueOf(string.valueOf(dReductionJson.StartTime).substring(0,1)) , integer.valueOf(string.valueOf(dReductionJson.StartTime).substring(1,3)), 0, 0);
                            }else if(string.valueOf(dReductionJson.StartTime).length() == 2){
                                dRateReduction.Start__c = Time.newInstance(0, integer.valueOf(string.valueOf(dReductionJson.StartTime)), 0, 0);
                            }else if(string.valueOf(dReductionJson.StartTime).length() == 1){
                                dRateReduction.Start__c = Time.newInstance(0, integer.valueOf(string.valueOf(dReductionJson.StartTime)), 0, 0);
                            }else{
                                dRateReduction.Start__c = Time.newInstance(integer.valueOf(string.valueOf(dReductionJson.StartTime).substring(0,2)) , integer.valueOf(string.valueOf(dReductionJson.StartTime).substring(2,4)), 0, 0);
                            }
                        }
        
                        if (dReductionJson.EndTime == '1'){
                            dRateReduction.End__c = Time.newInstance(24, 0, 0, 0);
                        }else if(string.valueOf(dReductionJson.EndTime) != '' && string.valueOf(dReductionJson.EndTime) != null){    
                            if(string.valueOf(dReductionJson.EndTime).length() == 3){
                                dRateReduction.End__c = Time.newInstance(integer.valueOf(string.valueOf(dReductionJson.EndTime).substring(0,1)) , integer.valueOf(string.valueOf(dReductionJson.EndTime).substring(1,3)), 0, 0);
                            }else if(string.valueOf(dReductionJson.EndTime).length() == 2){
                                dRateReduction.End__c = Time.newInstance(0 , integer.valueOf(string.valueOf(dReductionJson.EndTime)), 0, 0);
                            }else if(string.valueOf(dReductionJson.EndTime).length() == 1){
                                dRateReduction.End__c = Time.newInstance(0 , integer.valueOf(string.valueOf(dReductionJson.EndTime)), 0, 0);
                            }else{
                                dRateReduction.End__c = Time.newInstance(integer.valueOf(string.valueOf(dReductionJson.EndTime).substring(0,2)) , integer.valueOf(string.valueOf(dReductionJson.EndTime).substring(2,4)), 0, 0);
                            }
                        }
                        
                        if (dReductionJson.OcurrenceTime == '1'){
                            dRateReduction.TimeOccurrence__c = Time.newInstance(24, 0, 0, 0);
                        }else if(string.valueOf(dReductionJson.OcurrenceTime) != '' && string.valueOf(dReductionJson.OcurrenceTime) != '0' && string.valueOf(dReductionJson.OcurrenceTime) != null){
                            splitTime = string.valueOf(dReductionJson.OcurrenceTime).split(':');
                            dRateReduction.TimeOccurrence__c = Time.newInstance(integer.valueOf(splitTime[0]) , integer.valueOf(splitTime[1]), 0, 0);
                        }
        
                        if (dReductionJson.ExtraTime == '1'){
                            dRateReduction.ExtraTime__c = Time.newInstance(24, 0, 0, 0);
                        }else if(string.valueOf(dReductionJson.ExtraTime) != '' && string.valueOf(dReductionJson.ExtraTime) != '0' && string.valueOf(dReductionJson.ExtraTime) != null){
                            system.debug('extra time ' + dReductionJson.ExtraTime);
                            splitTime = string.valueOf(dReductionJson.ExtraTime).split(':');
                            dRateReduction.ExtraTime__c = Time.newInstance(integer.valueOf(splitTime[0]) , integer.valueOf(splitTime[1]), 0, 0);
                            
                        }

                        if (string.valueof(dReductionJson.PercentReduction) != ''){
                            dRateReduction.PercentReduction__c = dReductionJson.PercentReduction;
                        }
                        
                        dRateReduction.Description__c = dReductionJson.Description;
                        dRateReduction.ItemAnnex__c = dReductionJson.AnnexTo;
                        dRateReduction.Contract__c = dReductionJson.Contract;
                        String verifyDesc = dReductionJson.Description;
                        verifyDesc = verifyDesc.toUpperCase();

    					if(verifyDesc.contains('ISENCAO DE PAGAMENTO')){
        					dRateReduction.Type__c = 'Rate Reduction';
    					}else{
        					dRateReduction.Type__c = dReductionJson.DailyType;
    					}                        
        
                        dailyRatesList.add(dRateReduction);
                    }
        
                    if (occurencesList.size() > 0){
                        System.debug(occurencesList);
                        insert occurencesList;
                    }
        
                    if (dailyRatesList.size() > 0){
                        System.debug(dailyRatesList);
                        insert dailyRatesList;
                    }

                    returnblob.add('201');
                    returnblob.add('{ "RDOTransfer" : "RDO created sucessfuly. RDO Number '+rdoto.NumRDO+'" }');
                    returnblob.add(insertRDO.Id);
                    return returnblob;

                }else{
                    returnblob.add('401');
                    returnblob.add('{ "RDOTransferError" : "Charter Contract not found. RDO Number ' + rdoto.NumRDO + '" }');
                    return returnblob;
                }
            }else{
                returnblob.add('401');
                returnblob.add('{ "RDOTransferError" : "Service Contract not found. RDO Number ' + rdoto.NumRDO + '" }');
                return returnblob;
            }
        }else{
            returnblob.add('401');
            returnblob.add('{ "RDOTransferError" : "Vessel not found. RDO Number ' + rdoto.NumRDO + '" }');
            return returnblob;
        }        
    }

    public void createOrUpdateBOM (String receivedRDO)
    {
        Map<Integer, String> mapMonthConversion = new Map<Integer, String>();
        Map<Id,List<RDO__c>> mapRDOPorBOM = new Map<Id,List<RDO__c>>();
        List<RDO__c> lstRDO = new List<RDO__c>();
        List<RDO__c> lstRDOBOM = new List<RDO__c>();
        List<VesselContract__c> lstVesselContract = new List<VesselContract__c>();
        List<BOM__c> lstBom = new List<BOM__c>();
        List<BOM__c> lstPastBom = new List<BOM__c>();
        List<BOM__c> lstBomUpdate = new List<BOM__c>();
        Set<Id> setIdBOM = new Set<Id>();
        VesselContract__c vesselContract = new VesselContract__c();
        RDO__c rdoInstance = new RDO__c();
        Id servicesContractId;
        Date contractBOMEndDate;

        //Fill the month map 
        mapMonthConversion.put(1, 'January');
        mapMonthConversion.put(2, 'February');
        mapMonthConversion.put(3, 'March');
        mapMonthConversion.put(4, 'April');
        mapMonthConversion.put(5, 'May');
        mapMonthConversion.put(6, 'June');
        mapMonthConversion.put(7, 'July');
        mapMonthConversion.put(8, 'August');
        mapMonthConversion.put(9, 'September');
        mapMonthConversion.put(10, 'October');
        mapMonthConversion.put(11, 'November');
        mapMonthConversion.put(12, 'December');

        lstRDO = RDODAO.getRDOById(receivedRDO);
        
        for(RDO__c rdo : lstRDO)
        {   
            if(rdo.ServicesContract__c != null)
            {
                servicesContractId = rdo.ServicesContract__c;
            }
        }

        if(servicesContractId != null)
            lstVesselContract = VesselContractDAO.getVesselContractById(servicesContractId);

        if(lstVesselContract != null)
        {
            for(VesselContract__c contract : lstVesselContract)
            {
                vesselContract.Vessel__c = contract.Vessel__c;
                vesselContract.BOMStartDate__c = contract.BOMStartDate__c;
                contractBOMEndDate = contract.BOMEndDate__c;
            }

            lstBom = BOMDAO.getBOMByVesselAndDate(vesselContract.Vessel__c, vesselContract.BOMStartDate__c, contractBOMEndDate);
        }

        if(!lstRDO.isEmpty()) 
        {
            rdoInstance = lstRDO[0];
        }
        
        if(!lstBom.isEmpty())
        {
            for(BOM__c bom : lstBom)
            {
                setIdBOM.add(bom.Id);
            }
        }
        
        if(!lstBom.isEmpty())
        {
            for(RDO__c rdoItem : RDODAO.getRDOsByIdBOMList(setIdBOM, 'Inactive'))
            {
                if(!mapRDOPorBOM.containsKey(rdoItem.BOM__c))
                    mapRDOPorBOM.put(rdoItem.BOM__c, new List<RDO__c>());

                mapRDOPorBOM.get(rdoItem.BOM__c).add(rdoItem);
            }

            System.debug('### MAP RDOS POR BOM ' + mapRDOPorBOM);
            
            for(BOM__c bom : lstBom)
            {
                if(rdoInstance.Date__c >= bom.StartDate__c && rdoInstance.Date__c <= bom.EndDate__c)
                {
                    rdoInstance.BOM__c = bom.Id;
                }
                else
                {
                    lstPastBom = BOMDAO.getBOMByVesselAndPastDate(vesselContract.Vessel__c, rdoInstance.Date__c);
    
                    if(!lstPastBom.isEmpty())
                    {
                        for(BOM__c pastBOM : lstPastBom)
                        {
                            rdoInstance.BOM__c = pastBOM.Id;
                        }
                    }
                }
                
                lstRDOBOM = mapRDOPorBOM.get(bom.Id);
                bom.SumDailyRates__c = 0;
                bom.SumDieselConsumed__c = 0;

                if(lstRDOBOM != null && !lstRDOBOM.IsEmpty())
                {
                    System.debug('### CALCULO SUM RATE');

                    for(RDO__c rdoCalc : lstRDOBOM)
                    {
                        if(rdoInstance.Id == rdoCalc.Id)
                            continue;

                        System.debug('### RDO RATE ' + rdoCalc.DieselConsumCtrlContrConsumed__c);

                        if(rdoCalc.RateDeltaDaily__c != null)
                            bom.SumDailyRates__c += rdoCalc.RateDeltaDaily__c;

                        //if(rdoCalc.DieselConsumCtrlContrConsumed__c != null)
                            //bom.SumDieselConsumed__c += rdoCalc.DieselConsumCtrlContrConsumed__c;
                    }
                }

                if(rdoInstance.RateDeltaDaily__c != null)
                    bom.SumDailyRates__c += rdoInstance.RateDeltaDaily__c;

                //if(rdoInstance.DieselConsumCtrlContrConsumed__c != null)
                    //bom.SumDieselConsumed__c += rdoInstance.DieselConsumCtrlContrConsumed__c;

                lstBomUpdate.add(bom);
                update rdoInstance;
            }
            
            if(!lstBomUpdate.isEmpty())
            {
                System.debug('### BOMS ATUALIZAR ' + lstBomUpdate);
                update lstBomUpdate;
            }
        } 

        if(lstBom.isEmpty())
        {
            BOM__c newBOM = new BOM__c();
            newBOM.Vessel__c = vesselContract.Vessel__c;
            newBOM.ReferenceMonth__c = mapMonthConversion.get(contractBOMEndDate.month()) + '/' + contractBOMEndDate.year();
            newBOM.StartDate__c = vesselContract.BOMStartDate__c;
            newBOM.EndDate__c = contractBOMEndDate;
            newBOM.SumDailyRates__c = rdoInstance.RateDeltaDaily__c;
            if(rdoInstance.DieselConsumCtrlContrConsumed__c != null){
                newBOM.SumDieselConsumed__c = rdoInstance.DieselConsumCtrlContrConsumed__c;
            }
            
            insert newBOM;
        
            if(rdoInstance.Date__c >= newBOM.StartDate__c && rdoInstance.Date__c <= newBOM.EndDate__c)
            {
                rdoInstance.BOM__c = newBOM.Id;
                update rdoInstance;
            }
            else 
            {
                lstPastBom = BOMDAO.getBOMByVesselAndPastDate(vesselContract.Vessel__c, rdoInstance.Date__c);

                if(!lstPastBom.isEmpty())
                {
                    for(BOM__c pastBOM : lstPastBom)
                    {
                        rdoInstance.BOM__c = pastBOM.Id;
                        update rdoInstance;
                    }
                }
            }
        }

        fillRevenueField(JSON.serialize(rdoInstance));
        calculateRDOfields(rdoInstance);
    }

    @future
    public static void fillRevenueField (String jsonRDO)
    {
        RDO__C receivedRDO = (RDO__C)JSON.deserialize(jsonRDO, RDO__C.class);
        List<BOM__c> lstBOM = new List<BOM__c>();
        List<RDO__c> lstBOMRDOs = new List<RDO__c>();
        List<VesselContract__c> lstVesselConServices = new List<VesselContract__c>();
        List<VesselContract__c> lstVesselConCharter = new List<VesselContract__c>();
        List<ContractDailyRateHistory__c> lstDailyRateServices = new List<ContractDailyRateHistory__c>();
        List<ContractDailyRateHistory__c> lstDailyRateCharter = new List<ContractDailyRateHistory__c>();
        BOM__c bomInstance = new BOM__c();
        VesselContract__c vesselConServices = new VesselContract__c();
        VesselContract__c vesselConCharter = new VesselContract__c();
        Double dailyRateBRL = 0.00;
        Double dailyRateUSD = 0.00;

        System.debug('receivedRDO.BOM__c -- ' + receivedRDO.BOM__c);
        
        if(receivedRDO.BOM__c != null && receivedRDO.RateDeltaDaily__c != null)
        {
            lstBOM = BOMDAO.getBOMById(receivedRDO.BOM__c);
            lstVesselConServices = VesselContractDAO.getVesselContractByIdAndType(receivedRDO.ServicesContract__c, 'Services');
            lstVesselConCharter = VesselContractDAO.getVesselContractByIdAndType(receivedRDO.CharterContract__c, 'Charter');
        }
       
        System.debug('lstBOM -- ' + lstBOM);
        System.debug('lstVesselConServices -- ' + lstVesselConServices);
        System.debug('lstVesselConCharter -- ' + lstVesselConCharter);


        if(!lstBOM.isEmpty())
        {
            bomInstance = lstBOM[0];
        } 
        else
        {
            return;
        }

        lstBOMRDOs = RDODAO.getRDOsByIdBOM(bomInstance.Id, 'Inactive');

        bomInstance.RDOsDailyRateSum__c = 0;
        bomInstance.RDOsDailyRateSumServices__c = 0;

        //Sum of RDOs Daily Rates
        for(RDO__c rdo : lstBOMRDOs)
        {
            if(rdo.RateDeltaDaily__c != null)
            {
                System.debug('bomInstance.RDOsDailyRateSum__c before -- ' + bomInstance.RDOsDailyRateSum__c);
                bomInstance.RDOsDailyRateSum__c += rdo.RateDeltaDaily__c;
                System.debug('bomInstance.RDOsDailyRateSum__c after -- ' + bomInstance.RDOsDailyRateSum__c);
            }

            if(rdo.DailyRateServices__c != null)
            {
                bomInstance.RDOsDailyRateSumServices__c += rdo.DailyRateServices__c;
            }
        }

        bomInstance.SumDieselConsumed__c = 0;
        
        //Sum of Diesel
        for(RDO__c rdo : lstBOMRDOs)
        {
            if(rdo.DieselConsumCtrlContrConsumed__c != null)
            {
                bomInstance.SumDieselConsumed__c += rdo.DieselConsumCtrlContrConsumed__c;
            }
        }

        if(!lstVesselConServices.isEmpty())
        {
            vesselConServices = lstVesselConServices[0];
            lstDailyRateServices = ContractDailyRateHistoryDAO.getContractDailyRateHistoryByContractAndBOMDate(vesselConServices.Id, bomInstance.EndDate__c);

            if(!lstDailyRateServices.isEmpty())
            {
                for(ContractDailyRateHistory__c actualDailyRateBRL : lstDailyRateServices)
                {
                    dailyRateBRL = actualDailyRateBRL.DailyRate__c;
                    System.debug('dailyRateBRL -- ' + dailyRateBRL);
                    bomInstance.RevenueServices__c = bomInstance.RDOsDailyRateSumServices__c * dailyRateBRL;
                    bomInstance.DailyRateBRL__c = actualDailyRateBRL.DailyRate__c;
                }
            }
        }

        if(!lstVesselConCharter.isEmpty())
        {
            vesselConCharter = lstVesselConCharter[0]; 
            lstDailyRateCharter = ContractDailyRateHistoryDAO.getContractDailyRateHistoryByContractAndBOMDate(vesselConCharter.Id, bomInstance.EndDate__c);

            if(!lstDailyRateCharter.isEmpty())
            {
                for(ContractDailyRateHistory__c actualDailyRateUSD : lstDailyRateCharter)
                {
                    dailyRateUSD = actualDailyRateUSD.DailyRate__c;
                    System.debug('dailyRateUSD -- ' + dailyRateUSD);
                    bomInstance.RevenueCharter__c = bomInstance.RDOsDailyRateSum__c * dailyRateUSD;
                    bomInstance.DailyRateUSD__c = actualDailyRateUSD.DailyRate__c;
                }
            }
        }

        update bomInstance;
        fillTotalLossesFields(receivedRDO);
    }

    public void calculateRDOfields(RDO__c receivedRDO){
        //calc 1 = "EQUIPE DE MERGULHO" + "POB PETROBRAS"
        //calc 2 = 500 + QUEIMA LP FLARE + QUEIMA HP FLARE
        //calc 3 = PRODUZIDO + IMPORTADO + 500
        //calc 4 = somatoria VOLUME QUEIMADO IMPUTÁVEL À CONTRATADA
        List<RDO__c> lstRDOs = new List<RDO__c>();
        List<VesselContract__c> lstMealAllowance = new List<VesselContract__c>();
        BOM__c updBom = new BOM__c();
        Decimal pilot = 0;
        Decimal MealAllowance = 0;
        Decimal calc1 = 0;
        Decimal calc2 = 0;
        Decimal calc3 = 0;        
        Decimal calc4 = 0;
        Decimal calc5 = 0;

        lstMealAllowance = VesselContractDAO.getMealAllowanceByNumber(receivedRDO.ServicesContract__c);
        lstRDOs = RDODAO.getRDOsByIdBOM(receivedRDO.BOM__c, 'Inactive');

        for (VesselContract__c itemMeal : lstMealAllowance) {
            MealAllowance = MealAllowance + itemMeal.MealAllowance__c;
            pilot = itemMeal.Pilot__c;
        }
        
        if(pilot == null)
        {
            pilot = 0;
        }

        for (RDO__c itemRDO : lstRDOs) {
            System.debug('client cont ' + itemRDO.LocalContentPetrCont__c);
            System.debug('client ' + itemRDO.LocalContentPetr__c);
            System.debug('pilot ' + pilot);
            System.debug('lstRDOs ' + lstRDOs);
            
            if(itemRDO.LocalContentPetrCont__c != null && itemRDO.LocalContentPetr__c != null){
                calc1 = calc1 + (itemRDO.LocalContentPetrCont__c + itemRDO.LocalContentPetr__c);
            }

            if(itemRDO.NaturalGasHPFlareBurn__c != null && itemRDO.NaturalGasLPFlareBurn__c != null && pilot != null){
                calc2 = calc2 + (itemRDO.NaturalGasHPFlareBurn__c + itemRDO.NaturalGasLPFlareBurn__c + pilot);
            }

            if(itemRDO.NaturalGasProduced__c != null && itemRDO.NaturalGasExported__c != null && pilot != null){
                calc3 = calc3 + (itemRDO.NaturalGasProduced__c + itemRDO.NaturalGasExported__c + pilot);
            }

            if(itemRDO.BurningGasContrVolume__c != null){
                calc4 = calc4 + (itemRDO.BurningGasContrVolume__c);
            }

            if(itemRDO.NaturalGasProduced__c != null && pilot != null){
                calc5 = calc5 + (itemRDO.NaturalGasProduced__c + pilot);
            }
            
            System.debug('calc4 ' + calc4);
        }

        Decimal calc1Final = ((3*calc1));

        List<BOM__c> lstBOM = BOMDAO.getBOMById(lstRDOs[0].BOM__c);

        if(lstBOM.size() <= 0)
        {
            return;
        }
        else
        {
            updBom = lstBOM[0];
            
            if(calc3 != 0)
            {
                if(updBom.VesselShortName__c == 'MV27')
                {
                    Decimal calc23Final = (1 - (calc2)/(calc3)) * 100;
                    System.debug('calc23Final ' + calc23Final);

                    updBom.IUGA__c = calc23Final;
                } else
                {
                    Decimal calc25Final = (1 - (calc2)/(calc5)) * 100;
                    System.debug('calc25Final ' + calc25Final);

                    updBom.IUGA__c = calc25Final;
                }
                
            }
                          
            updBom.POBClient__c = calc1Final;
            updBom.BurnedGasVolume__c = calc4;

            update updBom;
        }
    }

    public void setContractsByVessel(List<RDO__c> lstRDO){
        List<RDO__c> lstUpdRDO = new List<RDO__c>();
        List<VesselContract__c> updCharter = new List<VesselContract__c>();
        List<VesselContract__c> updService = new List<VesselContract__c>();

        for (RDO__c itemRDO : lstRDO) {
            if (itemRDO.CharterContract__c == null || itemRDO.ServicesContract__c == null){
                updCharter = VesselContractDAO.getContractByVesselID(itemRDO.Vessel__c, 'Charter');
                updService = VesselContractDAO.getContractByVesselID(itemRDO.Vessel__c, 'Services');

                RDO__c updRDO = new RDO__c();
                updRDO.id = itemRDO.Id;
                updRDO.CharterContract__c = updCharter[0].id;
                updRDO.ServicesContract__c = updService[0].id;

                lstUpdRDO.add(updRDO);
            }
        }

        if (lstUpdRDO.size() > 0){
            update lstUpdRDO;
        }
    }

    public void calculatePrioritization(List<RDO__c> lstRDO)
    {
        for(RDO__c rdo : lstRDO)
        {
            if(rdo.WITotal__c >= rdo.WaterInjectionDailyQuota__c)
            {
                rdo.Prioritization__c = null;
                return;
            }

            if(rdo.WaterInjectionTimeTotalStop__c == null && rdo.WaterInjectionTimeParcialStop__c == null)
            {
                return;
            }
        }

        Double priorization = 0;
        String timeTotalStopRDO = '';
        String timeParcialStopRDO = '';
        Double timeTotal = 0;
        Double timeParcial = 0;
        Double percentTimeTotal = 0;
        Double percentTimeParcial = 0;
        Double timeSumFinal = 0;
        Double minutesTotalStop = 0;
        Double minutesParcialStop = 0;

        for(RDO__c rdo : lstRDO)
        {
            timeTotalStopRDO = String.valueOf(rdo.WaterInjectionTimeTotalStop__c);
            timeParcialStopRDO = String.valueOf(rdo.WaterInjectionTimeParcialStop__c);

            if(timeTotalStopRDO == null)
                timeTotalStopRDO = '00:00';

            if(timeParcialStopRDO == null)
                timeParcialStopRDO = '00:00';

            String[] timeTotalStopSplit = timeTotalStopRDO.split(':');
            String[] timeParcialStopSplit = timeParcialStopRDO.split(':');

            minutesTotalStop = (Double.valueOf(timeTotalStopSplit[0]) * 60) + Double.valueOf(timeTotalStopSplit[1]);
            minutesParcialStop = (Double.valueOf(timeParcialStopSplit[0]) * 60) + Double.valueOf(timeParcialStopSplit[1]);

            percentTimeTotal = (minutesTotalStop * 10) / 1440;
            percentTimeParcial = (minutesParcialStop * 5) / 1440;

            timeSumFinal = percentTimeTotal + percentTimeParcial;

            System.debug('minutesTotalStop -- ' + minutesTotalStop);
            System.debug('minutesParcialStop -- ' + minutesParcialStop);
            System.debug('percentTimeTotal -- ' + percentTimeTotal);
            System.debug('percentTimeParcial -- ' + percentTimeParcial);

            System.debug('timeSumFinal -- ' + timeSumFinal);
        }

        for(RDO__c rdo : lstRDO)
        {
            if(rdo.WaterInjectionUninjectedVolume__c != null && rdo.WaterInjectionUninjectedVolume__c != 0)
            {
                priorization = (timeSumFinal / rdo.WaterInjectionUninjectedVolume__c) * 10;
                rdo.Prioritization__c = priorization;
            }
        }
        
        System.debug('priorization -- ' + priorization);
    }
    
    public void callCreateOrUpdateBOM(List<RDO__c> lstRDO)
    {
        for(RDO__c rdo : lstRDO)
        {
            if(rdo.BOM__c == null)
            {
                createOrUpdateBOM(rdo.Id);
            }
        }
    }
    
    public static void fillTotalLossesFields (RDO__c receivedRDO)
    {
        List<BOM__c> lstBOM = new List<BOM__c>();
        List<RDO__c> lstBOMRDOs = new List<RDO__c>();
        List<VesselContract__c> lstVesselConServices = new List<VesselContract__c>();
        List<VesselContract__c> lstVesselConCharter = new List<VesselContract__c>();
        BOM__c bomInstance = new BOM__c();
        VesselContract__c vesselConServices = new VesselContract__c();
        VesselContract__c vesselConCharter = new VesselContract__c();
        Double dailyRateUSD = 0;
        Double dailyRateBRL = 0;

        if(receivedRDO.BOM__c != null)
        {
            lstBOM = BOMDAO.getBOMById(receivedRDO.BOM__c);
        }

        if(!lstBOM.isEmpty())
        {
            bomInstance = lstBOM[0];
        } 
        else
        {
            return;
        }

        if(bomInstance.DailyRateBRL__c != null)
            bomInstance.TotalLossesBRLAuto__c = bomInstance.TotalDailyRateLossesServices__c * bomInstance.DailyRateBRL__c;

        if(bomInstance.DailyRateUSD__c != null)    
            bomInstance.TotalLossesUSDAuto__c = bomInstance.DailyRateLosses__c  * bomInstance.DailyRateUSD__c;

        update bomInstance;
    }

    public void recalculateSumFields(List<RDO__c> lstRDO)
    {
        List<BOM__c> lstBOM = new List<BOM__c>();
        List<RDO__c> lstBOMRDOs = new List<RDO__c>();
        BOM__c bomInstance = new BOM__c();
        RDO__c receivedRDO = lstRDO[0];
        Decimal calc1 = 0;
        Decimal calc1Final = 0;
    
        if(receivedRDO.BOM__c != null)
        {
            lstBOM = BOMDAO.getBOMById(receivedRDO.BOM__c);
        }
       
        if(!lstBOM.isEmpty())
        {
            bomInstance = lstBOM[0];
        } 
        else
        {
            return;
        }

        lstBOMRDOs = RDODAO.getRDOsByIdBOM(bomInstance.Id, 'Inactive');

        bomInstance.RDOsDailyRateSum__c = 0;
        bomInstance.RDOsDailyRateSumServices__c = 0;
        bomInstance.SumDieselConsumed__c = 0;
        bomInstance.BurnedGasVolume__c = 0;
        bomInstance.POBClient__c = 0;

        for(RDO__c rdo : lstBOMRDOs)
        {
            //Sum of RDOs Daily Rates Charter
            if(rdo.RateDeltaDaily__c != null)
            {
                bomInstance.RDOsDailyRateSum__c += rdo.RateDeltaDaily__c;
            }

            //Sum of RDOs Daily Rates Services
            if(rdo.DailyRateServices__c != null)
            {
                bomInstance.RDOsDailyRateSumServices__c += rdo.DailyRateServices__c;
            }
       
            //Sum of Diesel
            if(rdo.DieselConsumCtrlContrConsumed__c != null)
            {
                bomInstance.SumDieselConsumed__c += rdo.DieselConsumCtrlContrConsumed__c;
            }

            //Gas Flaring Volume
            if(rdo.BurningGasContrVolume__c != null)
            {
                bomInstance.BurnedGasVolume__c += rdo.BurningGasContrVolume__c;
            }

            //POB
            if(rdo.LocalContentPetrCont__c == null)
            {
                rdo.LocalContentPetrCont__c = 0;
            }

            if(rdo.LocalContentPetr__c == null)
            {
                rdo.LocalContentPetr__c = 0;
            }

            calc1 = calc1 + (rdo.LocalContentPetrCont__c + rdo.LocalContentPetr__c);
            calc1Final = 3 * calc1;

            bomInstance.POBClient__c = calc1Final;
        }
        
        update bomInstance;
    }

    public void formatTimeFields(List<RDO__c> lstRDO){        
        //rdo
        //WaterInjectionTimeTotalStop__c = WITimeTotalStop__c
        //WaterInjectionTimeParcialStop__c = WITimeParcialStop__c
        //WaterInjectionTimeCleanSRU__c = WITimeCleanSRU__c
        //TotalTimeService__c = TTService__c
        //TotalTimeCharter__c = TTCharter__c

        //daily rate
        //TimeOccurrence__c

        List<RDO__c> updateLst = new List<RDO__c>();
        String[] timeSplit;

        for (RDO__C singleRecord : lstRDO) {
            RDO__c singleRow = new RDO__c();
            singleRow.Id = singleRecord.Id;

            //WaterInjectionTimeTotalStop__c
            if (singleRecord.WaterInjectionTimeTotalStop__c == null && singleRecord.WITimeTotalStop__c == null) {
                singleRow.WITimeTotalStop__c = '';
            }else if(singleRecord.WaterInjectionTimeTotalStop__c == time.newInstance(24, 0, 0, 0)){
                singleRow.WITimeTotalStop__c = '24:00:00';
            }else if(singleRecord.WaterInjectionTimeTotalStop__c != null && String.valueOf(singleRecord.WaterInjectionTimeTotalStop__c.hour()).length() == 1){
                if(String.valueOf(singleRecord.WaterInjectionTimeTotalStop__c.minute()).length() == 1){
                    singleRow.WITimeTotalStop__c = '0' + String.valueOf(singleRecord.WaterInjectionTimeTotalStop__c.hour()) + ':0' + String.valueOf(singleRecord.WaterInjectionTimeTotalStop__c.minute()) + ':00';
                }else{
                    singleRow.WITimeTotalStop__c = '0' + String.valueOf(singleRecord.WaterInjectionTimeTotalStop__c.hour()) + ':' + String.valueOf(singleRecord.WaterInjectionTimeTotalStop__c.minute()) + ':00';
                }
            }else if(singleRecord.WaterInjectionTimeTotalStop__c != null && String.valueOf(singleRecord.WaterInjectionTimeTotalStop__c.minute()).length() == 1){
                singleRow.WITimeTotalStop__c = String.valueOf(singleRecord.WaterInjectionTimeTotalStop__c.hour()) + ':0' + String.valueOf(singleRecord.WaterInjectionTimeTotalStop__c.minute()) + ':00';
            }else if(singleRecord.WaterInjectionTimeTotalStop__c != null){
                singleRow.WITimeTotalStop__c = String.valueOf(singleRecord.WaterInjectionTimeTotalStop__c.hour()) + ':' + String.valueOf(singleRecord.WaterInjectionTimeTotalStop__c.minute()) + ':00';
            }else if(singleRecord.WaterInjectionTimeTotalStop__c == null && singleRecord.WITimeTotalStop__c != null) {
                timeSplit = singleRecord.WITimeTotalStop__c.split(':');

                if(timeSplit[0].length() == 1){
                    if(timeSplit[1].length() == 1){ 
                        singleRow.WITimeTotalStop__c = '0' + timeSplit[0] + ':0' + timeSplit[1] + ':00';
                    } else{
                        singleRow.WITimeTotalStop__c = '0' + timeSplit[0] + ':' + timeSplit[1] + ':00';
                    }
                } else if(timeSplit[1].length() == 1){
                    singleRow.WITimeTotalStop__c = timeSplit[0] + ':0' + timeSplit[1] + ':00';
                } else{
                    singleRow.WITimeTotalStop__c = timeSplit[0] + ':' + timeSplit[1] + ':00';
                }
            }

            //WaterInjectionTimeParcialStop__c
            if (singleRecord.WaterInjectionTimeParcialStop__c == null && singleRecord.WITimeParcialStop__c == null) {
                singleRow.WITimeParcialStop__c = '';
            }else if(singleRecord.WaterInjectionTimeParcialStop__c == time.newInstance(24, 0, 0, 0)){
                singleRow.WITimeParcialStop__c = '24:00:00';
            }else if(singleRecord.WaterInjectionTimeParcialStop__c != null && String.valueOf(singleRecord.WaterInjectionTimeParcialStop__c.hour()).length() == 1){
                if(String.valueOf(singleRecord.WaterInjectionTimeParcialStop__c.minute()).length() == 1){
                    singleRow.WITimeParcialStop__c = '0' + String.valueOf(singleRecord.WaterInjectionTimeParcialStop__c.hour()) + ':0' + String.valueOf(singleRecord.WaterInjectionTimeParcialStop__c.minute()) + ':00';
                }else{
                    singleRow.WITimeParcialStop__c = '0' + String.valueOf(singleRecord.WaterInjectionTimeParcialStop__c.hour()) + ':' + String.valueOf(singleRecord.WaterInjectionTimeParcialStop__c.minute()) + ':00';
                }
            }else if(singleRecord.WaterInjectionTimeParcialStop__c != null && String.valueOf(singleRecord.WaterInjectionTimeParcialStop__c.minute()).length() == 1){
                singleRow.WITimeParcialStop__c = String.valueOf(singleRecord.WaterInjectionTimeParcialStop__c.hour()) + ':0' + String.valueOf(singleRecord.WaterInjectionTimeParcialStop__c.minute()) + ':00';
            }else if(singleRecord.WaterInjectionTimeParcialStop__c != null){
                singleRow.WITimeParcialStop__c = String.valueOf(singleRecord.WaterInjectionTimeParcialStop__c.hour()) + ':' + String.valueOf(singleRecord.WaterInjectionTimeParcialStop__c.minute()) + ':00';
            }else if(singleRecord.WaterInjectionTimeParcialStop__c == null && singleRecord.WITimeParcialStop__c != null) {
                timeSplit = singleRecord.WITimeParcialStop__c.split(':');

                if(timeSplit[0].length() == 1){
                    if(timeSplit[1].length() == 1){ 
                        singleRow.WITimeParcialStop__c = '0' + timeSplit[0] + ':0' + timeSplit[1] + ':00';
                    } else{
                        singleRow.WITimeParcialStop__c = '0' + timeSplit[0] + ':' + timeSplit[1] + ':00';
                    }
                } else if(timeSplit[1].length() == 1){
                    singleRow.WITimeParcialStop__c = timeSplit[0] + ':0' + timeSplit[1] + ':00';
                } else{
                    singleRow.WITimeParcialStop__c = timeSplit[0] + ':' + timeSplit[1] + ':00';
                }
            }

            //WaterInjectionTimeCleanSRU__c
            if (singleRecord.WaterInjectionTimeCleanSRU__c == null && singleRecord.WITimeCleanSRU__c == null) {
                singleRow.WITimeCleanSRU__c = '';
            }else if(singleRecord.WaterInjectionTimeCleanSRU__c == time.newInstance(24, 0, 0, 0)){
                singleRow.WITimeCleanSRU__c = '24:00:00';
            }else if(singleRecord.WaterInjectionTimeCleanSRU__c != null && String.valueOf(singleRecord.WaterInjectionTimeCleanSRU__c.hour()).length() == 1){
                if(String.valueOf(singleRecord.WaterInjectionTimeCleanSRU__c.minute()).length() == 1){
                    singleRow.WITimeCleanSRU__c = '0' + String.valueOf(singleRecord.WaterInjectionTimeCleanSRU__c.hour()) + ':0' + String.valueOf(singleRecord.WaterInjectionTimeCleanSRU__c.minute()) + ':00';
                }else{
                    singleRow.WITimeCleanSRU__c = '0' + String.valueOf(singleRecord.WaterInjectionTimeCleanSRU__c.hour()) + ':' + String.valueOf(singleRecord.WaterInjectionTimeCleanSRU__c.minute()) + ':00';
                }
            }else if(singleRecord.WaterInjectionTimeCleanSRU__c != null && String.valueOf(singleRecord.WaterInjectionTimeCleanSRU__c.minute()).length() == 1){
                singleRow.WITimeCleanSRU__c = String.valueOf(singleRecord.WaterInjectionTimeCleanSRU__c.hour()) + ':0' + String.valueOf(singleRecord.WaterInjectionTimeCleanSRU__c.minute()) + ':00';
            }else if(singleRecord.WaterInjectionTimeCleanSRU__c != null){
                singleRow.WITimeCleanSRU__c = String.valueOf(singleRecord.WaterInjectionTimeCleanSRU__c.hour()) + ':' + String.valueOf(singleRecord.WaterInjectionTimeCleanSRU__c.minute()) + ':00';
            }else if(singleRecord.WaterInjectionTimeCleanSRU__c == null && singleRecord.WITimeCleanSRU__c != null) {
                timeSplit = singleRecord.WITimeCleanSRU__c.split(':');

                if(timeSplit[0].length() == 1){
                    if(timeSplit[1].length() == 1){ 
                        singleRow.WITimeCleanSRU__c = '0' + timeSplit[0] + ':0' + timeSplit[1] + ':00';
                    } else{
                        singleRow.WITimeCleanSRU__c = '0' + timeSplit[0] + ':' + timeSplit[1] + ':00';
                    }
                } else if(timeSplit[1].length() == 1){
                    singleRow.WITimeCleanSRU__c = timeSplit[0] + ':0' + timeSplit[1] + ':00';
                } else{
                    singleRow.WITimeCleanSRU__c = timeSplit[0] + ':' + timeSplit[1] + ':00';
                }
            }

            //TotalTimeService__c
            if (singleRecord.TotalTimeService__c == null && singleRecord.TTService__c == null) {
                singleRow.TTService__c = '';
            }else if(singleRecord.TotalTimeService__c == time.newInstance(24, 0, 0, 0)){
                singleRow.TTService__c = '24:00:00';
            }else if(singleRecord.TotalTimeService__c != null && String.valueOf(singleRecord.TotalTimeService__c.hour()).length() == 1){
                if(String.valueOf(singleRecord.TotalTimeService__c.minute()).length() == 1){
                    singleRow.TTService__c = '0' + String.valueOf(singleRecord.TotalTimeService__c.hour()) + ':0' + String.valueOf(singleRecord.TotalTimeService__c.minute()) + ':00';
                }else{
                    singleRow.TTService__c = '0' + String.valueOf(singleRecord.TotalTimeService__c.hour()) + ':' + String.valueOf(singleRecord.TotalTimeService__c.minute()) + ':00';
                }
            }else if(singleRecord.TotalTimeService__c != null && String.valueOf(singleRecord.TotalTimeService__c.minute()).length() == 1){
                singleRow.TTService__c = String.valueOf(singleRecord.TotalTimeService__c.hour()) + ':0' + String.valueOf(singleRecord.TotalTimeService__c.minute()) + ':00';
            }else if(singleRecord.TotalTimeService__c != null){
                singleRow.TTService__c = String.valueOf(singleRecord.TotalTimeService__c.hour()) + ':' + String.valueOf(singleRecord.TotalTimeService__c.minute()) + ':00';
            }else if(singleRecord.TotalTimeService__c == null && singleRecord.TTService__c != null) {
                timeSplit = singleRecord.TTService__c.split(':');

                if(timeSplit[0].length() == 1){
                    if(timeSplit[1].length() == 1){ 
                        singleRow.TTService__c = '0' + timeSplit[0] + ':0' + timeSplit[1] + ':00';
                    } else{
                        singleRow.TTService__c = '0' + timeSplit[0] + ':' + timeSplit[1] + ':00';
                    }
                } else if(timeSplit[1].length() == 1){
                    singleRow.TTService__c = timeSplit[0] + ':0' + timeSplit[1] + ':00';
                } else{
                    singleRow.TTService__c = timeSplit[0] + ':' + timeSplit[1] + ':00';
                }
            }

            //TotalTimeCharter__c
            if (singleRecord.TotalTimeCharter__c == null && singleRecord.TTCharter__c == null) {
                singleRow.TTCharter__c = '';
            }else if(singleRecord.TotalTimeCharter__c == time.newInstance(24, 0, 0, 0)){
                singleRow.TTCharter__c = '24:00:00';
            }else if(singleRecord.TotalTimeCharter__c != null && String.valueOf(singleRecord.TotalTimeCharter__c.hour()).length() == 1){
                if(String.valueOf(singleRecord.TotalTimeCharter__c.minute()).length() == 1){
                    singleRow.TTCharter__c = '0' + String.valueOf(singleRecord.TotalTimeCharter__c.hour()) + ':0' + String.valueOf(singleRecord.TotalTimeCharter__c.minute()) + ':00';
                }else{
                    singleRow.TTCharter__c = '0' + String.valueOf(singleRecord.TotalTimeCharter__c.hour()) + ':' + String.valueOf(singleRecord.TotalTimeCharter__c.minute()) + ':00';
                }
            }else if(singleRecord.TotalTimeCharter__c != null && String.valueOf(singleRecord.TotalTimeCharter__c.minute()).length() == 1){
                singleRow.TTCharter__c = String.valueOf(singleRecord.TotalTimeCharter__c.hour()) + ':0' + String.valueOf(singleRecord.TotalTimeCharter__c.minute()) + ':00';
            }else if(singleRecord.TotalTimeCharter__c != null){
                singleRow.TTCharter__c = String.valueOf(singleRecord.TotalTimeCharter__c.hour()) + ':' + String.valueOf(singleRecord.TotalTimeCharter__c.minute()) + ':00';
            }else if(singleRecord.TotalTimeCharter__c == null && singleRecord.TTCharter__c != null) {
                timeSplit = singleRecord.TTCharter__c.split(':');

                if(timeSplit[0].length() == 1){
                    if(timeSplit[1].length() == 1){ 
                        singleRow.TTCharter__c = '0' + timeSplit[0] + ':0' + timeSplit[1] + ':00';
                    } else{
                        singleRow.TTCharter__c = '0' + timeSplit[0] + ':' + timeSplit[1] + ':00';
                    }
                } else if(timeSplit[1].length() == 1){
                    singleRow.TTCharter__c = timeSplit[0] + ':0' + timeSplit[1] + ':00';
                } else{
                    singleRow.TTCharter__c = timeSplit[0] + ':' + timeSplit[1] + ':00';
                }
            }

            updateLst.add(singleRow);

        }

        if(updateLst.size() > 0){
            System.debug(updateLst);
            update updateLst;
        }
    }    

    public void fillTanksValues(List<RDO__c> lstRDO){
        String[] tank1Split;
        String[] tank2Split;

        for(RDO__C rdo : lstRDO){
            if(rdo.UnavailableVolumeLargestCargoTank1__c != null){
                tank1Split = rdo.UnavailableVolumeLargestCargoTank1__c.split('-');
                rdo.Tank1Value__c = Double.valueOf(tank1Split[1].replace('.', ''));
            }else {
                rdo.Tank1Value__c = 0;
            }

            if(rdo.UnavailableVolumeLargestCargoTank2__c != null){
                tank2Split = rdo.UnavailableVolumeLargestCargoTank2__c.split('-');
                rdo.Tank2Value__c = Double.valueOf(tank2Split[1].replace('.', ''));
            }else {
                rdo.Tank2Value__c = 0;
            }
        }
    }

    public void fillMV15ServicesFields(List<RDO__C> lstRDO){ 
        for(RDO__C rdo : lstRDO){

            //Fill Offloading Reduction
            //Time (converted to minutes) / 1440 * 5%
            if(rdo.OffloadingDelayTime__c != null){
                String[] timeSplit = String.valueOf(rdo.OffloadingDelayTime__c).split(':');
                Double timeInMinutes = 0;
                Double offloadingReduction = 0;

                timeInMinutes = (Double.valueOf(timeSplit[0]) * 60) + Double.valueOf(timeSplit[1]);
                System.debug('timeInMinutes -> ' + timeInMinutes);

                offloadingReduction = (timeInMinutes / 1440) * 0.05;
                System.debug('offloadingReduction -> ' + offloadingReduction);

                rdo.OffloadingReduction__c = offloadingReduction;
            }

            if(rdo.VesselShortName__c != 'MV15'){
                if(rdo.RateDeltaDaily__c != null){
                    rdo.DailyRateServices__c = rdo.RateDeltaDaily__c;
                }

                if(rdo.RateDeltaTotalReductions__c != null){
                    rdo.TotalReductionsServices__c = rdo.RateDeltaTotalReductions__c;
                }
            } else{
                /*if(rdo.RateDeltaDaily__c != null && rdo.DailyRateServices__c == null){
                    rdo.DailyRateServices__c = rdo.RateDeltaDaily__c;
                }

                if(rdo.RateDeltaTotalReductions__c != null && rdo.TotalReductionsServices__c == null){
                    rdo.TotalReductionsServices__c = rdo.RateDeltaTotalReductions__c;
                }*/

                if(rdo.OffloadingReduction__c != null && rdo.DeltaCharter__c != null){
                    rdo.RateDeltaTotalReductions__c = rdo.DeltaCharter__c + rdo.OffloadingReduction__c;
                }

                if(rdo.OffloadingReduction__c != null && rdo.DeltaServices__c != null){
                    rdo.TotalReductionsServices__c = rdo.DeltaServices__c + rdo.OffloadingReduction__c;
                }

                if(rdo.RateDeltaTotalReductions__c != null){
                    rdo.RateDeltaDaily__c = 1 - rdo.RateDeltaTotalReductions__c;
                }

                if(rdo.TotalReductionsServices__c != null){
                    rdo.DailyRateServices__c = 1 - rdo.TotalReductionsServices__c;
                }
            }
        }
    }
}