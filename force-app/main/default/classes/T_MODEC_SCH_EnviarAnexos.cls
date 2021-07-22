/**
 * @File Name          : T_MODEC_SCH_EnviarAnexos.cls
 * @Description        : 
 * @Author             : Rafael Hadama
 * @Group              : 
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 02/12/2019 13:33:53
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    02/12/2019   Rafael Hadama     Initial Version
**/
public class T_MODEC_SCH_EnviarAnexos implements schedulable{


    public void execute(SchedulableContext paSchedulableContext)
    {
        T_SDK_DebugLog.EscreverLog('Iniciando Schedule Enviar Anexos');
        T_SDK_ScheaduleUtils.abortScheadule(paSchedulableContext);
        T_MODEC_SAP_EnvioAnexo_App.executarBatchEnvioAnexos();
    }
    
    
}