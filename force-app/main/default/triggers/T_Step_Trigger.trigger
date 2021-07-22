/**
 * @File Name          : T_Step_Trigger.trigger
 * @Description        :
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 10-29-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    03/07/2020   Rafael Hadama     Initial Version
 **/
trigger T_Step_Trigger on TW1_Step__c(before update, after update)
{
    Controle_de_Triggers__c ctrlTriggers = Controle_de_Triggers__c.getInstance();

    if (ctrlTriggers.Trigger_Step__c == true)
    {
        if (TriggerFactory.stopStepTrigger)
        {
            //system.debug('Entrou na trigger de TW1_Step__c');
            TriggerFactory.createHandler(TW1_Step__c.sObjectType);
        }
    }
}