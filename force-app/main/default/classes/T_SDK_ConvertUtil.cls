/**
 * @File Name          : T_SDK_ConvertUtil.cls
 * @Description        :
 * @Author             : Felipe Cardozo
 * @Group              :
 * @Last Modified By   : Felipe Cardozo
 * @Last Modified On   : 03/09/2019 17:31:36
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    03/09/2019   Felipe Cardozo     Initial Version
 **/
public class T_SDK_ConvertUtil {
   /**
   * @description Converte string para Long
   * @author Felipe Cardozo | 03/09/2019 
   * @param value valor a ser convertido
   * @return Long número convertido
   **/
   public static Long ConverteStringToLong(String value)
   {
      if (value == null)
      {
         return null;
      }

      try {
         return Long.valueOf(value);
      }
      catch (Exception e) {
         T_SDK_DebugLog.EscreverLog('Erro em converter string para  LONG: ' + value);
         throw new T_SDK_Exception('Erro em converter string para  LONG: ' + value);
      }
   }
}