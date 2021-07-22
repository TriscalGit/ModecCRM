/**
 * @File Name          : T_SDK_LogIntegracaoApp.cls
 * @Description        : Classe que manipula todas as operações do log de integração
 * @Author             : Felipe Cardozo
 * @Group              :
 * @Last Modified By   : Felipe Cardozo
 * @Last Modified On   : 14/10/2019 21:22:50
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author                 Modification
 *==============================================================================
 * 1.0    21/08/2019 12:30:57   Felipe Cardozo     Initial Version
 **/
public class T_SDK_LogIntegracaoApp {
   public T_Log_de_integracao__c Log;
   private List<T_Detalhe_do_log__c> listaLogDetalhe = new List<T_Detalhe_do_log__c>();
   private List<AnexoLogIntegracao> Anexos           = new List<AnexoLogIntegracao>();

   public T_SDK_LogIntegracaoApp(string nomeLog)
   {
      T_SDK_DebugLog.EscreverLog('Iniciando log de integração');
      Log = new T_Log_de_integracao__c();
      Log.T_Nome_Integracao__c = nomeLog;
      Log.T_Data_de_inicio__c  = datetime.now();
      Log.T_Status__c          = 'EM_PROCESSO';

      try
      {
         ValidaInicializacaoLog(Log);
      }
      catch (Exception e)
      {
         T_SDK_DebugLog.EscreverLog('Erro ao validar inicialização de log de integração');
         T_SDK_DebugLog.EscreverLog('Detalhe do erro:');
         T_SDK_DebugLog.EscreverLog(e.getMessage());
         throw e;
      }
   }

   /**
    * @description Buscar o log de integração por ID
    * @author Felipe Cardozo | 21/08/2019
    * @param Id idLog Id do log a ser consultado
    * @return T_Log_de_integracao__c
    */
   public T_Log_de_integracao__c GetLogIntegracao(Id idLog)
   {
      T_Log_de_integracao__c logConsulta = [SELECT id, T_Nome_Integracao__c, T_Data_de_inicio__c, T_Data_fim__c, T_Status__c FROM T_Log_de_integracao__c WHERE id = :idLog];

      if (logConsulta == null)
      {
         throw new T_SDK_Exception('Log de integração não encontrado para o id ' + idLog);
      }

      Log = logConsulta;
      return Log;
   }

   /**
    * @description Método interno para validar o log de integração
    * @author Felipe Cardozo | 21/08/2019
    * @param T_Log_de_integracao__c logIntegracao
    * @return void
    */
   private void ValidaInicializacaoLog(T_Log_de_integracao__c logIntegracao)
   {
      if ((logIntegracao.T_Nome_Integracao__c == null) || (logIntegracao.T_Nome_Integracao__c == ''))
      {
         throw new T_SDK_Exception('Nome do log de integração não pode ser null ou em branco');
      }
   }

   public class AnexoLogIntegracao
   {
      public String nomeArquivo { get; set; }
      public String conteudo { get; set; }
   }

   /**
    * @description Dado que existe a necessidade de criar um anexo no Log de integração
    *              Então foi criado um método que insere o anexo no Log
    *              Deve ser validado se o Log de integracao não é null
    *              Deve ser validado o nome diferente de null ou branco
    *              Deve ser validado o conteúdo diferente de null ou branco
    * @author Felipe Cardozo | 21/08/2019
    * @param T_Log_de_integracao__c logIntegracao
    * @param string nomeArquivo
    * @param string conteudo
    * @return void
    */
   public void AnexarProcessoLog(string nomeArquivo, string conteudo)
   {
      T_SDK_DebugLog.EscreverLog('Log: ' + Log);
      T_SDK_DebugLog.EscreverLog('nomeArquivo: ' + nomeArquivo);
      T_SDK_DebugLog.EscreverLog('conteudo: ' + conteudo);
      T_SDK_DebugLog.EscreverLog('Lógica: ' + (Log == null || (nomeArquivo == null || nomeArquivo != '') || (conteudo == null || conteudo != '')));

      if ((Log == null) || ((nomeArquivo == null) || (nomeArquivo == '')) || ((conteudo == null) || (conteudo == '')))
      {
         return;
      }

      AnexoLogIntegracao anexo = new AnexoLogIntegracao();
      anexo.nomeArquivo = nomeArquivo;
      anexo.conteudo    = conteudo;
      Anexos.add(anexo);

      T_SDK_DebugLog.EscreverLog('Inserindo anexo File ' + anexo);
   }

   /**
    * @description Gravar anexos no Salesforce
    * @author Felipe Cardozo | 28/08/2019
    * @return void
    */
   private void PersistirAnexos()
   {
      if (Log.Id == null)
      {
         return;
      }

      for (AnexoLogIntegracao anexo : Anexos)
      {
         ContentVersion conVer = new ContentVersion();
         conVer.ContentLocation = 'S';                                        // S specify this document is in SF, use E for external files
         conVer.PathOnClient    = String.valueOf(anexo.nomeArquivo) + '.txt'; // The files name, extension is very important here which will help the file in preview.
         conVer.Title           = String.valueOf(anexo.nomeArquivo);          // Display name of the files
         conVer.VersionData     = Blob.valueOf(anexo.conteudo);               // converting your binary string to Blob
         insert conVer;

         T_SDK_DebugLog.EscreverLog('Criando file version ' + conVer);

         // First get the content document Id from ContentVersion
         Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;

         //Create ContentDocumentLink
         ContentDocumentLink cDe = new ContentDocumentLink();
         cDe.ContentDocumentId = conDoc;
         cDe.LinkedEntityId    = Log.Id; // you can use objectId,GroupId etc
         cDe.ShareType         = 'I';    // Inferred permission, checkout description of ContentDocumentLink object for more details
         cDe.Visibility        = 'AllUsers';
         insert cDe;
      }
   }

   /**
    * @description Dado que existe a necessidade de fechar o log de integração
    *              Então foi criado o método para receber o log de integração
    *              E preencher o valor de data de conclusão
    *              E preencher o status do log de integração
    * @author Felipe Cardozo | 21/08/2019
    * @param string status [EM_PROCESSO - PROCESSADO_ERRO - PROCESSADO_SUCESSO]
    * @return void
    */
   public void FinalizarLogIntegracao(string status)
   {
      Log.T_Data_fim__c = datetime.now();
      Log.T_Status__c   = status;
   }

   /**
    * @description  Dado que preciso atualizar o status do Log de integração
    *               E preenchi o Log e o status
    *               Então quando executar esse método o log deve ser salvo
    * @author Felipe Cardozo | 21/08/2019
    * @param T_Log_de_integracao__c logIntegracao
    * @param string status [EM_PROCESSO - PROCESSADO_ERRO - PROCESSADO_SUCESSO]
    * @return void
    */
   public void AtualizaStatusLogIntegracao(string status)
   {
      Log.T_Status__c = status;
      T_SDK_DebugLog.EscreverLog('Atualizando LOG ' + Log);
   }

   /**
    * @description Método responsável por incluir detalhe de erro no log de integração
    * @author Felipe Cardozo | 21/08/2019
    * @param T_Detalhe_do_log__c detalheLog
    * @return void
    */
   public void IncluirDetalheLogIntegracao(String descricao, String chaveExterna)
   {
      T_Detalhe_do_log__c detalheLog = new T_Detalhe_do_log__c();

      detalheLog.T_Descricao__c = descricao;
      detalheLog.T_Chave__c     = chaveExterna;
      listaLogDetalhe.add(detalheLog);
      T_SDK_DebugLog.EscreverLog('Incluindo detalhes do LOG ' + detalheLog);
   }

   /**
    * @description Método que executa a DML no log de integração e seus objetos relacionados
    * @author Felipe Cardozo | 28/08/2019
    * @return void
    */
   public T_Log_de_integracao__c ExecutarDML()
   {
      if (Log.id == null)
      {
         Insert Log;
      }

      for (T_Detalhe_do_log__c detalhe : listaLogDetalhe)
      {
         detalhe.Log_de_integra_o_M__c = Log.Id;
      }

      insert listaLogDetalhe;

      PersistirAnexos();
      return Log;
   }

   /**
    * @description Busca a última data e hora que o log de integração foi fechado com sucesso pelo nome do log
    * @author Felipe Cardozo | 04/09/2019
    * @param nomeLog Nome do log para ser consultado
    * @return DateTime
    **/
   public static DateTime GetUltimaDataHoraExecucaoComSucesso(String nomeLog)
   {
      T_Log_de_integracao__c logConsulta = [SELECT T_Data_de_inicio__c
                                            FROM T_Log_de_integracao__c
                                            WHERE
                                            T_Status__c = 'PROCESSADO_SUCESSO'
                                                          AND T_Nome_Integracao__c = :nomeLog
                                                                                     ORDER BY T_Data_de_inicio__c DESC];

      if (logConsulta == null)
      {
         return DateTime.now();
      }

      return logConsulta.T_Data_de_inicio__c;
   }
}