/*
###################################################################
Criado por: Felipe Cardozo
Criado em: 05/08/2019
Modificado por: Felipe Cardozo
Modificado em: 05/08/2019
###################################################################
Descrição:
Teste SDK para armazenar o log de maneira correta, se a chave DEBUG_MODE 
na customSettings estiver marcada
###################################################################
*/
@isTest
public class T_SDK_DebugLog_Test {
    
    public static T_Debug_Setting__mdt testSetting {get;set;}
    
    public static testmethod void TestLog()
    {
        testSetting = new T_Debug_Setting__mdt();
        testSetting.Label = 'Teste';
        testSetting.DeveloperName = 'Teste';
        testSetting.T_Armazenar_Cause__c = true;
        testSetting.T_Armazenar_linha_debug__c= true;
        testSetting.T_Armazenar_StackTrace__c= true;
        testSetting.T_Armazenar_texto_Exception__c= true;
        
        T_SDK_DebugLog.EscreverLog('Teste em execução.');
        T_SDK_DebugLog.EscreverException(new T_SDK_Exception('Teste em execução.'));    
        testSetting = null;
        T_SDK_DebugLog.EscreverLog('Teste em execução.');
        T_SDK_DebugLog.EscreverException(new T_SDK_Exception('Teste em execução.'));     
        String testeMsg = T_SDK_DebugLog.MontarTextoException(new T_SDK_Exception('Teste em execução.'));        
    }

    @istest public static void TstSDKEXception (){

        try
        {
            Account conta = new Account();
            insert conta;
        }
        catch(Exception e)
        {
        AuraHandledException auraEx = T_SDK_Exception.MontarAuraHandledException(e);
    }
    }

    @isTest public static void TstSDKConvert(){

        long mockLong = T_SDK_ConvertUtil.ConverteStringToLong('20');
        system.assertEquals(20, mockLong);
        string NegativeTst = null;
        T_SDK_ConvertUtil.ConverteStringToLong(NegativeTst);
    }

    
    @isTest public static void TstSDKSchema(){

        string FieldLabel = T_SDK_Schema.getFieldLabel('Account','Phone');
        system.assertEquals(true, FieldLabel != null);

        map<string, string> MapPicklistValues = T_SDK_Schema.getMapPicklistValuesLabels('Account','AccountSource');
        system.assertEquals(true, MapPicklistValues != null);
        
    }
    
}