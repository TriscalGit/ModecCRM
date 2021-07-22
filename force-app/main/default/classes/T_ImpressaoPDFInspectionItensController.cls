public class T_ImpressaoPDFInspectionItensController {

    public TW1_Interaction__c interaction {get; set;}
    public ApexPages.StandardController standardInspectionController;
    public List<TW1_Quality_Inspection_Receipt_Item__c> items {get; set;}    
    
    public T_ImpressaoPDFInspectionItensController(ApexPages.StandardController cntrl) {
        standardInspectionController = cntrl;        
        interaction = (TW1_Interaction__c) cntrl.getRecord();        
        getInspectionItems();
    }
    
    public void getInspectionItems(){
        PlatformCacheUtils.Parametro param = new PlatformCacheUtils.Parametro();
        param.particao = 'Interaction';
        param.particaoItem = 'ListaInspectionItemsIds';
        param.operation = 'get';
        
        List<PlatformCacheUtils.Parametro> params = new List<PlatformCacheUtils.Parametro>();
        params.add(param);
        
        List<List<String>> retorno = PlatformCacheUtils.manageValuesOnPartition(params);
        
        IF(retorno != null){
            //Query tem que ser colocada em uma reposity
            this.items = [select id,TW1_Quality_Inspection_Receipt__r.TW1_Purchase_Order__c,TW5_Quantity__c,TW5_Item_PO__c,TW1_Description__c,TW1_Quality_Inspection_Receipt__r.Name,
                          TW1_Quality_Inspection_Receipt__r.TW1_Facility__r.Name, TW1_Quality_Inspection_Receipt__r.TW1_Inspector_Name__c,
                          TW1_Quality_Inspection_Receipt__r.InspectionResultsDateFormula__c,StatusEtiquetaFormula__c, TW1_Quality_Inspection_Receipt__r.TW1_Invoice__c
                          from TW1_Quality_Inspection_Receipt_Item__c
                          where id in: retorno.get(0) 
                          limit 1000];            
        }
    }
}