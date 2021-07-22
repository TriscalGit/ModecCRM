/**
 * @File Name          : T_Account_Trigger.trigger
 * @Description        : 
 * @Author             : Mario Oliveira
 * @Group              : 
 * @Last Modified By   : Mario Oliveira
 * @Last Modified On   : 05/12/2019 19:31:35
 * @Modification Log   : 
 * Ver       Date            Author                 Modification
 * 1.0    05/12/2019   Mario Oliveira     Initial Version
**/
trigger T_Account_Trigger on Account(after delete, after insert, after undelete, after update, before delete, before insert, before update)
{
   Controle_de_Triggers__c ctrlTriggers = Controle_de_Triggers__c.getInstance();

   if (ctrlTriggers.Trigger_Account__c == true)
   {
      T_SDK_DebugLog.EscreverLog('Entrou na trigger de Account');
      TriggerFactory.createHandler(Account.sObjectType);
   }
}