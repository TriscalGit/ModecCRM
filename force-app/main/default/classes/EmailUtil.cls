public without sharing class EmailUtil {

	// @future(callout=true)
    // public static void sendEmailsWithPdf(String vfName, String templateDeveloperName, String strWhoByWhat, string fileName) {
	// 	Map<String, List<String>> mapWhoByWhat = (Map<String, List<String>>)JSON.deserialize(strWhoByWhat, Map<String, List<String>>.class);
		
	// 	Map<String, String> mapIdVsPdfname = (Map<String, String>)JSON.deserialize(fileName, Map<String, String>.class);
		
	// 	List<Messaging.SingleEmailMessage> lstEmails = new List<Messaging.SingleEmailMessage>();
	// 	EmailTemplate objTemplate = EmailTemplateDAO.getByDeveloperName(templateDeveloperName);
		
	// 	for(String whatId : mapWhoByWhat.keySet()) {
	// 		for(String whoId : mapWhoByWhat.get(whatId)) {
	// 			Messaging.EmailFileAttachment objAttachment = new Messaging.EmailFileAttachment();
	// 			Messaging.SingleEmailMessage objEmail = Messaging.renderStoredEmailTemplate(objTemplate.Id, whoId, whatId);

	// 			PageReference pdfPage = new PageReference('/apex/'+ vfName + '?Id=' + whatId);
	// 			objAttachment.setFileName(mapIdVsPdfname.get(whatId) + '.pdf');
	// 			objAttachment.setBody(pdfPage.getContentAsPdf());
	// 			objEmail.setFileAttachments(new List<Messaging.EmailFileAttachment>{ objAttachment });
	// 			lstEmails.add(objEmail);
	// 		}
	// 	}
	// 	Messaging.sendEmail(lstEmails);
	// }
	@future(callout=true)
    public static void sendNAMEmailsPdf(String strWhoByWhat, string fileName, String namName) {
		try{
			Map<String, List<String>> mapWhoByWhat = (Map<String, List<String>>)JSON.deserialize(strWhoByWhat, Map<String, List<String>>.class);
			
			Map<String, String> mapIdVsPdfname = (Map<String, String>)JSON.deserialize(fileName, Map<String, String>.class);
			
			List<Messaging.SingleEmailMessage> lstEmails = new List<Messaging.SingleEmailMessage>();
			EmailTemplate objTemplateNAM = EmailTemplateDAO.getByDeveloperName('PEMApproval');
			EmailTemplate objTemplateCloseOut = EmailTemplateDAO.getByDeveloperName('PEMApprovalCloseOut');
			String namrevision;
			if(Test.isRunningTest()) namrevision = '0';
			else namrevision = namName.substring(namname.indexOf('_r'), namname.length());
					
			Map<Id, NAM__c> mapNAMwithWO = new Map<Id, NAM__c>( NamDAO.getById(mapWhoByWhat.keySet()) );
			
			System.debug('>> EmailUtil.sendNAMEmailsPdf -- mapNAMwithWO >>' + mapNAMwithWO);  

			for(String whatId : mapWhoByWhat.keySet()) {
				for(String whoId : mapWhoByWhat.get(whatId)) {
					Messaging.EmailFileAttachment objAttachment = new Messaging.EmailFileAttachment();
					Messaging.SingleEmailMessage objEmail = new Messaging.SingleEmailMessage();

					if(namrevision.indexOf('-') != -1) objEmail = Messaging.renderStoredEmailTemplate(objTemplateCloseOut.Id, whoId, whatId);
					else objEmail = Messaging.renderStoredEmailTemplate(objTemplateNAM.Id, whoId, whatId);
					
					List<Messaging.EmailFileAttachment> lstAttachments = new List<Messaging.EmailFileAttachment>();
					PageReference pdfPageNAM = new PageReference('/apex/NamReportPdf?Id=' + whatId);
					objAttachment.setFileName(mapIdVsPdfname.get(whatId) + '.pdf');
					objAttachment.setBody(pdfPageNAM.getContentAsPdf());
					lstAttachments.add(objAttachment);

					System.debug('>> EmailUtil.sendNAMEmailsPdf -- lstAttachments >>' + lstAttachments);  

					
					for(WorkOrder workOrderItem : mapNAMwithWO.get(whatId).WorkOrders__r){
						Messaging.EmailFileAttachment objAttachmentWO = new Messaging.EmailFileAttachment();
						PageReference pdfPageNWO = new PageReference('/apex/WorkOrderPdf?Id=' + workOrderItem.Id);
						objAttachmentWO.setFileName(workOrderItem.WorkOrder__c + '.pdf');
						objAttachmentWO.setBody(pdfPageNWO.getContentAsPdf());
						lstAttachments.add(objAttachmentWO);
						System.debug('>> EmailUtil.sendNAMEmailsPdf -- lstAttachments.size() >>' + lstAttachments.size());  
					}
					objEmail.setFileAttachments( lstAttachments );
					objEmail.setWhatId(whatId);
					objEmail.setToAddresses(new List<String> {whoId});
					lstEmails.add(objEmail);
				}
			}
			Messaging.sendEmail(lstEmails);
		} catch(Exception error){
			System.debug('###### Message -> ' + error.getMessage());
			System.debug('###### Cause -> ' + error.getCause());
			System.debug('###### Strack Trace String -> ' + error.getStackTraceString());
		}
	}
}