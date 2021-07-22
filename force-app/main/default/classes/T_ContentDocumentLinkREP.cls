public class T_ContentDocumentLinkREP {

    public static List<ContentDocumentLink> getContentDocumentLinksByLinkedEntityId(String recordId, Integer limite) {
        return [select id, ContentDocument.Id, ContentDocument.Title, ContentDocument.FileExtension, ContentDocument.ContentSize from ContentDocumentLink where LinkedEntityId =: recordId limit :limite];
    }
}