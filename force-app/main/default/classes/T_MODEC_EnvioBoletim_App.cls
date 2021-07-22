/**
 * @File Name          : T_MODEC_EnvioBoletim_App.cls
 * @Description        : Classe application relativa a integração do SAP / para criação do Boletim de medição
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    04/11/2019   Rafael Hadama     Initial Version
 **/
public class T_MODEC_EnvioBoletim_App {
   public T_SDK_LogIntegracaoApp logIntegracaoApp;

   public T_MODEC_SendBMRequest_Ctrl.createBM_SAPresponse enviarBoletimMedicao(string requestId)
   {
      T_SDK_DebugLog.EscreverLog('Iniciando processo de enviar boletim ao SAP');
      T_SDK_DebugLog.EscreverLog('Iniciando service agent de enviar boletim ao SAP');
      T_MODEC_SAP_EnvioBoletim enviarBoletimSAPServiceAgent = new T_MODEC_SAP_EnvioBoletim();

      T_SDK_DebugLog.EscreverLog('Iniciando service agent de enviar boletim ao SAP');
      T_MODEC_Request_Rep requestREP = new T_MODEC_Request_Rep();

      T_SDK_DebugLog.EscreverLog('Criando variavel de retorno ao fornecedor.');
      T_MODEC_SendBMRequest_Ctrl.createBM_SAPresponse retornoFornecedor = new T_MODEC_SendBMRequest_Ctrl.createBM_SAPresponse();
      retornoFornecedor.messages_SAP = new list<string>();
      // Buscar dados do boletim e linhas de item
      T_SDK_DebugLog.EscreverLog('Buscando Request(BM) e linhas de BM relacionadas');
      TW1_Request__c boletimMedicao = requestREP.getRequestById(requestId);
      T_SDK_DebugLog.EscreverLog('Boletim de medicao encontrado: ' + boletimMedicao);

      // Caso não haja boletim de medição
      if (boletimMedicao == null)
      {
         T_SDK_DebugLog.EscreverLog('Boletim de medição não encontrado no Salesforce.');
      }

      if (this.logIntegracaoApp == null)
      {
         T_SDK_DebugLog.EscreverLog('Iniciando Log de integração');
         this.logIntegracaoApp = new T_SDK_LogIntegracaoApp('EnviarBoletim_Log');
         this.logIntegracaoApp.Log.T_Request__c  = boletimMedicao.Name;
         this.logIntegracaoApp.Log.T_Response__c = 'Ver em anexo';
      }
      // #Caso tenha
      try
      {
         // realizar mapeamento para Dto
         T_SDK_DebugLog.EscreverLog('Realizando MAP do boletim a ser enviado');
         //List<T_BER_WBC_IntegrarOppRequest> listaEnvio = ConverterOportunidadeParaOportunidadeWBC(mapOportunidadesASeremImplantadas);
         T_MODEC_SAP_EnvioBoletim.boletimDto boletimDtoSAP = MapBoletimtoSAP(boletimMedicao);
         T_SDK_DebugLog.EscreverLog('MAP realizado com sucesso: ' + boletimDtoSAP);

         T_SDK_DebugLog.EscreverLog('Json do boletim: ' + JSON.serialize(boletimDtoSAP));

         //T_MODEC_SAP_EnvioBoletim.MT_MeasurementCreate_Reponse response = new T_MODEC_SAP_EnvioBoletim.MT_MeasurementCreate_Reponse();
         HTTPResponse response = new HTTPResponse();
         try
         {
            T_SDK_DebugLog.EscreverLog('Anexando request ao log de integração');
            // Salvando JSON de request
            this.logIntegracaoApp.AnexarProcessoLog('request boletim ' + boletimDtoSAP.PO_NUM, JSON.serialize(boletimDtoSAP));

            // Enviar lista de oportundiades para o serviço
            T_SDK_DebugLog.EscreverLog('Enviando boletim ao serviço');
            response = enviarBoletimSAPServiceAgent.PostEnviarBoletim(boletimDtoSAP);
            T_SDK_DebugLog.EscreverLog('Retorno do serviço: ' + response);

            /*T_SDK_DebugLog.EscreverLog('response.MT_MeasurementCreate_Reponse: ' + response.MT_MeasurementCreate_Reponse);
             * T_SDK_DebugLog.EscreverLog('response.MT_MeasurementCreate_Reponse.ENTRYSHEET: ' + response.MT_MeasurementCreate_Reponse.ENTRYSHEET);
             * T_SDK_DebugLog.EscreverLog('response.MT_MeasurementCreate_Reponse.T_RETURN: ' + response.MT_MeasurementCreate_Reponse.T_RETURN);
             * T_SDK_DebugLog.EscreverLog('response.MT_MeasurementCreate_Reponse.T_RETURN.item: ' + response.MT_MeasurementCreate_Reponse.T_RETURN.item);
             * T_SDK_DebugLog.EscreverLog('response.MT_MeasurementCreate_Reponse.T_RETURN.item.STATUS: ' + response.MT_MeasurementCreate_Reponse.T_RETURN.item.STATUS);
             * T_SDK_DebugLog.EscreverLog('response.MT_MeasurementCreate_Reponse.T_RETURN.item.MESSAGE: ' + response.MT_MeasurementCreate_Reponse.T_RETURN.item.MESSAGE);*/

            // Salvar retorno do serviço como anexo no JSON
            T_SDK_DebugLog.EscreverLog('Anexando response ao log de integração');
            this.logIntegracaoApp.AnexarProcessoLog('Response boletim ' + boletimDtoSAP.PO_NUM, JSON.serialize(response.getBody()));
            this.logIntegracaoApp.Log.T_Response__c = response.getBody();
         }
         catch (Exception e)
         {
            this.logIntegracaoApp.AnexarProcessoLog('ErroEnviarBoletim' + boletimDtoSAP.PO_NUM, T_SDK_DebugLog.MontarTextoException(e));
            this.logIntegracaoApp.AtualizaStatusLogIntegracao('PROCESSADO_ERRO');
         }


         //Atualizando Boletim com response do serviço SAP.
         if (response.getStatusCode() == 200)
         {
            T_SDK_DebugLog.EscreverLog('Atualizando boletim como Response : ');
            T_MODEC_SAP_EnvioBoletim.MT_MeasurementCreate_Reponse respDTO = (T_MODEC_SAP_EnvioBoletim.MT_MeasurementCreate_Reponse)JSON.deserialize(response.getBody(), T_MODEC_SAP_EnvioBoletim.MT_MeasurementCreate_Reponse.class);
            T_SDK_DebugLog.EscreverLog('ResponseDTO: ' + respDTO);
            boletimMedicao.TW1_BM_Reference_Number_in_SAP_MODEC__c = respDTO.MT_MeasurementCreate_Reponse.ENTRYSHEET;
            boletimMedicao.TW1_SAP_BM_Message__c = respDTO.MT_MeasurementCreate_Reponse.T_RETURN.item.MESSAGE;


            if (respDTO.MT_MeasurementCreate_Reponse.T_RETURN.item.STATUS == 'S')
            {
               boletimMedicao.BM_Status__c = 'Aguardando';
               boletimMedicao.TW1_BM_Creation_Date_in_SAP__c = datetime.now();
            }
            if (respDTO.MT_MeasurementCreate_Reponse.T_RETURN.item.STATUS == 'E')
            {
               boletimMedicao.BM_Status__c = 'Não enviado';
            }



            // Atualizando o boletim
            T_SDK_DebugLog.EscreverLog('Atualizando boletim com número recebido:' + boletimMedicao.TW1_BM_Reference_Number_in_SAP_MODEC__c);
            update boletimMedicao;

            retornoFornecedor.status_SAP = respDTO.MT_MeasurementCreate_Reponse.T_RETURN.item.STATUS;
            retornoFornecedor.messages_SAP.add(respDTO.MT_MeasurementCreate_Reponse.T_RETURN.item.MESSAGE);

            return retornoFornecedor;
         }
         else
         {
            this.logIntegracaoApp.FinalizarLogIntegracao('PROCESSADO_ERRO');

            /*T_MODEC_SAP_EnvioBoletim.MT_MeasurementCreate_Reponse respDTO = (T_MODEC_SAP_EnvioBoletim.MT_MeasurementCreate_Reponse)JSON.deserialize(response.getBody(), T_MODEC_SAP_EnvioBoletim.MT_MeasurementCreate_Reponse.class);
             * boletimMedicao.TW1_SAP_BM_Message__c = respDTO.MT_MeasurementCreate_Reponse.T_RETURN.item.MESSAGE;
             * // Atualizando o boletim
             * T_SDK_DebugLog.EscreverLog('Atualizando boletim com a msg do sap:');
             * update boletimMedicao;  */
            retornoFornecedor.status_SAP = 'E';
            retornoFornecedor.messages_SAP.add(response.getBody());
            return retornoFornecedor;
         }
      }
      catch (Exception e)
      {
         T_SDK_DebugLog.EscreverLog('Exception message: ' + e.getMessage());
         T_SDK_DebugLog.EscreverLog('Exception stacktrace: ' + e.getStackTraceString());
         // Caso ocorra erro em enviar o boletim, então deve fechar o log com erro e salvar o texto de exception no log de integração
         this.logIntegracaoApp.AnexarProcessoLog('ErroProcesso', T_SDK_DebugLog.MontarTextoException(e));
         T_SDK_DebugLog.EscreverException(e);

         this.logIntegracaoApp.Log.T_Data_fim__c = Datetime.now();
         this.logIntegracaoApp.FinalizarLogIntegracao('PROCESSADO_ERRO');
         this.logIntegracaoApp.Log.T_Data_fim__c = Datetime.now();
         retornoFornecedor.status_SAP            = 'E';
         retornoFornecedor.messages_SAP.add(e.getMessage());
         return retornoFornecedor;
         //logIntegracaoApp.ExecutarDML();
      }
      finally{
         if (this.logIntegracaoApp.Log.T_Status__c != 'PROCESSADO_ERRO')
         {
            // Fechar o log de interação com sucesso
            logIntegracaoApp.FinalizarLogIntegracao('PROCESSADO_SUCESSO');
         }

         this.logIntegracaoApp.Log.T_Data_fim__c = Datetime.now();
         logIntegracaoApp.ExecutarDML();
      }
   }

   public T_MODEC_SAP_EnvioBoletim.boletimDto MapBoletimtoSAP(TW1_Request__c request)
   {
      T_MODEC_SAP_EnvioBoletim.boletimDto boletimSAP = new T_MODEC_SAP_EnvioBoletim.boletimDto();
      T_MODEC_BMItem_REP BM_ItemREP = new T_MODEC_BMItem_REP();

      /*if(request.TW1_PO__c != null){
       * boletimSAP.PO_NUM = request.TW1_PO__c;}
       * else{
       * boletimSAP.PO_NUM = null;
       * }*/
      boletimSAP.PO_NUM = request.TW1_PO__c;
      boletimSAP.PI_NUM = request.TW1_Purchase_Item__c;

      boletimSAP.BM = request.TW1_Supplier_Reference_Number_for_BM__c;

      boletimSAP.DT_BEGIN     = formatDate(request.TW1_Service_Start_Date__c);
      boletimSAP.DT_END       = formatDate(request.TW1_Service_End_Date__c);
      boletimSAP.EMAIL_VENDOR = request.TW1_Supplier_Email__c;
      boletimSAP.EMAIL_REQ    = request.TW1_Modec_Requester_Email__c;
      boletimSAP.CNPJ         = request.TW1_CNPJ_CPF__c;
      if (request.TW1_Final_Measurement__c == 'Yes')
      {
         boletimSAP.FINAl_BM = 'X';
      }
      else
      {
         boletimSAP.FINAl_BM = '';
      }
      //boletimSAP.FINAl_BM = request.TW1_Final_Measurement__c;
      boletimSAP.SERVICE_TXT = request.TW1_Service_Description__c;

      T_MODEC_SAP_EnvioBoletim.linhasItem linhas = new T_MODEC_SAP_EnvioBoletim.linhasItem();
      linhas.item = new list<T_MODEC_SAP_EnvioBoletim.linha>();
      T_SDK_DebugLog.EscreverLog('Querying Bm Itens of the Request');
      list<BM_Item__c> listBMItens = BM_ItemREP.getRequestBMStatus(request.Id);

      T_SDK_DebugLog.EscreverLog('listBMItens: ' + listBMItens.size());
      //Mapeando e adicionando linhas de item no dto
      for (BM_Item__c bmItem: listBMItens)
      {
         T_MODEC_SAP_EnvioBoletim.linha linhaBM = new T_MODEC_SAP_EnvioBoletim.linha();
         linhaBM.SRV_NUM   = bmItem.TW1_Service_Line__c;
         linhaBM.SRV_VALUE = bmItem.TW1_Gross_Value__c;
         linhaBM.SRV_QUANT = bmItem.T_Quantity__c;

         linhas.item.add(linhaBM);
      }

      //Adicionando linhas do item no boletim a ser enviado ao sap.
      boletimSAP.T_SERVICE = linhas;

      return boletimSAP;
   }

   public string formatDate(date dataBM)
   {
      if (dataBM == null)
      {
         return '';
      }
      //Padrão que o SAP espera, 8 caracteres - AAAAMMDD
      //Função do salesforce retorna somente um caractere quando o dia é 1-9, ou mes 1-9
      string anoFormatado = string.valueOf(dataBM.year());
      string mesFormatado = string.valueOf(dataBM.month());
      string diaFormatado = string.valueOf(dataBM.day());

      if (mesFormatado.length() == 1)
      {
         mesFormatado = '0' + mesFormatado;
      }
      if (diaFormatado.length() == 1)
      {
         diaFormatado = '0' + diaFormatado;
      }

      string retorno = anoFormatado + mesFormatado + diaFormatado;
      T_SDK_DebugLog.EscreverLog('Data formatada: ' + retorno);
      return retorno;
   }
}