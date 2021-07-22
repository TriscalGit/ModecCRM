public class GeneratePdfController {

    @AuraEnabled
	public static void savePdf(String recordId, String sObjectName) {
		System.debug('### sObjectName => ' + sObjectName);
		switch on sObjectName {
			when 'NAM__c' {
				NAM__c nam = NamDAO.getById(recordId);
				Util.generatePdf(recordId, nam.Name + ' - ' + nam.Subject__c, 'NAMReportPdf');
			}
			when 'WorkOrder' {
				WorkOrder wo = WorkOrderDAO.getById(recordId);
				Util.generatePdf(recordId, wo.WorkOrder__c, 'WorkOrderPdf');
			}
		}
			
	}
	@future(callout=true)
	public static void savePdfFuture(String mapSerialized, String sObjectName) {
		Map<String, String> mapIdVsName = (Map<String, String>) JSON.deserialize(mapSerialized, Map<String, String>.class);
		System.debug('### sObjectName => ' + sObjectName);
		switch on sObjectName {
			when 'NAM__c' {
				// NAM__c nam = NamDAO.getById(mapIdName.keySet());
				Util.generatePdf(mapIdVsName, 'NAMReportPdf');
			}
			when 'WorkOrder' {
				// WorkOrder wo = WorkOrderDAO.getByWOItem(setIds);
				Util.generatePdf(mapIdVsName, 'WorkOrderPdf');
			}
		}
			
	}
}