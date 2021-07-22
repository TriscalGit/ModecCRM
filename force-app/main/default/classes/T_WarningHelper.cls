public class T_WarningHelper {

    private List<TOBJ_Participants__c> participantes;
    private List<T_DefaultEmail.Email> emails;
    private Set<String> setWarningIds;
    private Map<String, List<SObject>> mapaContentDocumentLink;
    private Map<String, SObject> mapaContentVersion;
    private Map<String, List<T_DefaultEmail.EmailFile>> mapaFiles;
    
    public T_WarningHelper(){
        this.emails = new List<T_DefaultEmail.Email>();
        this.mapaFiles = new Map<String, List<T_DefaultEmail.EmailFile>>();
    }
    
    public void setParticipantes(List<TOBJ_Participants__c> participantes){
        this.participantes = participantes;
        setWarningIds();
    }
    
    private void setWarningIds(){
        this.setWarningIds = T_Utils.getSetIds(participantes, 'Warning__c');
    }
    
    public void getContentDocumentLinksForWarnings(){
        List<ContentDocumentLink> cdls = [select id, contentDocumentId, LinkedEntityId from ContentDocumentLink where LinkedEntityId in: this.setWarningIds];
        Set<String> setContentDocuments = T_Utils.getSetIds(cdls, 'contentDocumentId');
        List<ContentVersion> cvs = [select id, contentDocumentId, VersionData, ContentSize, Title, FileExtension from ContentVersion where contentDocumentId in: setContentDocuments];
        this.mapaContentDocumentLink = T_Utils.montaMapaListaSObjectComCampoComoChave('LinkedEntityId', cdls);
        this.mapaContentVersion = T_Utils.montaMapaSObjectComCampoComoChave('contentDocumentId', cvs);
        buildMapFromFilesByWarning();
    }
    
    private void buildMapFromFilesByWarning(){
        for(String warningId: this.setWarningIds){
            IF(this.mapaContentDocumentLink.containsKey(warningId)){
                Integer tam = 0;
                List<T_DefaultEmail.EmailFile> temp = new List<T_DefaultEmail.EmailFile>();
                for(SObject cdl: this.mapaContentDocumentLink.get(warningId)){
                    IF(this.mapaContentVersion.containsKey(String.valueOf(cdl.get('contentDocumentId')))){
                        ContentVersion cv = (ContentVersion) this.mapaContentVersion.get(String.valueOf(cdl.get('contentDocumentId')));
                        IF((tam+cv.ContentSize) < 25000000){
                            T_DefaultEmail.EmailFile arquivo = new T_DefaultEmail.EmailFile();
                            arquivo.file = cv.versionData;
                            arquivo.fileName = cv.Title + '.' + cv.FileExtension;
                            System.debug('FILENAME GUFS: '+ arquivo.fileName);
                            tam += cv.ContentSize;
                            temp.add(arquivo);
                        }
                    }
                }
                this.mapaFiles.put(warningId, temp);
            }
        }
    }
    
    public void montarEmailsWarning(){
        OrgWideEmailAddress owea = [select id, Address from OrgWideEmailAddress where Address =: 'noreply@modec.com' limit 1];
        
        for(TOBJ_Participants__c participante: participantes){
            T_DefaultEmail.Email email = new T_DefaultEmail.Email();
            email.emailTemplateDeveloperName = 'WarningEmailToSupplier';
            email.recordId = participante.Warning__c;
            email.ContactLeadOrUserId = participante.TCF_Supplier__r.TW1_Step_Owner__r.ContactId;
            email.OrgWideEmailAddressId = owea.id;
            email.ReplyTo = owea.Address;
            email.destinatarios = new List<String>();
            email.destinatarios.add(participante.TCF_Supplier__r.TW1_Step_Owner__r.Contact.Email);
            
            IF(participante.Warning__r.TCF_HSEQWarning__c == 'Yes'){
                email.destinatariosEmCopiaOculta = new List<String>();
                email.destinatariosEmCopiaOculta.add(participante.TCF_EmailHSEQSupplier__c);
            }
            
            IF(this.mapaFiles.containsKey(participante.Warning__c)) {
                email.files = this.mapaFiles.get(participante.Warning__c);
            }
            
            this.emails.add(email);
            participante.EmailSent__c = true;
        }
    }
    
    public void sendEmails(){
        T_DefaultEmail.sendEmail(this.emails);
    }
    
    public void updateParticipantes(){
        update this.participantes;
    }
}