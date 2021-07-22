/**
* @File Name          : T_MODEC_BAT_EnvioAnexosSAP.cls
* @Description        :
* @Author             : Rafael Hadama
* @Group              :
* @Last Modified By   : Rafael Hadama
* @Last Modified On   : 29/02/2020 12:01:28
* @Modification Log   :
* Ver       Date            Author              Modification
* 1.0    02/12/2019   Rafael Hadama     Initial Version
**/
global class T_MODEC_BAT_EnvioAnexosSAP implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    /*
* Variável de Log de integração para ser salvo somente no final de todo processo
*/
    global T_SDK_LogIntegracaoApp logIntegracaoApp;
    
    global String anexosEnviados = '';
    
    global map<string, string> mapContDocId_BMnumber;
    
    public T_MODEC_BAT_EnvioAnexosSAP
        (Map<String, String> paMapContId_BMNumber)
    {
        this.mapContDocId_BMnumber = paMapContId_BMNumber;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([SELECT Id, TW1_IsNF__c, ContentDocumentId, TW1_Last_SAP_request__c, TW1_Last_SAP_response__c, TW1_Upload_Sucess_SAP__c, IsLatest, VersionNumber, Title, VersionData, ContentSize, FileExtension FROM ContentVersion where ContentDocumentId IN: mapContDocId_BMnumber.keyset() AND IsLatest = true]);
    }
    
    global void execute(Database.BatchableContext BC, List<ContentVersion> records)
    {
        // Inicializar Log de integração
        T_SDK_DebugLog.EscreverLog('Iniciando processo de Enviar Anexo ao SAP');
        T_SDK_DebugLog.EscreverLog('Iniciando service agente de envio de Anexos');
        T_MODEC_SAP_EnvioAnexo anexoClientServiceAgent = new T_MODEC_SAP_EnvioAnexo();
        
        
        
        // Variável para log de integração
        if (logIntegracaoApp == null)
        {
            T_SDK_DebugLog.EscreverLog('Iniciando Log de integração');
            logIntegracaoApp = new T_SDK_LogIntegracaoApp('EnvioAnexo_Log');
            logIntegracaoApp.Log.T_Request__c  = 'Ver em anexo';
            logIntegracaoApp.Log.T_Response__c = 'Ver em anexo';
        }
        
        if (records.size() < 1)
        {
            T_SDK_DebugLog.EscreverLog('Reagendando schedule de atualização');
            return;
        }
        
        
        T_SDK_DebugLog.EscreverLog('Content Version size e list: ' + records.size() + '. lista ' + records);
        T_SDK_DebugLog.EscreverLog('Content Version TW1_Last_SAP_request > ' + records[0].TW1_Last_SAP_request__c);
        T_SDK_DebugLog.EscreverLog('Content Version TW1_Last_SAP_response > ' + records[0].TW1_Last_SAP_response__c);
        T_SDK_DebugLog.EscreverLog('Content Version TW1_Upload_Sucess_SAP > ' + records[0].TW1_Upload_Sucess_SAP__c);
        
        
        
        ContentVersion anexoUpdate = [Select id, TW1_Last_SAP_request__c, ContentDocumentId from ContentVersion where id =:records[0].id];
        
        
        
        try
        {
            //Validando se o arquivo deve ser enviado.
            
            If(records[0].TW1_IsNF__c == true)
            {
                T_SDK_DebugLog.EscreverLog('Anexo '+records[0].Title+' com id: ' + records[0].ContentDocumentId + 'é Nota Fiscal.');
                anexosEnviados += 'Anexo '+records[0].Title+' com id: ' + records[0].ContentDocumentId + 'é Nota Fiscal. \n';
                return;
            }
            
            If(records[0].TW1_Upload_Sucess_SAP__c != null)
            {
                T_SDK_DebugLog.EscreverLog('Anexo '+records[0].Title+' com id: ' + records[0].ContentDocumentId + ' já foi enviado com sucesso.');
                anexosEnviados += 'Anexo '+records[0].Title+' com id: ' + records[0].ContentDocumentId + ' já foi enviado com sucesso. \n';
                return;
            }
            
            If(records[0].TW1_Last_SAP_request__c != null && records[0].TW1_Last_SAP_response__c != null)
            {
                if (records[0].TW1_Last_SAP_request__c >= records[0].TW1_Last_SAP_response__c)
                {
                    T_SDK_DebugLog.EscreverLog('Anexo '+records[0].Title+' com id: ' + records[0].ContentDocumentId + ' está aguardando retorno do callback.');
                    anexosEnviados += 'Anexo '+records[0].Title+' com id: ' + records[0].ContentDocumentId + ' está aguardando retorno do callback. \n';
                    return;
                }
            }
            if ((records[0].TW1_Last_SAP_request__c != null) && (records[0].TW1_Last_SAP_response__c == null))
            {
                T_SDK_DebugLog.EscreverLog('Anexo '+records[0].Title+' com id: ' + records[0].ContentDocumentId + ' está aguardando retorno do primeiro callback.');
                anexosEnviados += 'Anexo '+records[0].Title+' com id: ' + records[0].ContentDocumentId + ' está aguardando retorno do primeiro callback. \n';
                return;
            }
            
            // Criando obj DTO para envio ao SAP
            T_SDK_DebugLog.EscreverLog('Preparando DTO para envio anexo');
            //Criando variavel de DTO para envio.
            T_MODEC_SAP_EnvioAnexo.anexoDto bmAnexoDTO = new T_MODEC_SAP_EnvioAnexo.anexoDto();
            bmAnexoDTO.ENTRYSHEET  = mapContDocId_BMnumber.get(records[0].ContentDocumentId);
            bmAnexoDTO.ARC_TITLE   = records[0].Title;
            bmAnexoDTO.ARC_TYPE    = records[0].FileExtension;
            bmAnexoDTO.EXTERNAL_ID = records[0].ContentDocumentId;
            bmAnexoDTO.BASE64      = EncodingUtil.base64Encode(records[0].VersionData);
            
            T_MODEC_SAP_EnvioAnexo EnvioAnexoServAgent = new T_MODEC_SAP_EnvioAnexo();
            HTTPResponse response = EnvioAnexoServAgent.PostEnviarAnexo(bmAnexoDTO);
            
            // Salvar retorno do serviço como anexo no JSON
            T_SDK_DebugLog.EscreverLog('Anexando response ao log de integração');
            //this.logIntegracaoApp.AnexarProcessoLog('Response consulta ' + conta.CNPJ__c, JSON.serialize(listaClientesWBC));
            
            
            T_SDK_DebugLog.EscreverLog('HTTPResponse ' + response);
            //Guardando Status do Sucesso do envio para salvar no log
            if (response.getStatus() == 'Accepted')
            {
                anexosEnviados += 'Anexo com id (' + records[0].ContentDocumentId + ') enviado com sucesso ao SAP. \n';
                anexoUpdate.TW1_Last_SAP_request__c = datetime.now();
            }
            else
            {
                anexosEnviados += 'Erro ao enviar Anexo com id (' + records[0].ContentDocumentId + '), ResponseStatus:' + response.getStatus() + ', ResponseStatusCode' + response.getStatusCode() + '. \n';
            }
        }
        catch (Exception e)
        {
            this.logIntegracaoApp.IncluirDetalheLogIntegracao(T_SDK_DebugLog.MontarTextoException(e), records[0].ContentDocumentId);
            this.logIntegracaoApp.AtualizaStatusLogIntegracao('PROCESSADO_ERRO');
        }
        
        
        if (!Test.isRunningTest())
        {
            DataBase.SaveResult resultDml = DataBase.update(anexoUpdate, false);
            // Iterate through each returned result
            
            if (!resultDml.isSuccess())
            {
                // Operation failed, so get all errors
                for (Database.Error err : resultDml.getErrors())
                {
                    this.logIntegracaoApp.Log.T_Status__c = 'PROCESSADO_ERRO';
                    anexosEnviados += 'ERRO_DML ID (' + anexoUpdate.ContentDocumentId + ') ' + err.getStatusCode() + ': ' + err.getMessage() + '\n';
                    //this.logIntegracaoApp.IncluirDetalheLogIntegracao(erroDetalhe, 'ERRO_DML_UPDATE');
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext BC)
    {
        if (this.logIntegracaoApp != null)
        {
            if (this.logIntegracaoApp.Log.T_Request__c != 'NAOINICIADO')
            {
                if (anexosEnviados != '')
                {
                    this.logIntegracaoApp.AnexarProcessoLog('Detalhes do Processo', anexosEnviados);
                }
                if (this.logIntegracaoApp.Log.T_Status__c != 'PROCESSADO_ERRO')
                {
                    // Fechar o log de interação com sucesso
                    this.logIntegracaoApp.FinalizarLogIntegracao('PROCESSADO_SUCESSO');
                }
                else
                {
                    this.logIntegracaoApp.FinalizarLogIntegracao(this.logIntegracaoApp.Log.T_Status__c);
                }
                if (!Test.isRunningTest())
                {
                    this.logIntegracaoApp.ExecutarDML();
                }
            }
        }
        if (!Test.isRunningTest()) {
            // Reagendar o processo para execução em 10 minutos
            T_SDK_DebugLog.EscreverLog('Reagendando schedule de implantação');
            T_SDK_ScheaduleUtils.scheadule('T_MODEC_SCH_EnviarAnexos', 10);
        }
    }
}