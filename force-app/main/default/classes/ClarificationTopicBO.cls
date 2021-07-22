public class ClarificationTopicBO {
    private static final ClarificationTopicBO instance = new ClarificationTopicBO();

	public static ClarificationTopicBO getInstance() {
		return instance;
	}

	public void fillClarification(List<ClarificationTopic__c> lstClarificationTopic) {
		Map<Id, User> mapUserById = new Map<Id, User>();
		Map<String, NAM__c> mapNamById = new Map<String, NAM__c>();

		for(ClarificationTopic__c objClarificationTopic : lstClarificationTopic) {
			mapUserById.put(objClarificationTopic.OwnerId, null);
			mapNamById.put(objClarificationTopic.NAM1__c, null);
		}

		CollectionUtil.carregarMap(mapUserById, 'Id', UserDAO.getById(mapUserById.keySet()));
		CollectionUtil.carregarMap(mapNamById, 'Id', NamDAO.getById(mapNamById.keySet()));

		for(ClarificationTopic__c objClarificationTopic : lstClarificationTopic) {
			User objUser = mapUserById.get(objClarificationTopic.OwnerId);
			NAM__c objNam = mapNamById.get(objClarificationTopic.NAM1__c);
			if(objNam != null){
				String clarificationType = objNam.ClosedOutClarificationCreated__c ? 'Closed Out' : 'NAM';

				for(Clarification__c objClarification : objNam.Clarifications__r) {
					Boolean isClarificationPartner = objUser.UserRole.DeveloperName.contains(objClarification.Partner__c);
					if(objClarification.Type__c == clarificationType && isClarificationPartner)	objClarificationTopic.Clarification__c = objClarification.Id;
				}

				if(objClarificationTopic.Clarification__c == null) {
					objClarificationTopic.Clarification__c = objNam.Clarifications__r[0].Id;
				}
			}
		}
	}
}