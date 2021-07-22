public class T_WarningBatch implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id, Warning__r.TCF_DueDate__c, TCF_EmailStepOwner__c, Warning__c, TCF_EmailHSEQSupplier__c,'+
                    'TCF_Supplier__r.TW1_Step_Owner__r.ContactId, Warning__r.TCF_HSEQWarning__c, TCF_Supplier__r.TW1_Step_Owner__r.Contact.Email '+
                    'from TOBJ_Participants__c '+
                    'where AvailableToSuppliers__c = true and EmailSent__c = false and Warning__r.RequiredSendEmail__c = \'Yes\' '+
                          'and TCF_Supplier__r.TW1_Step_Owner__r.Contact.Email != null '+
                    'order by Warning__r.TCF_DueDate__c, Warning__c desc');
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope){
        T_WarningHelper helper = new T_WarningHelper();
        helper.setParticipantes(scope);
        helper.getContentDocumentLinksForWarnings();
        helper.montarEmailsWarning();
        helper.sendEmails();
        helper.updateParticipantes();
    }
    
    public void finish(Database.BatchableContext BC){
    }
}