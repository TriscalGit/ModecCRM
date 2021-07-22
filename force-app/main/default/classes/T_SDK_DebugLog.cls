/**
 * @File Name          : T_SDK_DebugLog.cls
 * @Description        : SDK para armazenar o log de maneira correta, se a chave DEBUG_MODE
 * na customSettings estiver marcada
 * @Author             : Felipe Cardozo
 * @Group              :
 * @Last Modified By   : Felipe Cardozo
 * @Last Modified On   : 21/08/2019 16:12:02
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author                 Modification
 *==============================================================================
 * 1.0    05/08/2019 16:06:09   Felipe Cardozo     Initial Version
 **/
public class T_SDK_DebugLog {
   private static T_Debug_Setting__mdt DebugSettings { get; set; }

   /**
    * @description Método responsável por carregar a confuguração no MetaDado
    * @author Felipe Cardozo | 05/08/2019
    * @return void
    */
   public static void CarregarSettings()
   {
      if (Test.isRunningTest())
      {
         DebugSettings = T_SDK_DebugLog_Test.testSetting;
      }

      // Caso não já tenha sido preenchida, então busca
      if ((DebugSettings == null) && !Test.isRunningTest())
      {
         DebugSettings = [SELECT DeveloperName, T_Armazenar_Cause__c, T_Armazenar_linha_debug__c, T_Armazenar_StackTrace__c, T_Armazenar_texto_Exception__c FROM T_Debug_Setting__mdt LIMIT 1];
      }
   }

   /**
    * @description Método responsável por armazenar linha no log
    * @author Felipe Cardozo | 05/08/2019
    * @param string texto
    * @return void
    */
   public static void EscreverLog(string texto)
   {
      CarregarSettings();

      if (DebugSettings == null)
      {
         return;
      }

      if (DebugSettings.T_Armazenar_linha_debug__c)
      {
         system.debug('DEBUG: ' + texto);
      }
   }

   /**
    * @description Método responsável por armazenar Excetion no log
    * @author Felipe Cardozo | 05/08/2019
    * @param Exception e
    * @return void
    */
   public static void EscreverException(Exception e)
   {
      CarregarSettings();

      if (DebugSettings == null)
      {
         return;
      }

      if (DebugSettings.T_Armazenar_texto_Exception__c)
      {
         system.debug('Texto Excetion: ' + e.getMessage());
      }

      if (DebugSettings.T_Armazenar_StackTrace__c)
      {
         system.debug('StackTrace Exception: ' + e.getStackTraceString());
      }

      if (DebugSettings.T_Armazenar_Cause__c)
      {
         system.debug('Cause Exception: ' + e.getCause());
      }
   }

   /**
    * @description Montar texto em exception com Message - StackTrace - Cause
    * @author Felipe Cardozo | 21/08/2019
    * @param Exception e
    * @return String
    */
   public static String MontarTextoException(Exception e)
   {
      return 'Ocorreu um erro [Message: ' + e.getMessage() + ' StackTrace: ' + e.getStackTraceString() + ' Cause: ' + e.getCause();
   }
}