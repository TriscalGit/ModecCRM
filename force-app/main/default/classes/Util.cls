public with sharing class Util {
    public static String objDeveloperName(String recordIdOrPrefix){
        String objectName = '';
        try{
            //Get prefix from record ID
            //This assumes that you have passed at least 3 characters
            String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
             
            //Get schema information
            Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
             
            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType stype : gd.values()){

                //if (!sObj.contains('__')) to exclude managed package objects

                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();
                //System.debug('Prefix is ' + prefix);
                 
                //Check if the prefix matches with requested prefix
                if(prefix!=null && prefix.equals(myIdPrefix)){
                    objectName = r.getName();
                    System.debug('Object Name! ' + objectName);
                    break;
                }
            }
        }catch(Exception e){
            System.debug(e);
        }
        return objectName;
	}
	
    public static void generatePdf(String recordId, String fileName, String vfName) {
		PageReference pdfPage = new PageReference('/apex/'+ vfName + '?Id=' + recordId);
        Blob pdfContent;
        if(!Test.isRunningTest()) pdfContent =  pdfPage.getContentAsPdf();
		else  pdfContent = blob.valueOf('Unit.Test');
  

		ContentVersion cv = new ContentVersion();
		cv.title = fileName;
		cv.PathOnClient = fileName + '.pdf';
        cv.VersionData = pdfContent;
        insert cv;

        delete [SELECT 
                    ContentDocument.Title,
                    LinkedEntityId 
                FROM ContentDocumentLink 
                WHERE LinkedEntityId =: recordId
                  AND ContentDocument.Title =: fileName];

        cv = [SELECT Id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];

        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = recordId;
        contentlink.ShareType = 'V';
        contentlink.ContentDocumentId = cv.ContentDocumentId;
        contentlink.Visibility = 'AllUsers';
        insert contentlink;
	}

    public static void generatePdf(Map<String, String> mapIdVsNam, String vfName) {
        
        List<ContentVersion> lstContentVersion = new List<ContentVersion>();
        List<ContentDocumentLink> lstContentDocumentLink = new  List<ContentDocumentLink>();
        Map<String, String> mapNameVsId = new Map<String, String>();
        
        if(mapIdVsNam.size() > 0 ){

            // delete [SELECT id FROM ContentVersion WHERE Title IN: mapIdVsNam.values()];
            
            for(String recordId : mapIdVsNam.keySet()){
                PageReference pdfPage = new PageReference('/apex/'+ vfName + '?Id=' + recordId);
                Blob pdfContent;
                if(!Test.isRunningTest()) pdfContent =  pdfPage.getContentAsPdf();
		        else  pdfContent = blob.valueOf('Unit.Test');

                lstContentVersion.add( new ContentVersion(
                    Title = mapIdVsNam.get(recordId),
                    PathOnClient = mapIdVsNam.get(recordId) + '.pdf',
                    VersionData = pdfContent)
                );
                mapNameVsId.put(mapIdVsNam.get(recordId), recordId);
            }

            System.debug('>>> Util.generatePdf() -> mapIdVsNam.KeySet() ' + mapIdVsNam.KeySet());
            System.debug('>>> Util.generatePdf() -> mapIdVsNam.values() ' + mapIdVsNam.values());
            System.debug('>>> Util.generatePdf() -> lstContentVersion.size() ' + lstContentVersion.size());
            System.debug('>>> Util.generatePdf() -> lstContentVersion ' + lstContentVersion);            
            

            DELETE [SELECT ID FROM ContentDocumentLink WHERE LinkedEntityId IN: mapIdVsNam.KeySet() AND ContentDocument.Title IN: mapIdVsNam.values()];
            
            INSERT lstContentVersion;
            Set<Id> setContent = new Set<Id>(); 
            for(ContentVersion contentV : lstContentVersion){
                setContent.add(contentV.Id);
            }
            
            List<ContentVersion> lstContent= [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id IN: setContent];
            System.debug(lstContent);
            
            for(ContentVersion cv : lstContent){
                lstContentDocumentLink.add(new ContentDocumentLink(
                    LinkedEntityId = mapNameVsId.get(cv.Title),
                    ShareType = 'V',
                    ContentDocumentId = cv.ContentDocumentId,
                    Visibility = 'AllUsers')
                );
            }
            System.debug('>>> Util.generatePdf() -> lstContentDocumentLink ' + lstContentDocumentLink);
            insert lstContentDocumentLink;
        }
	}
}