/**
 * @File Name          : T_MODEC_ExpirarContrato_APP.cls
 * @Description        : 
 * @Author             : Mario Oliveira
 * @Group              : 
 * @Last Modified By   : Mario Oliveira
 * @Last Modified On   : 18/11/2019 14:38:00
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    14/11/2019   Mario Oliveira     Initial Version
**/
public with sharing class T_MODEC_ExpirarContrato_APP {
    
    public static void ExpirarContrato() {
            
        List<TW1_MODEC_Contract__c> contracts = T_MODEC_ContratoSuporteReq_REP.buscarContratosExpirados();
        T_SDK_DebugLog.EscreverLog('lista de contratos:' + contracts);

        try {

            T_SDK_DebugLog.EscreverLog('Entrou no "TRY" da classe "ExpirarContrato" em "T_MODEC_ExpirarContrato_APP"');
            for (TW1_MODEC_Contract__c cont : contracts) {

                T_SDK_DebugLog.EscreverLog('Entrou no "FOR" do "TRY" da classe "ExpirarContrato"');
                cont.TW1_Status__c = 'Expired';
                
            }

            T_SDK_DebugLog.EscreverLog('"UPSERT" da lista de contratos');
            update contracts;
            
        } catch (Exception exc) {
            
            T_SDK_DebugLog.EscreverLog('Entrou no "CATCH" da classe "ExpirarContrato" em "T_MODEC_ExpirarContrato_APP"');
            T_SDK_DebugLog.EscreverLog('' + exc.getStackTraceString());
            T_SDK_DebugLog.EscreverLog('' + exc.getMessage());

        } finally{

            T_SDK_DebugLog.EscreverLog('Entrou no "FINALLY" da classe "ExpirarContrato" em "T_MODEC_ExpirarContrato_APP"');
            scheaduleJobAgain('T_MODEC_SCH_ExpirarContrato');
            
        }
        
    }

    //método para schedular novamente.
    public static void scheaduleJobAgain(String jobName){
        
        T_SDK_DebugLog.EscreverLog('Entrou na classe "scheaduleJobAgain"');
        T_SDK_ScheaduleUtils.scheadule(jobName, 1440); // 24 horas = 1440 minutos

    }

}