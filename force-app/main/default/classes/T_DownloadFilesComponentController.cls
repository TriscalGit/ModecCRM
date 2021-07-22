public class T_DownloadFilesComponentController {

    @AuraEnabled
    public static List<ContentDocument> getContentDocumentLinks(String recordId){
        List<ContentDocument> retorno = new List<ContentDocument>();
        ConfiguracoesGerais__c cg = ConfiguracoesGerais__c.getInstance();
        
        Try{
            List<ContentDocumentLink> temp = T_ContentDocumentLinkREP.getContentDocumentLinksByLinkedEntityId(recordId, cg.LimiteDownloadArquivos__c != null ? Integer.valueOf(cg.LimiteDownloadArquivos__c) : 10);
            For(ContentDocumentLink cdl: temp){
                retorno.add((ContentDocument) cdl.getSObject('ContentDocument'));
            }
        } catch(Exception e) {
            retorno = null;
        }
        return retorno;
    }
    
    @AuraEnabled
    public static String getOrgURL(){
        User oUser = T_UserRep.getLoggedUser();
        if(oUser.Profile.UserLicense.Name == 'External Apps') {
            return ConfiguracoesGerais__c.getInstance().URLPortalFornecedor__c;
        } else {
            return URL.getSalesforceBaseUrl().toExternalForm()+'/';
        }
        
    }
}