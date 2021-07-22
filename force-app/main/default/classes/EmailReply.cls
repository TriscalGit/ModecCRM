global class EmailReply implements Messaging.InboundEmailHandler {
	
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail emailInbound, Messaging.InboundEnvelope env) {


	   try {
			/* System.debug('# INICIO');
			System.debug('# EXECUCAO - Email');
			System.debug('# EXECUCAO - Email headers: ' + emailInbound.headers);
			System.debug('# EXECUCAO - Email toAddresses: ' + emailInbound.toAddresses);
			System.debug('# EXECUCAO - emailInbound ccAddresses: ' + emailInbound.ccAddresses);
			System.debug('# EXECUCAO - emailInbound fromAddress: ' + emailInbound.fromAddress);
			System.debug('# EXECUCAO - emailInbound fromName: ' + emailInbound.fromName);
			System.debug('# EXECUCAO - emailInbound subject: ' + emailInbound.subject);
			System.debug('# EXECUCAO - emailInbound plainTextBody: ' + emailInbound.plainTextBody);

			System.debug('# EXECUCAO - emailInbound htmlBody: ' + emailInbound.htmlBody); */

			string body = emailInbound.htmlBody;
			String subject = emailInbound.subject;
			Integer index = body.indexOf('::ref__::');
			Integer indexSubject = subject.indexOf('::ref__::');
			Integer indexSubjectStatus = subject.indexOf('::Status::');
			Id objetoId;
			Id ownerId;
			String ownerEmail;
			System.debug('# EmailReply -> index :' + index);
			System.debug('# EmailReply -> indexSubject :' + indexSubject);
			System.debug('# EmailReply -> indexSubjectStatus :' + indexSubjectStatus);

			if(subject.length() > 8 && subject.substring(0,8) == 'Sandbox:') return null;   
			if(index != -1){

				string codigo = body.substring(index + 9, index + 24);

				System.debug('# EmailReply -> codigo ' + codigo);
                System.debug('# EmailReply  -> Util.objDeveloperName(codigo) ' + Util.objDeveloperName(codigo));

				if(Util.objDeveloperName(codigo) == 'NAM__c') { // lead
					
					NAM__c namObj = NamDAO.getById(codigo);
                    if(namObj == null) return null;

					System.debug('namObj Encontrado');
					System.debug(namObj);

					objetoId = namObj.Id;
					System.debug('Object Id');
					System.debug(objetoId);

					ownerId = namObj.OwnerId;
					System.debug('Owner Id');
					System.debug(ownerId);

					ownerEmail = namObj.Owner.Email;
					System.debug('Owner email');
					System.debug(ownerEmail);
				}
				else if(Util.objDeveloperName(codigo) == 'Clarification__c') { // lead
					
					Clarification__c Obj = ClarificationDAO.getById(codigo);
                    if(Obj == null) return null;

					System.debug('namObj Encontrado');
					System.debug(Obj);

					objetoId = Obj.Id;
					System.debug('Object Id');
					System.debug(objetoId);

					ownerId = Obj.OwnerId;
					System.debug('Owner Id');
					System.debug(ownerId);

					ownerEmail = Obj.Owner.Email;
					System.debug('Owner email');
					System.debug(ownerEmail);
				}
				else if(Util.objDeveloperName(codigo) == 'TechClarification__c') { // lead
						List<TechClarification__c> lst = [SELECT OwnerId, Owner.Email, Name FROM TechClarification__c WHERE ID =: codigo];
						if(lst.size() == 0) return null;

						System.debug('TEch Encontrado');
						System.debug(lst[0]);

						objetoId = lst[0].Id;
						System.debug('Object Id');
						System.debug(lst[0]);

						ownerId = lst[0].OwnerId;
						System.debug('Owner Id');
						System.debug(ownerId);

						ownerEmail = lst[0].Owner.Email;
						System.debug('Owner email');
						System.debug(ownerEmail);
				}
				EmailServiceUtil.emailSetup(emailInbound, objetoId, ownerId, ownerEmail);
            }

		}catch(Exception e){
			System.debug('Error: line: ' + e.getLineNumber() +  ' message: ' + e.getMessage());
		}
	
		return null;
	}
}