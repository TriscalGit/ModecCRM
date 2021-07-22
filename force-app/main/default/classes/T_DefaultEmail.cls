public class T_DefaultEmail {
    
    private static Messaging.SingleEmailMessage mail;
    private static Messaging.EmailFileAttachment anexo;
    private static List<Messaging.EmailFileAttachment> anexos;
    private static List<EmailError> retorno;
    private static Map<String, List<EmailTemplate>> mapaModelos;
    
    //ATENÇÃO: Este metodo faz 1 query e 1 DML a cada vez que é chamado
    public static List<EmailError> sendEmail(List<Email> emails) {
        List<Messaging.SingleEmailMessage> send = new List<Messaging.SingleEmailMessage>();
        retorno = new List<EmailError>();
        
        Set<String> developerNamesTemplateEmail = new Set<String>();
        for(Email e: emails){
            developerNamesTemplateEmail.add(e.emailTemplateDeveloperName);
        }
        
        IF(developerNamesTemplateEmail.size() > 0){
            List<EmailTemplate> modelos = [SELECT id, DeveloperName FROM EmailTemplate WHERE DeveloperName in: developerNamesTemplateEmail];
            mapaModelos = T_Utils.montaMapaListaSObjectComCampoComoChave('DeveloperName', modelos);
        }
        
        for(Email param: emails){
            mail = new Messaging.SingleEmailMessage();
            anexos = new List<Messaging.EmailFileAttachment>();
            
            IF(param.destinatarios != null){
                mail.setToAddresses(param.destinatarios);
            }
            IF(param.destinatariosEmCopia != null){
                mail.setCcAddresses(param.destinatariosEmCopia);
            }
            IF(param.destinatariosEmCopiaOculta != null){
                mail.setBccAddresses(param.destinatariosEmCopiaOculta);
            }
            
            IF(param.emailTemplateDeveloperName != null){
                IF(mapaModelos.containsKey(param.emailTemplateDeveloperName)){
                    mail.setTemplateId(mapaModelos.get(param.emailTemplateDeveloperName).get(0).id);
                    mail.setWhatId(param.recordId);
                    mail.setTargetObjectId(param.ContactLeadOrUserId);
                }
            } else {
                mail.setSubject(param.assunto);
                mail.setHtmlBody(param.htmlBody);
                mail.setSaveAsActivity(false);
            }
            
            if(param.files != null){
                for(EmailFile files: param.files){
                    Messaging.EmailFileAttachment anexo = new Messaging.EmailFileAttachment();
                    anexo.setBody(files.file);
                    anexo.setFileName(files.fileName);
                    anexos.add(anexo);
                }
                IF(anexos.size() > 0){
                    mail.setFileAttachments(anexos);
                }
            }
            
            IF(param.OrgWideEmailAddressId != null){
                mail.setOrgWideEmailAddressId(param.OrgWideEmailAddressId);
            }
            IF(param.ReplyTo != null){
                mail.setReplyTo(param.ReplyTo);
            }
            send.add(mail);
        }
        
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(send, false);
        
        for(integer x = 0; x<emails.size(); x++){
            EmailError r = new EmailError();
            r.error = !results.get(x).isSuccess();
            r.errorMessages = new List<String>();
            r.emailEnviado = emails.get(x);
            
            IF(!results.get(x).isSuccess()){
                for(Messaging.SendEmailError error: results.get(x).getErrors()){
                    r.errorMessages.add(error.getMessage());
                }
            }
            retorno.add(r);
        }
        return retorno;
    }
    
    public class Email {
        //Obrigatórios
        public List<String> destinatarios;
        
        //Obrigatório caso use EmailTemplate
        public String emailTemplateDeveloperName; 
        public String recordId;
        public String ContactLeadOrUserId;
        
        //Obrigatório caso não use EmailTemplate
        public String assunto;
        public String htmlBody;
        
        //Opcionais
        public List<EmailFile> files;
        public String OrgWideEmailAddressId;
        public String ReplyTo;
        public List<String> destinatariosEmCopia;
        public List<String> destinatariosEmCopiaOculta;
    }
    
    public class EmailFile {
        //Obrigatórios
        public Blob file;
        public String fileName;
    }
    
    public class EmailError {
        public Boolean error;
        public List<String> errorMessages;
        public Email emailEnviado;
        
        public EmailError(){
            errorMessages = new List<String>();
            error = false;
        }
    }
}