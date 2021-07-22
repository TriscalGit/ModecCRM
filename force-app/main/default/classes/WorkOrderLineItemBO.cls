public class WorkOrderLineItemBO {
    private static final WorkOrderLineItemBO instance = new WorkOrderLineItemBO();

	public static WorkOrderLineItemBO getInstance() {
		return instance;
	}
    public void updateFields(List<WorkOrderLineItem> lstWoItem, Map<Id, WorkOrderLineItem> mapWOLineItem){
        ExchangeRATE__c exchangeValue = [SELECT value__c FROM ExchangeRATE__c WHERE Active__c =: true LIMIT 1];       
        Set<Id> setWO = new Set<Id>(); 
        for(WorkOrderLineItem woLine : lstWoItem){
            setWO.add(woLine.WorkOrderId);
        }
        Map<String, WorkOrder> mapWO = new Map<String, WorkOrder> (WorkOrderDAO.getByWOItem(setWO));
        Map<String, Decimal> mapNamRate = new Map<String, Decimal>();

        for(WorkOrderLineItem woLine : lstWoItem){
            woLine.NAM__c = mapWO.get(woLine.WorkORderId).NAM__c;
            //if((woLine.ResponsibleWO__c == 'MdB' && !woLine.BRLUpdate__c) && (mapWOLineItem == null || woLine.Price__c != mapWOLineItem.get(woLine.Id).Price__c) ) {
            if(woLine.ResponsibleCountry__c == 'Brazil' || woLine.ResponsibleCountry__c == 'MdB' ){
                woLine.BRL__c = (woLine.Price__c == null? 0: exchangeValue.Value__c * woLine.Price__c);
                woLine.BRLRate__c = exchangeValue.Value__c;
                mapNamRate.put(mapWO.get(woLine.WorkORderId).NAM__c, exchangeValue.Value__c );
            }//else if(woLine.ResponsibleWO__c != 'MdB'){
            else{
                woLine.BRL__c = null;
                woLine.BRLRate__c = null;
            }
        }
    }
}