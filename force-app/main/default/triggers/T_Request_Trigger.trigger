/**
 * @File Name          : T_Request_Trigger.trigger
 * @Description        : Trigger do objeto TW1_Request__c
 * @Author             : Mario Oliveira
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 15/05/2020 19:14:13
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    05/11/2019   Mario Oliveira     Initial Version
 **/
trigger T_Request_Trigger on TW1_Request__c(after delete, after insert, after undelete, after update, before delete, before insert, before update)
{
   Controle_de_Triggers__c ctrlTriggers = Controle_de_Triggers__c.getInstance();

   if (ctrlTriggers.Trigger_Request__c == true)
   {
      if (TriggerFactory.stopRequestTrigger)
      {
         T_SDK_DebugLog.EscreverLog('Entrou na trigger de Request');
         TriggerFactory.createHandler(TW1_Request__c.sObjectType);
      }
   }
}