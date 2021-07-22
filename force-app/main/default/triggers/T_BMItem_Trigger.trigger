trigger T_BMItem_Trigger on BM_Item__c(after delete, after insert, after undelete, after update, before delete, before insert, before update)
{
   Controle_de_Triggers__c ctrlTriggers = Controle_de_Triggers__c.getInstance();

   if (ctrlTriggers.Trigger_BMItem__c == true)
   {
      T_SDK_DebugLog.EscreverLog('Entrou na trigger de BMITEM');
      TriggerFactory.createHandler(BM_Item__c.sObjectType);
   }
}