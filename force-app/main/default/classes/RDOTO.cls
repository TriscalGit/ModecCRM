public with sharing class RDOTO {

    public static RDOTO parse(String json){
		return (RDOTO) System.JSON.deserialize(json, RDOTO.class);
	}

	public String idRDO;
    public String Vessel;
	public Integer NumRDO;
	public String DateRDO;
	public String CharterContract;
	public String ServiceContract;
	public Integer CharterTotalTime;
	public Integer ServiceTotalTime;
	public Integer Wells;
	public Decimal K;
	public Double ExpedtecVolumeVe;
    public Double ExpectedVolumeVe24H;
	public Double DeltaPercent;
	public Double DailyRate;
    public Double TotalReduction;
	public Double DailyQuota;
	public Double InjectedVolume;
	public Double UninjectedVolume;
	public Double AboveQuotaVolume;
	public Integer TimeTotalStop;
	public Integer TimeParcialStop;
	public Integer TimeCleaningSRU;
	public Decimal InitialInventoryClient;
	public Decimal ConsumedClient;
	public Integer ReceivedClient;
	public Decimal TransferClientContract;
	public Decimal TransferContractClient;
	public Decimal FinalInventoryClient;
	public Decimal InitialInventoryContracted;
	public Decimal ConsumedContracted;
	public Integer ReceivedContracted;
	public Decimal FinalInventoryContracted;
	public Decimal InitialInventoryTotal;
	public Decimal ConsumedTotal;
	public Integer ReceivedTotal;
	public Decimal TransferClientContractTotal;
	public Decimal TransferContractClientTotal;
	public Decimal FinalInventoryTotal;
	public Double GasProduced;
	public Double GasExported;
	public Double GasLPFlare;
	public Double GasHPFlare;
	public Double GasFuel;
	public Double VolumeImpToClientGas;
	public Double VolumeImpToContractedGas;
	public Double VolumeImpToClientCO2;
	public Double VolumeImpToContractedCO2;
	public Double TotalPOB;
	public Double FixedPOB;
	public Double NationalPOB;
	public Double NationalPercentPOB;
	public Double ClientCont;
	public Double Client;
    public Double ActualVolume;
	public Double GasInjected;
	public Decimal TotalFlare;
	public cls_OcurrencesContracted[] OcurrencesContracted;
	public cls_OcurrencesClient[] OcurrencesClient;
	public cls_DailyRatesRates[] DailyRatesRates;
    public cls_DailyRatesReduction[] DailyRatesReduction;
    
	public class cls_OcurrencesContracted {
		public String Item;
		public String Reference;
		public String Contract;
		public String OcurrenceType;
		public String Notes;
	}

	public class cls_OcurrencesClient {
		public String Item;
		public String Reference;
		public String Contract;
		public String OcurrenceType;
		public String Notes;
	}

	public class cls_DailyRatesRates {
		public Integer StartTime;
		public Integer EndTime;
		public String OcurrenceTime;
		public String ExtraTime;
		public String PercentReduction;
		public String Description;
		public String AnnexTo;
		public String Contract;
		public String DailyType;
	}

	public class cls_DailyRatesReduction {
		public String StartTime;
		public String EndTime;
		public String OcurrenceTime;
		public String ExtraTime;
		public String PercentReduction;
		public String Description;
		public String AnnexTo;
		public String Contract;
		public String DailyType;
	}
}