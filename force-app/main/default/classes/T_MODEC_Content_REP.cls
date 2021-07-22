/**
 * @File Name          : T_MODEC_Content_REP.cls
 * @Description        : Classe REP para objetos dos tipos ContentDocument , ContentVersion e ContentDocumentLink
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 03/12/2019 20:23:15
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    13/11/2019   Rafael Hadama     Initial Version
 **/
public class T_MODEC_Content_REP {
   public ContentVersion getContentVersionbyId(string contentDocID)
   {
      ContentVersion arquivo = [SELECT Id, TW1_Last_SAP_request__c, TW1_Last_SAP_response__c, TW1_Upload_Sucess_SAP__c, ContentDocumentId, IsLatest, VersionNumber, Title, ContentSize, FileExtension FROM ContentVersion where ContentDocumentId =:contentDocID AND IsLatest = true];

      system.debug('arquivo:' + arquivo);
      return arquivo;
   }

   public list<ContentDocumentLink> getLinksAnexos(set<Id> setBMIds)
   {
      list<ContentDocumentLink> listLinks = [SELECT Id, LinkedEntityId, ContentDocumentId, IsDeleted, SystemModstamp, ShareType, Visibility FROM ContentDocumentLink where LinkedEntityId IN: setBMIds];

      return listLinks;
   }
}