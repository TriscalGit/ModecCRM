public class WorkOrderLineItemDAO {
	
	public static List<WorkOrderLineItem> getWorkOrderLineItemByNAM(Id namId) {
		return [
			SELECT 
				Id,
				LineItemNumber,
				Description,
				Status,
				MS__c,
				Price__c,
				BRL__c,
				NAM__c,
				Responsible__c,
				ResponsibleWO__c,
				ResponsibleCountry__c,
				Product__c
			FROM
				WorkOrderLineItem
			WHERE
				NAM__c = :namId
		];
	}

	public static List<WorkOrderLineItem> getByWorkOrderId(Id workOrderId) {
		return [
			SELECT 
				Id,
				LineItemNumber,
				Description,
				Status,
				MS__c,
				Price__c,
				BRL__c,
				NAM__c,
				Responsible__c,
				ResponsibleWO__c,
				ResponsibleCountry__c,
				Product__c
			FROM
				WorkOrderLineItem
			WHERE
				WorkOrderId = : workOrderId
		];
	}
}