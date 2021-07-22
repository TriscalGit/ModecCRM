/**
 * @File Name          : T_MODEC_SCH_ExpirarCategoria.cls
 * @Description        : 
 * @Author             : Rafael Hadama
 * @Group              : 
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 19/02/2020 14:09:23
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    18/02/2020   Rafael Hadama     Initial Version
**/
public with sharing class T_MODEC_SCH_ExpirarCategoria implements schedulable {
    
    public T_MODEC_SCH_ExpirarCategoria() {}

    public void execute(SchedulableContext paSchedulableContext)
    {
        T_SDK_DebugLog.EscreverLog('Chamando método de Expirar Categorias');
        T_SDK_ScheaduleUtils.abortScheadule(paSchedulableContext);
        T_MODEC_ExpirarCategoria_APP.ExpirarCategoria();
    }

}