public without sharing class T_WarningViewScreenController {

    private static Integer limiteQuery = 100;
    
    @AuraEnabled
    public static WarningSettings__c getWarningsSettings(){
        WarningSettings__c warningSetting;
        
        IF(!Test.isRunningTest()){
            warningSetting = WarningSettings__c.getInstance();
        } else {
            warningSetting = new WarningSettings__c();
            warningSetting.CardsByScreenLarge__c = 9;
            warningSetting.CardsByScreenMedium__c = 6;
            warningSetting.CardsByScreenSmall__c = 3;
            warningSetting.WarningsByRowLarge__c = 3;
            warningSetting.WarningsByRowMedium__c = 2;
            warningSetting.WarningsByRowSmall__c = 1;
            warningSetting.WarningsLoadMoreLarge__c = 9;
            warningSetting.WarningsLoadMoreMedium__c = 6;
            warningSetting.WarningsLoadMoreSmall__c = 3;
        }
        return warningSetting;
    }
    
    @AuraEnabled
    public static List<SObject> getWarning(String DateToOrdenate, String Order){
        Date hoje = Date.today();
        List<TOBJ_Warning__c> retorno = new List<TOBJ_Warning__c>();
        User usuario = null;
        try{
            usuario = [select id, Contact.AccountId 
                       From User 
                       where id =: UserInfo.getUserId() and Contact.AccountId != null 
                       limit 1];
        } catch(Exception e){
            usuario = null;
        }
        String soql = 'select ';
        
        if(usuario != null){
            soql += 'Warning__c, Warning__r.TCF_Subject__c, Warning__r.TCF_Notice__c, Warning__r.PublicationDateView__c ';
            soql += 'from TOBJ_Participants__c ';
            soql += 'where TCF_Supplier__c = \''+usuario.Contact.AccountId+'\' and Warning__r.PublicationDate__c <=: hoje ';
            soql += 'and Warning__r.TCF_DueDate__c >=: hoje ';
            
            soql += 'order by Warning__r.'+DateToOrdenate+' '+Order+' ';
            soql += 'limit :limiteQuery ';
            
            List<TOBJ_Participants__c> participantes = Database.query(soql);
            
            for(TOBJ_Participants__c participante: participantes){
                TOBJ_Warning__c warning = (TOBJ_Warning__c) participante.getSObject('Warning__r');
                retorno.add(warning);
            }
        } else {
            soql += 'id, TCF_Subject__c, TCF_Notice__c, PublicationDateView__c, PublicationDate__c ';
            soql += 'from TOBJ_Warning__c ';
            soql += 'where PublicationDate__c <=: hoje and TCF_DueDate__c >=: hoje ';
            soql += 'order by '+DateToOrdenate+' '+Order+' ';
            soql += 'limit :limiteQuery ';
            retorno = Database.query(soql);
        }
        
        return retorno;
    }
}