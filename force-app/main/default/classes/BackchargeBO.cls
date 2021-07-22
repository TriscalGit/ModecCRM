public with sharing class BackchargeBO {
    
    private static final BackchargeBO instance = new BackchargeBO();

	public static BackchargeBO getInstance() {
		return instance;
    }

    public void calculateDollar (List<Backcharge__c> lstBackcharge)
    {
        Double actualDollar = Double.valueOf(Label.ActualDollar);

        for(Backcharge__c backcharge : lstBackcharge)
        {
            if(backcharge.ChargedAmountBRL__c == null)
                backcharge.ChargedAmountBRL__c = 0;
            
            if(backcharge.ChargedAmountUSD__c == null)
                backcharge.ChargedAmountUSD__c = 0;

            if(backcharge.TotalAmountBRL__c == null)
                backcharge.TotalAmountBRL__c = 0;
            
            if(backcharge.TotalAmountUSD__c == null)
                backcharge.TotalAmountUSD__c = 0;            

            backcharge.ChargedAmountSumUSD__c = (backcharge.ChargedAmountBRL__c/actualDollar) + backcharge.ChargedAmountUSD__c;
            backcharge.TotalAmountSumUSD__c = (backcharge.TotalAmountBRL__c/actualDollar) + backcharge.TotalAmountUSD__c;
        }
    }
}