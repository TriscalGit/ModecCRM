public class WorkOrderBO {
    private static final WorkOrderBO instance = new WorkOrderBO();

	public static WorkOrderBO getInstance() {
		return instance;
	}
    public void cloneWO(List<WorkOrder> lstWO){
        Map<Id, Id> mapCloneWO = new Map<Id, Id>();
        for(WorkOrder woItem : lstWO){
            if(woItem.ClonedWO__c != null) mapCloneWO.put(woItem.ClonedWO__c, woItem.Id);
        }
        if(mapCloneWO.size() > 0){
            List<WorkOrder> lstCloned = WorkOrderDAO.getByWOItem(mapCloneWO.keySet());
            List<WorkOrderLineItem> lstWOLine = new  List<WorkOrderLineItem>();
            WorkOrderLineItem woLineItem;
            for(WorkOrder wo : lstCloned){
                for(WorkOrderLineItem woLine : wo.WorkOrderLineItems){
                    woLineItem = woLine.clone(false, false, false, false);
                    woLineItem.WorkOrderId = mapCloneWO.get(wo.Id);
                    woLineItem.ResponsibleCountry__c = woLine.ResponsibleCountry__c;
                    lstWOLine.add(woLineItem);
                }
            }
            insert lstWOLine;
        }
    }
    public void summarizingNAMValues(List<WorkOrder> lstWO){
        Set<String> setIds = new Set<String>();
        for(WorkOrder woItem : lstWO){
            setIds.add(woItem.NAM__c);
        }

        List<NAM__c> lstNAM = NamDAO.getById(setIds);
        Map<String, Decimal> mapNamWO = new Map<String, Decimal>();

        for(NAM__c namItem : lstNAM){

            namItem.MdbAmount__c = 0;
            namItem.MIIAmount__c = 0;
            namItem.MINCAmount__c = 0;
            namItem.ServiceMdbAmount__c = 0;
            namItem.MaterialMdbAmount__c = 0;
            namItem.ServiceMIIAmount__c = 0;
            namItem.MaterialMIIAmount__c = 0;                    
            namItem.ServiceMINCAmount__c = 0;
            namItem.MaterialMINCAmount__c = 0;
            
            namItem.BRLAmount__c = 0;              

            for(WorkOrder woItem : namItem.WorkOrders__r){
                if(woItem.Responsible__c == 'MdB'){ 
                    namItem.MdbAmount__c += woItem.TotalAmount__c;
                    namItem.ServiceMdbAmount__c += woItem.Service__c;
                    namItem.MaterialMdbAmount__c += woItem.Material__c;
                    namItem.BRLAmount__c += woItem.TotalBRL__c;
                }
                else if(woItem.Responsible__c == 'MII'){ 
                    namItem.MIIAmount__c += woItem.TotalAmount__c;
                    namItem.ServiceMIIAmount__c += woItem.Service__c;
                    namItem.MaterialMIIAmount__c += woItem.Material__c;                    
                }
                else if(woItem.Responsible__c == 'MINC'){ 
                    namItem.MINCAmount__c += woItem.TotalAmount__c;
                    namItem.ServiceMINCAmount__c += woItem.Service__c;
                    namItem.MaterialMINCAmount__c += woItem.Material__c;                    
                }                          
            }
        }
        update lstNAM;
    }

    public void fillWOPrimaryNumberInNAM(List<WorkOrder> lstWO){
        Set<String> setIds = new Set<String>();
        for(WorkOrder wo : lstWO){
            setIds.add(wo.NAM__c);
        }

        List<NAM__c> lstNAM = NamDAO.getById(setIds);
        if (!lstNAM.isEmpty()) {
            List<NAM__c> lstNAMUpdate = new List<NAM__c>();
            for(WorkOrder wo : lstWO){
                for(NAM__c nam : lstNAM){
                    if(!String.isBlank(wo.WorkOrderPrimaryNumber__c) && String.isBlank(nam.WorkOrderPrimaryNumber__c)){
                        nam.WorkOrderPrimaryNumber__c = wo.WorkOrderPrimaryNumber__c;
                        lstNAMUpdate.add(nam);
                    }
                }
            }
            if(!lstNAMUpdate.isEmpty())
                update lstNAMUpdate;
        }
    }

    public void beforeInsertWO(List<WorkOrder> lstWO){
        String modecInc = System.Label.MINC;
        String scopeOfWorkMINC = '<p>The scope defined here is covering the scope of overall NAM.</p> <p>The actual scope of the Contractor is demarcated as &quot;Brazil&quot; under &quot;Responsible&quot; in the table under section PRICE/RATES AND TERMS OF PAYMENT.</p> <br/>'; 
        Set<String> setIDs = new Set<String>();

        for(WorkOrder item : lstWO){
            item.CurrencyIsoCode = 'USD';
            setIDs.add(item.NAM__c);    
        }

        Map<Id, NAM__c> mapNAM = new Map<Id, NAM__c>(NamDAO.getById(setIDs));
        for(WorkOrder woItem : lstWO){
             
            if(mapNAM.containsKey(woItem.NAM__c)){
                NAM__c nam = mapNAM.get(woItem.NAM__c);
                woItem.WOAttention__c = woItem.AccountId == modecInc ? nam.Vessel__r.WOAttention__c : nam.Vessel__r.WOAttentionMINC__c;
                if(woItem.AccountId != modecInc && woItem.VesselClientId__c != null) woItem.AccountId = woItem.VesselClientId__c;
                woItem.ScopeWork__c = woItem.AccountId != modecInc ? woItem.ScopeWork__c : scopeOfWorkMINC + woItem.ScopeWork__c;
                
                if(!woItem.ByPassRenameWO__c){
                    Integer index = nam.Name.indexOf('_r');
                    String nameWO = nam.Name.replace('NAM', 'WO');
                    if(index != -1) nameWO = nameWO.subString(0, index -1);
                    woItem.WorkOrderPrimaryNumber__c = nameWO;
                    woItem.WorkOrder__c = nameWO + '-' + String.valueOf(nam.WorkOrders__r.size() + 1)+'_r'+woItem.NAMRevision__c; //WO-MV27-00-006-2_r0
                }
            }
        }
    }
    public void generateNewPdf(List<WorkOrder> lstWO, Map<Id, WorkOrder> mapOld){
        Map<String, String> mapIdVsName = new Map<String, String>();
        for(WorkOrder wo : lstWO){
            if(wo.WorkOrder__c != mapOld.get(wo.Id).WorkOrder__c){ 
                mapIdVsName.put(wo.Id, mapOld.get(wo.Id).WorkOrder__c);
            }
        }
        GeneratePdfController.savePdfFuture(JSON.serialize(mapIdVsName), 'WorkOrder'); 
    }
}