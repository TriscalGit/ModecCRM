public class T_SegmentacaoForcedoresController {

    @AuraEnabled
    Public static List<SObject> searchForSuppliers(SearchDTO pesquisa){
        
        List<SObject> retorno; 
        List<Account> contas;
        List<TOBJ_Participants__c> participantes;
        
        participantes = T_ParticipantRep.getParticipantsByWarning(pesquisa.recordId);
        Map<String, SObject> mapaParticipante = T_Utils.montaMapaSObjectComCampoComoChave('TCF_Supplier__c', participantes);
        
        IF(pesquisa.SearchType == 'Category') {
            contas = T_MODEC_Account_REP.getSuppliersByCategoryAndSubCategory(pesquisa.Category, pesquisa.SubCategory, pesquisa.VendorVetting);
            
        } else if(pesquisa.SearchType == 'Participantes') {
            retorno = participantes;
            
        } else {            
            contas = T_MODEC_Account_REP.getSuppliersByNameAndCategoryType(pesquisa.SupplierName,pesquisa.CategoryRT, pesquisa.VendorVetting);        	
        }
        
        if(contas != null){
            retorno = new List<Account>();
            for(Account conta: contas){
                IF(!mapaParticipante.containsKey(conta.id)){
                    retorno.add(conta);
                }
            }
        }        
        
        return retorno;
    }
    
    @AuraEnabled
    public static String addParticipantesApex(List<Account> participantes, String recordId){
        
        List<TOBJ_Participants__c> registros = new List<TOBJ_Participants__c>();
        String retorno = '';        
        
        try{
            For(Account conta: participantes){
                TOBJ_Participants__c participante = new TOBJ_Participants__c();
                participante.TCF_Supplier__c = conta.id;
                participante.Warning__c = recordId;
                participante.ValidacaoDuplicata__c = recordId+'_'+conta.id;
                registros.add(participante);
            }
            insert registros;
        } catch(Exception e){
            retorno = 'Error: '+e.getMessage();
        }
        return retorno;
    }
    
    @AuraEnabled
    public static void removeParticipantesApex(List<Object> jsonStr){
        List<TOBJ_Participants__c> participantes = new List<TOBJ_Participants__c>();

        for(Object obj: jsonStr){
            Map<String, Object> mapa = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(obj));
            
            TOBJ_Participants__c p = new TOBJ_Participants__c();
            p.id = (String) mapa.get('Id');
            participantes.add(p);
        }
        delete participantes;
    }
    
    @AuraEnabled
    Public static List<RecordType> getCategoryRecordTypes(){
        return T_MODEC_RecordType_Rep.getCategoryRecordTypes();
    }
    
    @AuraEnabled
    Public static String getPicklistVendorVetting(String apiFieldName){
        return JSON.serialize(T_MODEC_Account_REP.getPicklistVendorVetting(apiFieldName));
    }
    
    public class SearchDTO {
        @AuraEnabled public String SupplierName {get; set;}
        @AuraEnabled public String SearchType {get; set;}
        @AuraEnabled public String Category {get; set;}
        @AuraEnabled public String SubCategory {get; set;}
        @AuraEnabled public String CategoryRT {get; set;}
        @AuraEnabled public String VendorVetting {get; set;}
        @AuraEnabled public String recordId {get; set;}
    }
}