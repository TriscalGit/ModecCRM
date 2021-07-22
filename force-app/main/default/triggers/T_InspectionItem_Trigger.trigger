/**
 * @File Name          : T_InspectionItem_Trigger.trigger
 * @Description        : 
 * @Author             : Rafael Hadama
 * @Group              : 
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 17/06/2020 18:34:51
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    17/06/2020   Rafael Hadama     Initial Version
**/
trigger T_InspectionItem_Trigger on TW1_Inspection_Item__c(before insert, before update, after update)
{
    Controle_de_Triggers__c ctrlTriggers = Controle_de_Triggers__c.getInstance();

    if (ctrlTriggers.Trigger_Inspection_Item__c == true)
    {
        //system.debug('Entrou na trigger de TW1_Inspection_Item__c');
        TriggerFactory.createHandler(TW1_Inspection_Item__c.sObjectType);
    }
}