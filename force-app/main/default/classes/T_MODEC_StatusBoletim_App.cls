/**
 * @File Name          : T_MODEC_StatusBoletim_App.cls
 * @Description        : Classe application responsável por atualizar os status dos boletins e preparar o Response do serviço.
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 15/05/2020 20:03:13
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    08/11/2019   Rafael Hadama     Initial Version
 **/
public class T_MODEC_StatusBoletim_App {
   public T_SDK_LogIntegracaoApp logIntegracaoApp;


   public static list<T_MODEC_StatusBoletim_WS.ItemResponse> atualizarStatusBoletins(T_MODEC_StatusBoletim_WS.StatusRequest listStatusBoletins)
   {
      //Criando consulta ao REP de Requests
      T_MODEC_Request_Rep boletimREP = new T_MODEC_Request_Rep();
      //Criando lista de ids para consulta e map para controle da atualização.
      List<String> listBoletinsIds = new List<string>();
      //Map de controle, onde ficará o numero da folha sap e seu status vindo do SAP
      Map<String, String> mapBoletimNumFolhaSAP_Status = new map<string, string>();
      //Map de para auxiliar a criação dos ItemResponse, key - id do boletim (Salesforce) e value numero da folha sap.
      Map<String, String> mapRequestId_NumFolhaSAP = new map<string, string>();
      //Criando lista para receber itens de response
      list<T_MODEC_StatusBoletim_WS.ItemResponse> listResponse = new list<T_MODEC_StatusBoletim_WS.ItemResponse>();
      //Criando Log de integração
      T_SDK_LogIntegracaoApp logIntegracaoApp = new T_SDK_LogIntegracaoApp('StatusBoletim_Log');

      T_SDK_DebugLog.EscreverLog('Iniciando Log de integração');
      logIntegracaoApp.Log.T_Request__c  = 'Ver em anexo';
      logIntegracaoApp.Log.T_Response__c = 'Ver em anexo';
      //Anexando request recebido no Log
      logIntegracaoApp.AnexarProcessoLog('Request Status Boletim ', JSON.serialize(listStatusBoletins));

      try{
         //Itemrequest.STATUS : 1-Accepted : 2-Not Accepted : 3- Canceled
         //Campo no banco :> Objeto TW1_Request__c : campo BM_Status__c
         //Mapeamento dos valores: 1-Accepted = 'Aceita'; 2-Not Accepted = 'Rejeitada'; 3- Canceled = 'Cancelada'
         for (T_MODEC_StatusBoletim_WS.Itemrequest item : listStatusBoletins.item)
         {
            //Adicionando ids recebidos para realizar Query

            string statusBM = '';
            switch on item.STATUS {
               when '1' {
                  statusBM = 'Aceita';
               }
               when '2' {
                  statusBM = 'Aguardando';
               }
               when '3' {
                  statusBM = 'Cancelada';
               }
            }
            if (statusBM != '')
            {
               listBoletinsIds.add(item.ENTRYSHEET);
            }
            mapBoletimNumFolhaSAP_Status.put(item.ENTRYSHEET, statusBM);
         }
         T_SDK_DebugLog.EscreverLog('Lista para query: ' + listBoletinsIds);
         T_SDK_DebugLog.EscreverLog('Map de entrysheet e status montado , realizando query nos boletins.');
         //Realizando query nos boletins, retornando um map<NumeroBM,Sobject Request>
         map<String, TW1_Request__c> mapBoletins = boletimREP.getRequestByListIds(listBoletinsIds);
         //Lista para guardar erros de DML
         List<string> errosDML = new list<string>();
         //Caso o map
         if (!mapBoletins.isEmpty())
         {
            T_SDK_DebugLog.EscreverLog('Tamanho do map com boletins: ' + mapBoletins.keyset().size());
            //Iterando pelos boletins através do numero de bm(SAP) e atualizando o campo BM_Status__c.
            for (string numFolhaSAP : mapBoletins.keyset())
            {
               TW1_Request__c boletim = mapBoletins.get(numFolhaSAP);
               //T_SDK_DebugLog.EscreverLog('Id do BM salesforce: ' + boletim.Id);
               boletim.BM_Status__c = mapBoletimNumFolhaSAP_Status.get(numFolhaSAP);
               //Adicionando o boletim atualizado ao Map que será utilizado para a DML
               mapBoletins.put(numFolhaSAP, boletim);
               //Preenchendo map para consulta dentro do for do Database.SaveResult
               mapRequestId_NumFolhaSAP.put(boletim.id, numFolhaSAP);
            }
            T_SDK_DebugLog.EscreverLog('Map de update e auxiliar montado.');
            //? como validar se todo boletim recebido foi validado?, talvez ir buscando no map e removendo logo após
            //Caso o map ainda possua valores, significa que os boletins com aquele entrysheet não foram encontrados dentro do salesforce.
            try{
               system.debug('Antes de realizar update queries>' + Limits.getQueries());
               system.debug('Antes getCpuTime>' + Limits.getCpuTime());
               Controle_de_Triggers__c customControleTrigger = Controle_de_Triggers__c.getInstance();
               system.debug('customControleTrigger' + customControleTrigger.Trigger_Request__c);
               customControleTrigger.Trigger_Request__c = false;
               system.debug('customControleTrigger false' + customControleTrigger.Trigger_Request__c);
               //Fazendo dml com database e gerando itens de response para integração
               List<TW1_Request__c> listUpdate = mapBoletins.values();
               //updating triggerfactory variable to bulk the trigger context
               //TriggerFactory.triggerIsBulk = true;
               //Validate that the T_MODEC_Request_App.validarSupplierEmail does not run
               TriggerFactory.validateRequesterEmail = false;
               TriggerFactory.stopRequestTrigger     = false;

               system.debug('Queries antes de realizar update em BMs>' + Limits.getQueries());
               system.debug('CpuTime antes dml em Bms>' + Limits.getCpuTime());

               Database.SaveResult[] srList = Database.update(listUpdate, false);
               system.debug('CpuTime APOS dml em Bms>' + Limits.getCpuTime());
               T_SDK_DebugLog.EscreverLog('srList :' + srList);
               for (Integer i = 0; i < listUpdate.size(); i++)
               {
                  //system.debug('CpuTime durante for final de retorno>' + Limits.getCpuTime());
                  Database.SaveResult resultDml  = srList[i];
                  TW1_Request__c      origRecord = listUpdate[i];
                  //T_SDK_DebugLog.EscreverLog('SaveResult :' + resultDml);
                  //T_SDK_DebugLog.EscreverLog('TW1_Request__c :' + origRecord);
                  if (resultDml.isSuccess())
                  {
                     //T_SDK_DebugLog.EscreverLog('Boletim atualizado: ' + resultDml.getId());
                     //Montando item response para retorno da integração.
                     T_MODEC_StatusBoletim_WS.ItemResponse ItemResp = new T_MODEC_StatusBoletim_WS.ItemResponse();
                     //T_SDK_DebugLog.EscreverLog('Id do boletim: ' + resultDml.getId());
                     //T_SDK_DebugLog.EscreverLog('Entrysheet value: ' + mapRequestId_NumFolhaSAP.get(resultDml.getId()));
                     ItemResp.PROCESSADO = 'x';
                     ItemResp.ENTRYSHEET = mapRequestId_NumFolhaSAP.get(resultDml.getId());
                     listResponse.add(ItemResp);
                     //Removendo item do map para verificação futura
                     mapBoletimNumFolhaSAP_Status.remove(mapRequestId_NumFolhaSAP.get(resultDml.getId()));
                  }
                  else
                  {
                     // Operation failed, so get all errors
                     //T_SDK_DebugLog.EscreverLog('Erro ao atualizar boletim :' + sr.getStatusCode());
                     //Montando item response para retorno da integração.
                     //O valor 'PROCESSADO' é retornado vazio para indicar que o boletim não foi atualizado

                     /*T_SDK_DebugLog.EscreverLog('Id do boletim: ' + sr.getId());
                      * T_SDK_DebugLog.EscreverLog('Entrysheet value: ' + mapRequestId_NumFolhaSAP.get(sr.getId()));
                      * T_MODEC_StatusBoletim_WS.ItemResponse ItemResp = new T_MODEC_StatusBoletim_WS.ItemResponse();
                      * ItemResp.PROCESSADO = '';
                      * ItemResp.ENTRYSHEET = mapRequestId_NumFolhaSAP.get(sr.getId());
                      *
                      * //Validando caso não tenha sucesso na atualização, não devo adiciona-lo na lista response
                      * //e logo não remove-lo do map.
                      *
                      * listResponse.add(ItemResp);
                      * //Removendo item do map para verificação futura
                      * mapBoletimNumFolhaSAP_Status.remove(mapRequestId_NumFolhaSAP.get(sr.getId()));*/
                     for (Database.Error err : resultDml.getErrors())
                     {
                        T_SDK_DebugLog.EscreverLog('Erro> :' + err);
                        //T_SDK_DebugLog.EscreverLog('Erro ao atualizar Boletim com Id :' + origRecord.id + ' Detalhe > ' + err.getStatusCode() + ': ' + err.getMessage());
                        //T_SDK_DebugLog.EscreverLog('Campos da fidelidade que causaram este erro: ' + err.getFields());
                        string erro = 'Erro ao atualizar Boletim com Id :' + origRecord.id + ' Name: ' + origRecord.Name + ' Detalhe > ' + err.getStatusCode() + ': ' + err.getMessage();
                        errosDML.add(erro);
                     }
                  }
               }
            }
            catch (Exception e) {
               system.debug('Entrou on catch statusboletim app');
               logIntegracaoApp.AnexarProcessoLog('ErroStatusBoletim', T_SDK_DebugLog.MontarTextoException(e));
               logIntegracaoApp.AtualizaStatusLogIntegracao('PROCESSADO_ERRO');
            }
         }
         //Validando que todos as folhas recebidas foram encontradas no salesforce
         //Caso não, retorno que não foi processado.
         if (!mapBoletimNumFolhaSAP_Status.isEmpty())
         {
            T_SDK_DebugLog.EscreverLog('Tamanho do map apos remove: ' + mapBoletimNumFolhaSAP_Status.keyset().size());
            for (string numFolhaSAP : mapBoletimNumFolhaSAP_Status.keyset())
            {
               T_SDK_DebugLog.EscreverLog('numFolhaSAP :' + numFolhaSAP);
               T_MODEC_StatusBoletim_WS.ItemResponse ItemResp = new T_MODEC_StatusBoletim_WS.ItemResponse();
               ItemResp.PROCESSADO = '';
               ItemResp.ENTRYSHEET = numFolhaSAP;
               listResponse.add(ItemResp);
            }
         }
         //Anexando response no LOG
         logIntegracaoApp.AnexarProcessoLog('Response Status Boletim ', JSON.serialize(listResponse));
         if (errosDML.size() > 0)
         {
            logIntegracaoApp.AnexarProcessoLog('Erros de atualização', JSON.serialize(errosDML));
         }
         if (logIntegracaoApp.Log.T_Status__c != 'PROCESSADO_ERRO')
         {
            // Fechar o log de interação com sucesso
            logIntegracaoApp.FinalizarLogIntegracao('PROCESSADO_SUCESSO');
         }
      }
      catch (Exception e) {
         logIntegracaoApp.AnexarProcessoLog('ErroStatusBoletim', T_SDK_DebugLog.MontarTextoException(e));
         logIntegracaoApp.AtualizaStatusLogIntegracao('PROCESSADO_ERRO');
      }
      finally{
         system.debug('Antes de realizar DML em log>' + Limits.getQueries());
         system.debug('após getLimitCpuTime>' + Limits.getLimitCpuTime());
         system.debug('após getCpuTime>' + Limits.getCpuTime());
         logIntegracaoApp.Log.T_Data_fim__c = Datetime.now();
         logIntegracaoApp.ExecutarDML();
      }


      return listResponse;
   }
}