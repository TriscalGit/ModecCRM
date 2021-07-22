/**
 * @File Name          : T_MODEC_SCH_ExpirarConta.cls
 * @Description        : 
 * @Author             : Mario Oliveira
 * @Group              : 
 * @Last Modified By   : Mario Oliveira
 * @Last Modified On   : 18/11/2019 16:32:19
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    18/11/2019   Mario Oliveira     Initial Version
**/
public with sharing class T_MODEC_SCH_ExpirarConta implements schedulable {
    
    public T_MODEC_SCH_ExpirarConta() {}

    public void execute(SchedulableContext paSchedulableContext)
    {
        T_SDK_DebugLog.EscreverLog('Chamando método de Expirar Contratos');
        T_SDK_ScheaduleUtils.abortScheadule(paSchedulableContext);
        T_MODEC_ExpirarConta_APP.ExpirarConta();
    }

}