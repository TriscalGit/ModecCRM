public class ClarificationFactory {
    public static Clarification__c createClarification (NAM__c nam, string type) {
        Clarification__c clarificartion = new Clarification__c(
            NAM__c = nam.Id,
            Status__c = 'Pending',
            Partner__c = 'Mitsui',
            Type__c = type
        );
        insert clarificartion;
        return clarificartion;
    }

    public static Clarification__c createClarificationPartner (NAM__c nam, string type, string partner) {
        Clarification__c clarificartion = new Clarification__c(
            NAM__c = nam.Id,
            Status__c = 'Pending',
            Partner__c = partner,
            Type__c = type
        );
        insert clarificartion;
        return clarificartion;
    }


     public static ClarificationTopic__c createClarificationTopic (Clarification__c clarification) {
        ClarificationTopic__c clarificartionTopic = new ClarificationTopic__c(
            NAM1__c = clarification.NAM__c,
            Clarification__c = clarification.Id,
            Name = 'Clarification 1'
        );
        insert clarificartionTopic;
        return clarificartionTopic;
    }
}