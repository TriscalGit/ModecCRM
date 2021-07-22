/**
 * @description       : Job - to grant access to files for Community User
 * @author            : Gabriel Uchoa
 * @group             :
 * @last modified on  : 04-20-2021
 * @last modified by  : Gabriel Uchoa
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   04-20-2021   Gabriel Uchoa   Initial Version
 **/
public class T_UpdateFilesVisibility {
    
    public static void manageShareFilesVisibility(){
        ShareFileVisibility('select id from TOBJ_Warning__c where PublicationDate__c <=: hoje and TCF_DueDate__c >=: hoje');
    }
    
    @future
    private static void ShareFileVisibility(String soql){
        Date hoje = Date.today();
        List<SObject> registros = Database.query(soql + ' limit 40000');
        Set<String> ids = T_Utils.getSetIds(registros, 'Id');
		IF(ids != null && ids.size() > 0) {
			List<ContentDocumentLink> filesRelationships = [select id from ContentDocumentLink where visibility != 'AllUsers' and LinkedEntityId in: ids limit 10000];
			
			for(ContentDocumentLink fileRelationship: filesRelationships){
				 fileRelationship.Visibility = 'AllUsers';
			}
			
			update filesRelationships;
		}
    }
}