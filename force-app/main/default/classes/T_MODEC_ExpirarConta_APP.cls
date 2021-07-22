/**
 * @File Name          : T_MODEC_ExpirarConta_APP.cls
 * @Description        : 
 * @Author             : Mario Oliveira
 * @Group              : 
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 18/11/2019 18:41:12
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    18/11/2019   Mario Oliveira     Initial Version
**/
public with sharing class T_MODEC_ExpirarConta_APP {

    public static void ExpirarConta() {
            
        List<Account> contas = T_MODEC_Account_REP.buscarContasExpiradas();
        RecordType recAcc = [ SELECT Id, DeveloperName, SObjectType FROM RecordType WHERE SObjectType = 'Account' And DeveloperName = 'TW1_Vendor_Not_Homologated'];
        T_SDK_DebugLog.EscreverLog('lista de contas:' + contas);

        try {

            T_SDK_DebugLog.EscreverLog('Entrou no "TRY" da classe "ExpirarConta" em "T_MODEC_ExpirarConta_APP"');
            for (Account cont : contas) {

                T_SDK_DebugLog.EscreverLog('Entrou no "FOR" do "TRY" da classe "ExpirarConta"');
                cont.TW1_Vendor_Vetting__c = 'Vetting Expired';
                cont.RecordTypeId = recAcc.id;
                
            }

            T_SDK_DebugLog.EscreverLog('"UPDATE" da lista de contas');
            update contas;
            
        } catch (Exception exc) {
            
            T_SDK_DebugLog.EscreverLog('Entrou no "CATCH" da classe "ExpirarConta" em "T_MODEC_ExpirarConta_APP"');
            T_SDK_DebugLog.EscreverLog('' + exc.getStackTraceString());
            T_SDK_DebugLog.EscreverLog('' + exc.getMessage());

        } finally{

            T_SDK_DebugLog.EscreverLog('Entrou no "FINALLY" da classe "ExpirarConta" em "T_MODEC_ExpirarConta_APP"');
            scheaduleJobAgain('T_MODEC_SCH_ExpirarConta');
            
        }
        
    }

    //método para schedular novamente.
    public static void scheaduleJobAgain(String jobName){
        
        T_SDK_DebugLog.EscreverLog('Entrou na classe "scheaduleJobAgain"');
        T_SDK_ScheaduleUtils.scheadule(jobName, 1440); // 24 horas = 1440 minutos

    }

}