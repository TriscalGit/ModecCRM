public  class NAMFactory {
   
    public static NAM__c createNAM(Vessel__c vessel, string namName) {
        NAM__c nam = new NAM__c(
            Name = namName,
            Revision__c = 0,
            Status__c = 'AMC',
            Vessel__c = vessel.Id,
            IssueDate__c = Date.today(),
            Subject__c = 'Error 1',
            SystemNumber__c = '06 - Mooring System Mechanical Component',
            SubSystemNumber__c = 'Mooring Chain / Wire / Rope & Fairlead',
            TypeEvent__c = 'Accident',
            CriticalityCategory__c = 'Safety',
            CriticalityUrgency__c = 'Within 24 Hours',
            // ResponsibilityCategory__c = 'Warranty',
            Description__c = 'Descv',
            EscalationRisk__c = 'Escalation',
            CounterMeasure__c = 'Counter'
        );
        insert nam;
        return nam;
    }
    public static ExchangeRATE__c createExchange() {
        ExchangeRATE__c exchange = new ExchangeRATE__c(Active__c = true, value__c = 4);
            
        insert exchange;
        return exchange;
    }
}