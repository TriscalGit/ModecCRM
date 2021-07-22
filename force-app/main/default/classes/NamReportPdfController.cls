public without sharing class NamReportPdfController {

    private final NAM__c objNAM;
	// private final String wkNames;
    public string WorkOrderNames{
		get; set;
	}
    public NamReportPdfController(ApexPages.StandardController stdController) {
		this.objNAM = NamDAO.getById(stdController.getId());
		WorkOrderNames = '';
		for(WorkOrder wk : this.objNAM.WorkOrders__r){
			this.WorkOrderNames += wk.WorkOrder__c + ', '; 
		}
		integer index = this.WorkOrderNames.lastIndexOf(',');
		if(index != -1) this.WorkOrderNames = this.WorkOrderNames.substring(0,index -1);
    }

    public String getCustomDescription() {
		return (String.isNotBlank(objNAM.Description__c) ? objNAM.Description__c.replaceAll('img', 'img style="width:730px;"') : null);
	}
	
	public String getCustomActionTaken() {
		return (String.isNotBlank(objNAM.ActionTaken__c) ? objNAM.ActionTaken__c.replaceAll('img', 'img style="width:730px;"') : null);
	}
	
	public String getCustomRootCause() {
		return (String.isNotBlank(objNAM.RootCause__c) ? objNAM.RootCause__c.replaceAll('img', 'img style="width:730px;"') : null);
    }
}