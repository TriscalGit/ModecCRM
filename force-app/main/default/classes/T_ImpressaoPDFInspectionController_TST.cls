@isTest
public class T_ImpressaoPDFInspectionController_TST {

    Private static Id QualityReceiptInspection = Schema.SObjectType.TW1_Interaction__c.getRecordTypeInfosByDeveloperName().get('TW1_Receipt_Inspection').getRecordTypeId();

    @TestSetup
    Public static void TestSetup(){
        Account conta = new Account();
        conta.name = 'TestClass';
        insert conta;
        
		TW1_Facility__c unit = new TW1_Facility__c();
        unit.TW1_Type__c = 'Vessel';
        unit.Name = 'Macaé';        
        insert unit;    
            
        TW1_Interaction__c interaction = new TW1_Interaction__c();
        interaction.RecordTypeId = QualityReceiptInspection;
        interaction.TW1_Supplier__c = conta.id;
        interaction.TW5_International_Company__c = 'No';
        interaction.TW5_Inspection_Type__c = 'Normal';
        interaction.TW5_Invoice_Value__c = 1;
        interaction.TW1_Invoice__c	= 'Test';
        interaction.TW1_Purchase_Order__c = 'TestTest';
        interaction.TW1_Facility__c = unit.id;
        interaction.TW1_Location_Base__c = 'Base Macaé';
        interaction.TW5_Inbound_Base_Date__c = Date.today();
        interaction.TW5_Delivery_Date_to_Inspection__c = Date.today() + 10;
		interaction.TW5_Quality_Receipt_Status__c = 'Not Submitted';        
        insert interaction;
            
        //interaction.TW5_Quality_Receipt_Status__c = 'Submitted';
        //update interaction;
        
        TW1_Quality_Inspection_Receipt_Item__c itemUm = new TW1_Quality_Inspection_Receipt_Item__c();
        itemUm.TW1_Quality_Inspection_Receipt__c = interaction.id;
        itemUm.TW5_Quantity__c = 2;
        itemUm.TW5_Item_PO__c = 3;
        itemUm.TW5_Family_of_Materials__c = 'Consumables';
        itemUm.TW1_Item_Value__c = 123;
        itemUm.TW1_Description__c = 'sdfafdajgahfçgafgajlfganvaovjaocsjmgbçvjg';        
        insert itemUm;
        
        TW1_Quality_Inspection_Receipt_Item__c itemDois = new TW1_Quality_Inspection_Receipt_Item__c();
        itemDois.TW1_Quality_Inspection_Receipt__c = interaction.id;
        itemDois.TW5_Quantity__c = 4;
        itemDois.TW5_Item_PO__c = 32;
        itemDois.TW5_Family_of_Materials__c = 'Pipe Fittings';
        itemDois.TW1_Item_Value__c = 754;
        itemDois.TW1_Description__c = 'nçanvçnaringjaopabvt';        
        insert itemDois;  
    }
    
    @isTest
    public static void testMethod_getInspectionItems(){
        TW1_Interaction__c interaction = [SELECT id FROM TW1_Interaction__c WHERE TW1_Invoice__c = 'Test' LIMIT 1];
        
        List<TW1_Quality_Inspection_Receipt_Item__c> itens = [SELECT id FROM TW1_Quality_Inspection_Receipt_Item__c WHERE TW1_Quality_Inspection_Receipt__c = :interaction.id];
        List<String> listIdsItens = new List<String>();
        for(TW1_Quality_Inspection_Receipt_Item__c item : itens){
            listIdsItens.add(item.id);
        }
        
        PlatformCacheUtils.Parametro param = new PlatformCacheUtils.Parametro();
        param.operation = 'set';
        param.particao = 'Interaction';
        param.particaoItem = 'ListaInspectionItemsIds';
        param.value = listIdsItens;
        PlatformCacheUtils.manageValuesOnPartition(new List<PlatformCacheUtils.Parametro>{param});
        
        ApexPages.StandardController sc = new ApexPages.StandardController ( interaction );    
        T_ImpressaoPDFInspectionItensController ic = new T_ImpressaoPDFInspectionItensController(sc);
    }
}