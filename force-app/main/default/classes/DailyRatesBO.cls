public with sharing class DailyRatesBO {
    private static final DailyRatesBO instance = new DailyRatesBO();

	public static DailyRatesBO getInstance() {
		return instance;
    }

    public void FillNReport(List<DailyRates__c> lstDailyRatesTrigger){

        List<RDO__c> lstRDO = new List<RDO__c>();
        List<DailyRates__c> lstDailyRates = new List<DailyRates__c>();
        List<BOM__c> lstBOM = new List<BOM__c>();
        set<ID> idRDO = new set<ID>();
        DailyRates__c dailyRatesTrigger = new DailyRates__c();
        String idBOM;
        Double dailyRateSum = 0;
        Boolean result;
       
        dailyRatesTrigger = lstDailyRatesTrigger[0];
        if(dailyRatesTrigger.RDO__c != null){
            lstRDO = RDODAO.getRDOById(dailyRatesTrigger.RDO__c);
        }
        
        if(lstRDO.isEmpty()){
            return;
        }

        for(RDO__c lst : lstRDO){

            if(lst.BOM__c == null){
                return;
            } 
            else{
                  idBOM = lst.BOM__c;
                  idRDO.add(lst.Id);                 
                }
        }

        lstDailyRates = DailyRatesDAO.getDailyRatesByRDO(idRDO);
        system.debug('lstDailyRates: '+ lstDailyRates);


        if(lstDailyRates.isEmpty()){
            return;
        } else {
            for(DailyRates__c dailyRate : lstDailyRates){
                result = dailyRate.Description__c.containsIgnoreCase('IUGA');

                if(result && dailyRate.PercentReduction__c != null){
                    String[] percentualText = dailyRate.PercentReduction__c.split('%');

                    String percentualReplace = percentualText[0].replace(',', '.');
                    System.debug('percentualReplace --> ' + percentualReplace);

                    Double percentualDouble = Double.valueOf(percentualReplace);
                    dailyRateSum += percentualDouble;
                
                } 

                lstBOM = BOMDAO.getBOMById(idBOM);
                BOM__c bomInstance = lstBOM[0];

                if(bomInstance.N__c == null)
                {
                    bomInstance.N__c = 0;
                }

                bomInstance.N__c += dailyRateSum;
                update bomInstance; 
            }
        }
   }

   public void fillLossesCompositionFields(List<DailyRates__c> lstDailyRates)
   {
        DailyRates__c dailyRate = new DailyRates__c();
        List<DailyRates__c> lstRDOsDailyRates = new List<DailyRates__c>();
        List<BOM__c> lstBOM = new List<BOM__c>();
        List<RDO__c> lstRDO = new List<RDO__c>();
        Set<Id> setIdsRDO = new Set<Id>();
        String idBOM;
        Double totalReductionShutdown = 0;
        Double totalReductionPartialShutdown = 0;
        Double totalReductionIuga = 0;
        Double totalReductionOffloading = 0;
        Double totalReductionTotalWI = 0;
        Double totalReductionPartialWI = 0;
        Double totalReductionPartialShutdownFSOCharter = 0;
        Double totalReductionPartialShutdownFSOServices = 0;
        Boolean shutdown;
        Boolean shutdownFormat;
        Boolean partialShutdown;
        Boolean partialShutdownFormat;
        Boolean iuga;
        Boolean offloading;
        Boolean totalWI;
        Boolean partialWI;
        Boolean sru;
        Boolean urs;
        Boolean agua;
        Boolean aguaFormat;
        Boolean tabela;
        Boolean shutdownFSOCharter;
        Boolean shutdownFormatFSOCharter;
        Boolean shutdownFSOServices;
        Boolean shutdownFormatFSOServices;

        dailyRate = lstDailyRates[0];

        if(dailyRate.BOM__c == null)
        {
            return;
        } 
        else{

            idBOM = dailyRate.BOM__c;            
        }
        
        lstRDO = RDODAO.getRDOsByIdBOM(idBOM, 'Inactive');
        
        for(RDO__c rdo : lstRDO)
        {
            setIdsRDO.add(rdo.Id);
        }
        
        lstRDOsDailyRates = DailyRatesDAO.getDailyRatesBySetRDO(setIdsRDO);

        lstBOM = BOMDAO.getBOMById(idBOM);
        BOM__c bomInstance = lstBOM[0];

        bomInstance.TotalReductionShutdownAuto__c = 0;
        bomInstance.TotalReductionPartialShutdownAuto__c = 0;
        bomInstance.TotalReductionIUGAAuto__c = 0;
        bomInstance.TotalReductionOffloadingdDelayAuto__c = 0;
        bomInstance.TotalReductionTotalWIStopAuto__c = 0;
        bomInstance.TotalReductionWIPartialStopAuto__c = 0;
        bomInstance.ByPartialShutdownFSOCharterAuto__c = 0;
        bomInstance.ByPartialShutdownFSOServicesAuto__c = 0;

        if(lstRDOsDailyRates.isEmpty())
        {
            return;
        } else 
        {
            for(DailyRates__c daily : lstRDOsDailyRates){
                shutdown = daily.Description__c.containsIgnoreCase('ISENÇÃO DE PAGAMENTO');
                shutdownFormat = daily.Description__c.containsIgnoreCase('ISENCAO DE PAGAMENTO');
                partialShutdown = daily.Description__c.containsIgnoreCase('REDUÇÃO');
                partialShutdownFormat = daily.Description__c.containsIgnoreCase('REDUCAO');
                iuga = daily.Description__c.containsIgnoreCase('IUGA');
                offloading = daily.Description__c.containsIgnoreCase('OFFLOADING');
                totalWI = daily.Description__c.containsIgnoreCase('PARADA TOTAL');
                partialWI = daily.Description__c.containsIgnoreCase('PARADA PARCIAL');
                sru = daily.Description__c.containsIgnoreCase('SRU');
                urs = daily.Description__c.containsIgnoreCase('URS');
                agua = daily.Description__c.containsIgnoreCase('ÁGUA');
                aguaFormat = daily.Description__c.containsIgnoreCase('AGUA');
                tabela = daily.Description__c.containsIgnoreCase('TABELA 3');
                shutdownFSOCharter = daily.Description__c.containsIgnoreCase('REDUCAO PARCIAL CHARTER');
                shutdownFormatFSOCharter = daily.Description__c.containsIgnoreCase('REDUÇÃO PARCIAL CHARTER');
                shutdownFSOServices = daily.Description__c.containsIgnoreCase('REDUCAO PARCIAL SERVICES');
                shutdownFormatFSOServices = daily.Description__c.containsIgnoreCase('REDUÇÃO PARCIAL SERVICES');

                if((shutdown || shutdownFormat) && daily.PercentReduction__c != null){
                    String[] percentualText = daily.PercentReduction__c.split('%');
                    String percentualReplace = percentualText[0].replace(',', '.');

                    Double percentualDouble = Double.valueOf(percentualReplace);
                    totalReductionShutdown += percentualDouble;
                    //interger(95,68*10)/1000
                    //interger(956,8) = 956
                    //956/1000 = 0,956 

                    bomInstance.TotalReductionShutdownAuto__c = totalReductionShutdown / 100;
                }

                if((partialShutdown || partialShutdownFormat) && iuga == false && offloading == false && sru == false && urs == false && agua == false && aguaFormat == false && tabela == false && daily.PercentReduction__c != null && shutdownFSOCharter == false && shutdownFormatFSOCharter == false && shutdownFSOServices == false && shutdownFormatFSOServices == false){
                    String[] percentualText = daily.PercentReduction__c.split('%');
                    String percentualReplace = percentualText[0].replace(',', '.');

                    Double percentualDouble = Double.valueOf(percentualReplace);
                    totalReductionPartialShutdown += percentualDouble;

                    bomInstance.TotalReductionPartialShutdownAuto__c = totalReductionPartialShutdown / 100;
                }

                if((iuga || tabela) && daily.PercentReduction__c != null){
                    String[] percentualText = daily.PercentReduction__c.split('%');
                    String percentualReplace = percentualText[0].replace(',', '.');

                    Double percentualDouble = Double.valueOf(percentualReplace);
                    totalReductionIuga += percentualDouble;

                    bomInstance.TotalReductionIUGAAuto__c = totalReductionIuga / 100;
                }

                if(offloading && daily.PercentReduction__c != null){
                    String[] percentualText = daily.PercentReduction__c.split('%');
                    String percentualReplace = percentualText[0].replace(',', '.');

                    Double percentualDouble = Double.valueOf(percentualReplace);
                    totalReductionOffloading += percentualDouble;

                    bomInstance.TotalReductionOffloadingdDelayAuto__c = totalReductionOffloading / 100;
                }

                if(totalWI && (aguaFormat || agua) && sru == false && urs == false && daily.PercentReduction__c != null){
                    String[] percentualText = daily.PercentReduction__c.split('%');
                    String percentualReplace = percentualText[0].replace(',', '.');

                    Double percentualDouble = Double.valueOf(percentualReplace);
                    totalReductionTotalWI += percentualDouble;

                    bomInstance.TotalReductionTotalWIStopAuto__c = totalReductionTotalWI / 100;
                }

                if(partialWI && (aguaFormat || agua) && sru == false && urs == false && daily.PercentReduction__c != null){
                    String[] percentualText = daily.PercentReduction__c.split('%');
                    String percentualReplace = percentualText[0].replace(',', '.');

                    Double percentualDouble = Double.valueOf(percentualReplace);
                    totalReductionPartialWI += percentualDouble;

                    bomInstance.TotalReductionWIPartialStopAuto__c = totalReductionPartialWI / 100;
                }

                if((shutdownFSOCharter || shutdownFormatFSOCharter) && daily.PercentReduction__c != null){
                    String[] percentualText = daily.PercentReduction__c.split('%');
                    String percentualReplace = percentualText[0].replace(',', '.');

                    Double percentualDouble = Double.valueOf(percentualReplace);
                    totalReductionPartialShutdownFSOCharter += percentualDouble;

                    bomInstance.ByPartialShutdownFSOCharterAuto__c = totalReductionPartialShutdownFSOCharter / 100;
                }

                if((shutdownFSOServices || shutdownFormatFSOServices) && daily.PercentReduction__c != null){
                    String[] percentualText = daily.PercentReduction__c.split('%');
                    String percentualReplace = percentualText[0].replace(',', '.');

                    Double percentualDouble = Double.valueOf(percentualReplace);
                    totalReductionPartialShutdownFSOServices += percentualDouble;

                    bomInstance.ByPartialShutdownFSOServicesAuto__c = totalReductionPartialShutdownFSOServices / 100;
                }
            }
        }

        update bomInstance; 
   }

   public void formatTimeFields(List<DailyRates__c> lstDaily){
        //daily rate
        //TimeOccurrence__c
        List<DailyRates__c> updateLst = new List<DailyRates__c>();
        String[] timeSplit;

        for (DailyRates__c singleRecord : lstDaily) {
            DailyRates__c singleRow = new DailyRates__c();
            singleRow.Id = singleRecord.Id;

            if (singleRecord.TimeOccurrence__c == null && singleRecord.TimeOcurrenceFrm__c == null) {
                singleRow.TimeOcurrenceFrm__c = '';
            }else if(singleRecord.TimeOccurrence__c == time.newInstance(24, 0, 0, 0)){
                singleRow.TimeOcurrenceFrm__c = '24:00:00';
            }else if(singleRecord.TimeOccurrence__c != null && String.valueOf(singleRecord.TimeOccurrence__c.hour()).length() == 1){
                if(String.valueOf(singleRecord.TimeOccurrence__c.minute()).length() == 1){
                    singleRow.TimeOcurrenceFrm__c = '0' + String.valueOf(singleRecord.TimeOccurrence__c.hour()) + ':0' + String.valueOf(singleRecord.TimeOccurrence__c.minute()) + ':00';
                }else{
                    singleRow.TimeOcurrenceFrm__c = '0' + String.valueOf(singleRecord.TimeOccurrence__c.hour()) + ':' + String.valueOf(singleRecord.TimeOccurrence__c.minute()) + ':00';
                }
            }else if(singleRecord.TimeOccurrence__c != null && String.valueOf(singleRecord.TimeOccurrence__c.minute()).length() == 1){
                singleRow.TimeOcurrenceFrm__c = String.valueOf(singleRecord.TimeOccurrence__c.hour()) + ':0' + String.valueOf(singleRecord.TimeOccurrence__c.minute()) + ':00';
            }else if(singleRecord.TimeOccurrence__c != null){
                singleRow.TimeOcurrenceFrm__c = String.valueOf(singleRecord.TimeOccurrence__c.hour()) + ':' + String.valueOf(singleRecord.TimeOccurrence__c.minute()) + ':00';
            }else if(singleRecord.TimeOccurrence__c == null && singleRecord.TimeOcurrenceFrm__c != null) {
                timeSplit = singleRecord.TimeOcurrenceFrm__c.split(':');

                if(timeSplit[0].length() == 1){
                    if(timeSplit[1].length() == 1){ 
                        singleRow.TimeOcurrenceFrm__c = '0' + timeSplit[0] + ':0' + timeSplit[1] + ':00';
                    } else{
                        singleRow.TimeOcurrenceFrm__c = '0' + timeSplit[0] + ':' + timeSplit[1] + ':00';
                    }
                } else if(timeSplit[1].length() == 1){
                    singleRow.TimeOcurrenceFrm__c = timeSplit[0] + ':0' + timeSplit[1] + ':00';
                } else{
                    singleRow.TimeOcurrenceFrm__c = timeSplit[0] + ':' + timeSplit[1] + ':00';
                }
            }

            if (singleRecord.ExtraTime__c == null && singleRecord.ExtraTimeFrm__c == null) {
                singleRow.ExtraTimeFrm__c = '';
            }else if(singleRecord.ExtraTime__c == time.newInstance(24, 0, 0, 0)){
                singleRow.ExtraTimeFrm__c = '24:00:00';
            }else if(singleRecord.ExtraTime__c != null && String.valueOf(singleRecord.ExtraTime__c.hour()).length() == 1){
                if(String.valueOf(singleRecord.ExtraTime__c.minute()).length() == 1){
                    singleRow.ExtraTimeFrm__c = '0' + String.valueOf(singleRecord.ExtraTime__c.hour()) + ':0' + String.valueOf(singleRecord.ExtraTime__c.minute()) + ':00';
                }else{
                    singleRow.ExtraTimeFrm__c = '0' + String.valueOf(singleRecord.ExtraTime__c.hour()) + ':' + String.valueOf(singleRecord.ExtraTime__c.minute()) + ':00';
                }
            }else if(singleRecord.ExtraTime__c != null && String.valueOf(singleRecord.ExtraTime__c.minute()).length() == 1){
                singleRow.ExtraTimeFrm__c = String.valueOf(singleRecord.ExtraTime__c.hour()) + ':0' + String.valueOf(singleRecord.ExtraTime__c.minute()) + ':00';
            }else if(singleRecord.ExtraTime__c != null){
                singleRow.ExtraTimeFrm__c = String.valueOf(singleRecord.ExtraTime__c.hour()) + ':' + String.valueOf(singleRecord.ExtraTime__c.minute()) + ':00';
            }else if(singleRecord.ExtraTime__c == null && singleRecord.ExtraTimeFrm__c != null) {
                timeSplit = singleRecord.ExtraTimeFrm__c.split(':');

                if(timeSplit[0].length() == 1){
                    if(timeSplit[1].length() == 1){ 
                        singleRow.ExtraTimeFrm__c = '0' + timeSplit[0] + ':0' + timeSplit[1] + ':00';
                    } else{
                        singleRow.ExtraTimeFrm__c = '0' + timeSplit[0] + ':' + timeSplit[1] + ':00';
                    }
                } else if(timeSplit[1].length() == 1){
                    singleRow.ExtraTimeFrm__c = timeSplit[0] + ':0' + timeSplit[1] + ':00';
                } else{
                    singleRow.ExtraTimeFrm__c = timeSplit[0] + ':' + timeSplit[1] + ':00';
                }
            }

            updateLst.add(singleRow);
        }

        if(updateLst.size() > 0){
            System.debug(updateLst);
            update updateLst;
        }
    }

    public void formatPercentFields(List<DailyRates__c> lstDaily){
        String percentReplace;
        Double percentReplaced = 0;

        for(DailyRates__c dailyRate : lstDaily){
            if(dailyRate.PercentReduction__c != null){
                percentReplace = dailyRate.PercentReduction__c.replace(',', '.').replace('%', '');
                percentReplaced = Double.valueOf(percentReplace);
            }

            if(dailyRate.PercentReduction__c != null && dailyRate.PercentReductionNumber__c == null){
                dailyRate.PercentReductionNumber__c = percentReplaced;
            }

            if(dailyRate.PercentReductionNumber__c != null && (dailyRate.PercentReduction__c == null || dailyRate.PercentReduction__c != null && percentReplaced != dailyRate.PercentReductionNumber__c)){
                dailyRate.PercentReduction__c = String.valueOf(dailyRate.PercentReductionNumber__c);
            }
        }
    }
}