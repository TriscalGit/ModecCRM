/**
 * @description       : Batch job - to grant access to files for Community User - Only in Inspection(wave2)
 * @author            : Felipe Cardozo
 * @group             :
 * @last modified on  : 08-05-2020
 * @last modified by  : Felipe Cardozo
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   07-16-2020   Rafael Hadama   Initial Version
 **/
public class T_MODEC_BAT_UpdateFilesVisibility implements Database.Batchable<sObject> {
    //variable to hold the recordtypeId for use in query.
    public string InspectionRequestRecordtypeId;
    public string DocumentationRecordtypeId;
    public string InteractionRecordtypeId;
    public string DocumentationHSEAuditRTId;
    public T_MODEC_BAT_UpdateFilesVisibility()
    {
        this.InspectionRequestRecordtypeId = Schema.SObjectType.TW1_Request__c.getRecordTypeInfosByDeveloperName().get('Inspection').getRecordTypeId();
        this.DocumentationRecordtypeId = Schema.SObjectType.TW1_Documentation__c.getRecordTypeInfosByDeveloperName().get('ReportIncidensInvestigation').getRecordTypeId();
        this.InteractionRecordtypeId = Schema.SObjectType.TW1_Interaction__c.getRecordTypeInfosByDeveloperName().get('TW1_Incidents').getRecordTypeId();
        this.DocumentationHSEAuditRTId = Schema.SObjectType.TW1_Documentation__c.getRecordTypeInfosByDeveloperName().get('HSE_Audit').getRecordTypeId();
    }

    //Querying all documentation related to a request of recordtype Inspection and its open.
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([Select Id, Name, RecordTypeId, TW1_Request__c, TW1_Request__r.RecordtypeId, TW1_Request__r.TW1_Status__c from TW1_Documentation__c where (RecordtypeId =: DocumentationHSEAuditRTId) OR (TW1_Request__r.RecordtypeId = : InspectionRequestRecordtypeId AND TW1_Request__r.TW1_Status__c = 'Open') OR (TW1_Interaction__r.RecordtypeId =:InteractionRecordtypeId AND RecordTypeId=:DocumentationRecordtypeId AND TW1_Interaction__r.TW1_Status__c !='Incident treatment rejected' AND TW1_Interaction__r.TW1_Status__c !='Incident treatment approved')]);
    }

    public void execute(Database.BatchableContext  BC,
                        List<TW1_Documentation__c> scope)
    {
        system.debug('List of documentations queried >' + scope);
        //Creating list variable and assign ids, for use in the query of ContentDocumentLink
        List<String> DocIds = new List<string>();
        for (TW1_Documentation__c doc : scope)
        {
            DocIds.add(doc.Id);
        }

        //Query ContentDocumentLink related to documentations queried before
        List<ContentDocumentLink> listDocLinks = [SELECT Id, LinkedEntityId, ContentDocumentId, IsDeleted, SystemModstamp, ShareType, Visibility FROM ContentDocumentLink where LinkedEntityId IN :DocIds];
        system.debug('listDocLinks >>' + listDocLinks);
        system.debug('listDocLinks.size() >>' + listDocLinks.size());

        List<ContentDocumentLink> listDocLinksUpdate = new list<ContentDocumentLink>();
        //Granting visibility access to all users with documents related to documentation queried.
        for (ContentDocumentLink DocLink:listDocLinks) {
            
            if (DocLink.Visibility != 'AllUsers') {
                DocLink.Visibility = 'AllUsers';
                listDocLinksUpdate.add(DocLink);
            }
        }
        system.debug('listDocLinksUpdate >>' + listDocLinksUpdate);
        system.debug('listDocLinksUpdate.size() >>' + listDocLinksUpdate.size());
        update listDocLinksUpdate;
    }

    public void finish(Database.BatchableContext BC)
    {
        
      /*if (!Test.isRunningTest())
      {
        // Reagendar o processo para execução em 10 minutos
        T_SDK_DebugLog.EscreverLog('Reagendando schedule de update files visibility');
        T_SDK_ScheaduleUtils.scheadule('T_MODEC_SCH_UpdateFilesVisibility', 3);
      }*/
    }
}