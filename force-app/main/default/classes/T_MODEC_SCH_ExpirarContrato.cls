/**
 * @File Name          : T_MODEC_SCH_ExpirarContrato.cls
 * @Description        : 
 * @Author             : Mario Oliveira
 * @Group              : 
 * @Last Modified By   : Mario Oliveira
 * @Last Modified On   : 14/11/2019 15:33:31
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    14/11/2019   Mario Oliveira     Initial Version
**/
public with sharing class T_MODEC_SCH_ExpirarContrato implements schedulable {
    
    public T_MODEC_SCH_ExpirarContrato() {}

    public void execute(SchedulableContext paSchedulableContext)
    {
        T_SDK_DebugLog.EscreverLog('Chamando método de Expirar Contratos');
        T_SDK_ScheaduleUtils.abortScheadule(paSchedulableContext);
        T_MODEC_ExpirarContrato_APP.ExpirarContrato();
    }

}