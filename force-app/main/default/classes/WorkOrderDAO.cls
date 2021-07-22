public class WorkOrderDAO {
    public static WorkOrder getById(Id woId){
        List<WorkOrder> lst = WorkOrderDAO.getByWOItem(new Set<Id>{woId});
        
        if(lst.size() > 0) return lst[0];
        else return null;
    }
    public static List<WorkOrder> getByWOItem(Set<Id> setIds){
        return [SELECT 
                    ID,
                    WorkOrder__c,
                    NAM__c,
                    Responsible__c,
                    ContractTerm__c,
                    ( SELECT 
                        WorkOrderId,
                        Product__c,
                        Status,
                        MS__c,
                        Price__c,
                        Responsible__c,
                        ResponsibleCountry__c,
                        Vendor__c,
                        BRL__c
                    FROM WorkOrderLineItems)
                 FROM WorkOrder 
                 WHERE Id IN : setIds];
    }

    public static List<WorkOrder> getByNAMId(Set<Id> setIds){
        return  [SELECT 
                    Id,
                    WorkOrder__c,
                    NAM__c,
                    NAMRevision__c,
                    ClosedOutRevision__c 
                 FROM WorkOrder 
                 WHERE NAM__c IN : setIds];
    }
}