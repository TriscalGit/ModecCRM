public with sharing class WorkOrderPdfController {
	
	private final WorkOrder objWorkOrder;
    
    public WorkOrderPdfController(ApexPages.StandardController stdController) {
        this.objWorkOrder = (WorkOrder)stdController.getRecord();
    }

    public List<WorkOrderLineItem> getItems() {
		//List<WorkOrderLineItem> lst = WorkOrderLineItemDAO.getWorkOrderLineItemByNAM(objWorkOrder.NAM__c);
		List<WorkOrderLineItem> lst = WorkOrderLineItemDAO.getByWorkOrderId(objWorkOrder.Id);

		for(WorkOrderLineItem obj : lst) {
			obj.Status = (String.isNotBlank(obj.Status) ? obj.Status.left(1) : null);
			obj.MS__c = (String.isNotBlank(obj.MS__c) ? obj.MS__c.left(1) : null);
		}
        return lst;
	}
	
	public Decimal getAllPortionAmount() {
		Decimal portionAmount = 0;

		//for(WorkOrderLineItem obj : WorkOrderLineItemDAO.getWorkOrderLineItemByNAM(objWorkOrder.NAM__c)) {
		for(WorkOrderLineItem obj : WorkOrderLineItemDAO.getByWorkOrderId(objWorkOrder.Id)) {	
			portionAmount += obj.Price__c != null ? obj.Price__c : 0;
		}
        return portionAmount;
	}

	public Decimal getAllTotalBRL() {
		Decimal totalBRL = 0;

		//for(WorkOrderLineItem obj : WorkOrderLineItemDAO.getWorkOrderLineItemByNAM(objWorkOrder.NAM__c)) {
		for(WorkOrderLineItem obj : WorkOrderLineItemDAO.getByWorkOrderId(objWorkOrder.Id)) {
			totalBRL += obj.BRL__c != null ? obj.BRL__c : 0;
		}
        return totalBRL;
	}

	public Decimal getAllBrazilPortionAmount() {
		Decimal portionAmount = 0;

		//for(WorkOrderLineItem obj : WorkOrderLineItemDAO.getWorkOrderLineItemByNAM(objWorkOrder.NAM__c)) {
		for(WorkOrderLineItem obj : WorkOrderLineItemDAO.getByWorkOrderId(objWorkOrder.Id)) {	
			if(obj.ResponsibleCountry__c == 'Brazil' || obj.ResponsibleCountry__c == 'MdB')
				portionAmount += obj.Price__c != null ? obj.Price__c : 0;
		}
        return portionAmount;
	}

	public String getContractTerms(){
		WorkOrder wOrder = [SELECT Id, ContractTerm__c FROM WorkOrder WHERE Id =: objWorkOrder.Id];

		if(wOrder.ContractTerm__c == null) return '';
		else{
			ContractTerm__c c = [SELECT TermsHTML__c FROM ContractTerm__c WHERE Id =: wOrder.ContractTerm__c];
			return c.TermsHTML__c;
		}
	}
}