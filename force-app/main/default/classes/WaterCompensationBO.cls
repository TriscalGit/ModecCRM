public with sharing class WaterCompensationBO {
    
    private static final WaterCompensationBO instance = new WaterCompensationBO();

	public static WaterCompensationBO getInstance() {
		return instance;
    }

    public void updateRDOs(List<WaterCompensation__c> lstWaterComp)
    {
        List<RDO__c> lstRDOSending = new List<RDO__c>();
        List<RDO__c> lstRDOReceiving = new List<RDO__c>();
        List<RDO__c> rdosToUpdate = new List<RDO__c>();
        RDO__c rdoSending = new RDO__c();
        RDO__c rdoReceiving = new RDO__c();
        WaterCompensation__c wComp = new WaterCompensation__c();
        String sendingId;
        String receivingId;

        for(WaterCompensation__c waterComp : lstWaterComp)
        {
            sendingId = waterComp.SendingRDO__c;
            receivingId = waterComp.ReceivingRDO__c;
        }

        wComp = lstWaterComp[0];

        lstRDOSending = RDODAO.getRDOById(sendingId);
        lstRDOReceiving = RDODAO.getRDOById(receivingId);

        if(!lstRDOSending.isEmpty())
        {
            rdoSending = lstRDOSending[0];

            if(rdoSending.WIAmountSent__c == null)
                rdoSending.WIAmountSent__c = 0;

            rdoSending.WIAmountSent__c += wComp.Amount__c;
            rdosToUpdate.add(rdoSending);
        } 

        if(!lstRDOReceiving.isEmpty())
        {
            rdoReceiving = lstRDOReceiving[0];

            if(rdoReceiving.WIAmountReceived__c == null)
                rdoReceiving.WIAmountReceived__c = 0;

            rdoReceiving.WIAmountReceived__c += wComp.Amount__c;
            rdosToUpdate.add(rdoReceiving);
        }

        update rdosToUpdate;
    }

}