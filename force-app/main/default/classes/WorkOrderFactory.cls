public class WorkOrderFactory {
    public static WorkOrder createWO( NAM__c nam, string contractor){
        WorkOrder wo = new WorkOrder(
            NAM__c = nam.Id,
            Revision__c = 0,
            AccountId = AccountFactory.insertAcc(Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId(), '').Id,
            Contractor__c = AccountFactory.insertAcc(Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId(), contractor).Id,
            MarkUp__c = 0.08,
            ISS__c = 0.02
        );
        insert wo;
        return wo;
    }

    public static WorkOrderLineItem createWOLineItem(WorkOrder wo, decimal amount ){
        WorkOrderLineItem woItem = new WorkOrderLineItem(
            WorkOrderId = wo.Id,
            Status = 'Estimation',
            MS__c = 'Service',
            Product__c = 'Product 1',
            responsibleCountry__c = 'Brazil',
            Price__c = amount);
        insert woItem;
        return woItem;
    }

    public static WorkOrderLineItem createWOLineItem(WorkOrder wo, decimal amount, String responsibleCountry ){
        WorkOrderLineItem woItem = new WorkOrderLineItem(
            WorkOrderId = wo.Id,
            Status = 'Estimation',
            MS__c = 'Service',
            Product__c = 'Product 1',
            responsibleCountry__c = responsibleCountry,
            Price__c = amount);
        insert woItem;
        return woItem;
    }
}