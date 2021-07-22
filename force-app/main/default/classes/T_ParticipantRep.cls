public class T_ParticipantRep {

    public static List<TOBJ_Participants__c> getParticipantWhereEmailNotSentYet(){
        List<TOBJ_Participants__c> retorno = new List<TOBJ_Participants__c>();
        try{
           retorno = [select id, Warning__r.TCF_DueDate__c, TCF_EmailStepOwner__c, Warning__c, TCF_EmailHSEQSupplier__c,
                    TCF_Supplier__r.TW1_Step_Owner__r.ContactId, Warning__r.TCF_HSEQWarning__c, TCF_Supplier__r.TW1_Step_Owner__r.Contact.Email
                    from TOBJ_Participants__c
                    where AvailableToSuppliers__c = true and EmailSent__c = false and Warning__r.RequiredSendEmail__c = 'Yes'
                          and TCF_Supplier__r.TW1_Step_Owner__r.Contact.Email != null
                    order by Warning__r.TCF_DueDate__c, Warning__c desc
                    limit 200];
        } catch(Exception e) {retorno = null;}
        return retorno;
    }
    
    public static List<TOBJ_Participants__c> getParticipantByWarningId(Set<String> warningIds){
        List<TOBJ_Participants__c> retorno = new List<TOBJ_Participants__c>();
        try{
            retorno = [select id, Warning__r.TCF_DueDate__c, TCF_EmailStepOwner__c, Warning__c, TCF_EmailHSEQSupplier__c,
                    TCF_Supplier__r.TW1_Step_Owner__r.ContactId, Warning__r.TCF_HSEQWarning__c, TCF_Supplier__r.TW1_Step_Owner__r.Contact.Email
                    from TOBJ_Participants__c
                    where AvailableToSuppliers__c = true and Warning__c in: warningIds and EmailSent__c = false and Warning__r.RequiredSendEmail__c = 'Yes'
                          and TCF_Supplier__r.TW1_Step_Owner__r.Contact.Email != null
                    order by Warning__r.TCF_DueDate__c, Warning__c desc
                    limit 200];
        } catch(Exception e) {retorno = null;}
        return retorno;
    }
    
    public static List<TOBJ_Participants__c> getParticipantsByWarning(String warningId){
        List<TOBJ_Participants__c> retorno = new List<TOBJ_Participants__c>();
        
        try {
            retorno = [select id, name, TCF_Supplier__r.Name, TCF_Supplier__r.TW1_CNPJ__c, TCF_Supplier__r.TW1_Supplier_Type__c
                       from TOBJ_Participants__c 
                       where Warning__c =: warningId
                       limit 10000];
        } catch(Exception e) {retorno = null;}
        return retorno;
    }
}