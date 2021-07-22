/**
 * @File Name          : T_MODEC_Handler_InspecItem.cls
 * @Description        : Classe Handler para trigger do sobject TW1_Inspection_Item__c
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 03/07/2020 12:29:49
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    17/06/2020   Rafael Hadama     Initial Version
 **/
public class T_MODEC_Handler_InspecItem implements ITrigger
{
    private boolean m_isExecuting  = false;
    private integer BatchSize      = 0;
    public static boolean firstRun = true;

    // Construtor
    public T_MODEC_Handler_InspecItem(boolean isExecuting, integer size)
    {
        m_isExecuting = isExecuting;
        BatchSize     = size;
    }

    public void bulkBefore()
    {
    }

    public void bulkAfter()
    {
    }

    public void beforeInsert(SObject so)
    {
    }

    public void beforeUpdate(SObject oldSo, SObject so)
    {
    }

    public void beforeDelete(SObject so)
    {
    }

    public void afterInsert(SObject so)
    {
    }

    public void afterUpdate(SObject oldSo, SObject so)
    {
        //T_SDK_DebugLog.EscreverLog('Executando método afterUpdate da trigger 2 do objeto Request');
        TW1_Inspection_Item__c OldInspecItem = (TW1_Inspection_Item__c)oldSo;
        TW1_Inspection_Item__c NewInspecItem = (TW1_Inspection_Item__c)so;

        system.debug('Trigger AfterUpdate InspectItem Object');
        //T_MODEC_InspectionItem_App.CheckAllInspectionItens(OldInspecItem, NewInspecItem);
    }

    public void afterDelete(SObject so)
    {
    }

    public void OnUndelete(SObject restoredSObject)
    {
    }

    public void andFinally()
    {
    }
}