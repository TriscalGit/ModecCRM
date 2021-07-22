public with sharing class EmailServiceUtil {
	public static void  emailSetup(Messaging.inboundEmail email, String idObjeto, Id ownerId, String ownerEmail){
		System.debug('# EXECUCAO - Email');
		System.debug('# EXECUCAO - Email headers: ' + email.headers);
		System.debug('# EXECUCAO - Email toAddresses: ' + email.toAddresses);
		System.debug('# EXECUCAO - Email ccAddresses: ' + email.ccAddresses);
		System.debug('# EXECUCAO - Email fromAddress: ' + email.fromAddress);
		System.debug('# EXECUCAO - Email fromName: ' + email.fromName);
		System.debug('# EXECUCAO - Email htmlBody: ' + email.htmlBody);
		System.debug('# EXECUCAO - Email subject: ' + email.subject);
		System.debug('# EXECUCAO - Email plainTextBody: ' + email.plainTextBody);
		//System.debug('>>> Util.extrairNumero' + Util.extrairNumero(email.subject, 8));

		EmailMessage emailMessage = new EmailMessage();

		emailMessage.Headers = '';
		for(Messaging.InboundEmail.Header header : email.headers) {
			if(header != null) {
				emailMessage.Headers += header.name + ' - ' + header.value + '\n';
			}
		}

		emailMessage.ToAddress = email.toAddresses != null ? String.join(email.toAddresses, ';') : null;
		emailMessage.CcAddress = email.ccAddresses != null ? String.join(email.ccAddresses, ';') : null;
		emailMessage.FromAddress = email.fromAddress != null ? email.fromAddress : null;
		emailMessage.FromName = email.fromName != null ? email.fromName : null;
		emailMessage.MessageDate = System.now();
		emailMessage.RelatedToId = idObjeto;
		emailMessage.Subject = email.subject != null ? email.subject : null;
		emailMessage.TextBody = email.plainTextBody != null ? email.plainTextBody : null;
		emailMessage.Incoming = true;
		emailMessage.Incoming = false;
		emailMessage.Status = '2';
		if(email.htmlBody != null) {
			if(email.htmlBody.length() > 32000) {
				emailMessage.HtmlBody = email.htmlBody.substring(0, 31999);
			}
			else {
				emailMessage.HtmlBody = email.htmlBody;
			}
		}
		// Insere o email
		System.debug('EmailServiceUtil.emailSetup => emailMessage: ' + emailMessage);
		insert emailMessage;

		// EMAIL RELATED
		EmailMessageRelation relationTo = new EmailMessageRelation();
		relationTo.EmailMessageId = emailMessage.Id;
		relationTo.RelationAddress = ownerEmail;
		relationTo.RelationType = 'ToAddress';
		relationTo.RelationId = ownerId;
		system.debug('>>>> relationTo >>> ' + relationTo);
		
		System.debug('EmailServiceUtil.emailSetup => relationTo: ' + relationTo);
		insert relationTo;
		
		System.debug('>>> email criado >>>');
		insertAttachmentFromEmail(email, emailMessage.Id);
		insertAttachmentFromEmail(email, idObjeto);
		// é um caso
		// if(idObjeto.startsWith('500')){

		// 	Case caso = CaseDAO.getById(idObjeto);
		// 	system.debug('>>> EmailServiceUtil.caso >>>' + caso );
		// 	if(caso.Owner.Type == 'User'){
		// 		system.debug('>>> EmailServiceUtil.caso >>>' + caso );
		// 		if(CdlUtil.validarAgenteDisponivelAtendimento(caso.OwnerId)){
		// 			system.debug('>>> Apresentar Agente >>>' + caso );
		// 			CdlUtil.apresentarRegistroConsoleAgente(caso.OwnerId, caso.Id, 'Case');
        //         }
        //         else{
        //         	system.debug('>>> caso.FilaOrigem__c >>>' + caso.FilaOrigem__c);

        //         	if(caso.FilaOrigem__c != null) caso.OwnerId = caso.FilaOrigem__c;
        //         	else {
        //         		string nomeFila;
        //         		if(caso.Account.Classificacao__c == Constants.ACCOUNT_CLASSIFICACAO_ESTRATEGICO) nomeFila = Constants.QUEUE_FILAESTRATEGICO;  
        //         		else nomeFila = Constants.QUEUE_FILACORPORATE;
        //         		Group filaDestino = Evmd.OrgData.getQueue(nomeFila);
        //         		caso.OwnerId = filaDestino.Id;
        //         	} 
        //         	update caso; 	
        //         }
		// 	}
		// 	return;
		// }
		// sendEmailNotificationToOwner(ownerEmail, emailMessage.Id, email);
		//return emailMessage;
	}
	// public static void sendEmailNotificationToOwner(string ownerEmail, Id idObjeto, Messaging.inboundEmail emailSetup){
	// 	ConfiguracaoOrg__mdt appConfigSubject = [SELECT Valor__c FROM ConfiguracaoOrg__mdt  WHERE DeveloperName = 'AssuntoEmailReply' LIMIT 1];
	// 	ConfiguracaoOrg__mdt appConfigBody = [SELECT Valor__c FROM ConfiguracaoOrg__mdt  WHERE DeveloperName = 'CorpoEmailReply' LIMIT 1];
	// 	//User user = [SELECT EMAIL FROM USER WHERE ID =: ownerId];

	// 	List<String> emails = new List<String>{ownerEmail}; 
	// 	String subject = appConfigSubject.Valor__c;
	// 	String body = appConfigBody.Valor__c.replace('{from}', emailSetup.FromName).replace('{subject}', emailSetup.subject).replace('{link}', '<a href="'+ URL.getSalesforceBaseUrl().toExternalForm() +'/'+ idObjeto + '">Detail</a>');

	// 	Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
	// 	email.setToAddresses(emails);
	// 	email.setSubject(subject);
	// 	email.setHtmlBody(body);
	// 	Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ email });
	// }
	public class ReturnObject {
		public Id Id{get;set;}
		public Id OwnerId{get;set;}
		public String OwnerEmail{get;set;}
	}
	public static String returnRefObject(String textoRef, String corpoEmail) {
		if(corpoEmail.indexOf(textoRef) != -1)
			return corpoEmail.substring(corpoEmail.indexOf(textoRef) + 8, corpoEmail.indexOf(textoRef) + 26);
		return '';
	}
	public static string returnCode(String texto, String code) {
		
		if(texto.indexOf(code) != -1){
			return texto.substring(texto.indexOf(code)).replace(code,'');
		}
		return null;
	}
	public static string returnRef(String texto){
		
		if(texto.indexOf('ref:_') != -1){
			return texto.substring(texto.indexOf('ref:_'));
		}
		return null;
	}
	//private string extrairCodigoVE(string subject){
	//	 return subject.substring(subject.indexOf('VE-')); 
	//}
	public static string extrairNumero(String subject) {

		String retorno = null;

		try {

			Pattern myPattern = Pattern.compile('^.*(\\d{8}).*');
			Matcher myMatcher = myPattern.matcher(subject);
			retorno = myMatcher.group(1);
		}
		catch(Exception ex) {
			System.debug('# ERRO: ' + ex.getMessage());
		}

		System.debug('# EXECUCAO - retorno: ' + retorno);

		return retorno;
	}
    public static void insertAttachmentFromEmail(Messaging.InboundEmail email, id parentId){
        // save atttachments
        if(email.textAttachments != null){
            for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
                Attachment attachment = new Attachment();

                attachment.Name = tAttachment.fileName;
                attachment.Body = Blob.valueOf(tAttachment.body);
                attachment.ParentId = parentId;
                insert attachment;
            }
        }
        if(email.binaryAttachments != null){
            for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
                Attachment attachment = new Attachment();

                attachment.Name = bAttachment.fileName;
                attachment.Body = bAttachment.body;
                attachment.ParentId = parentId;
                insert attachment;
            }
        }
    }
}