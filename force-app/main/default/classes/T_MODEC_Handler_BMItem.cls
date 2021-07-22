/**
 * @File Name          : T_MODEC_Handler_BMItem.cls
 * @Description        : Handler to the trigger for BM_Item__c object
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 30/03/2020 17:05:22
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    30/03/2020   Rafael Hadama     Initial Version
 **/
public class T_MODEC_Handler_BMItem implements ITrigger
{
   private boolean m_isExecuting  = false;
   private integer BatchSize      = 0;
   public static boolean firstRun = true;

   // Construtor
   public T_MODEC_Handler_BMItem(boolean isExecuting, integer size)
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
      T_SDK_DebugLog.EscreverLog('Executando método beforeDelete da trigger do objeto BMItem');
      BM_Item__c deletedItem = (BM_Item__c)so;
      T_MODEC_BMItem_App.AvoidDeleteOfBMItem(deletedItem);
   }

   public void afterInsert(SObject so)
   {
   }

   public void afterUpdate(SObject oldSo, SObject so)
   {
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