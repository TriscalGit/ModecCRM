/**
 * @File Name          : T_MODEC_SCH_DeleteDocumentations.cls
 * @Description        : Classe Schedule que executa método de DeleteDocumentation
 * @Author             : Rafael Hadama
 * @Group              : 
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 17/12/2019 17:04:52
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    17/12/2019   Rafael Hadama     Initial Version
**/
public class T_MODEC_SCH_DeleteDocumentations implements schedulable{

    public void execute(SchedulableContext paSchedulableContext)
    {
        T_SDK_DebugLog.EscreverLog('Chamando método de Expirar Contratos');
        T_SDK_ScheaduleUtils.abortScheadule(paSchedulableContext);
        T_MODEC_DeleteDocumentation_App.deleteDocs();
    }
    
}