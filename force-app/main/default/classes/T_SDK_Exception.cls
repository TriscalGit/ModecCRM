/**
 * @File Name          : T_SDK_Exception.cls
 * @Description        :
 * @Author             : Felipe Cardozo
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 30/10/2019 12:15:29
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    02/10/2019   Felipe Cardozo     Initial Version
 * 1.1    02/10/2019   Felipe Cardozo     Criando método para criar AuraHandledException
 **/
public class T_SDK_Exception extends Exception {
   /**
    * @description Montar AuraHandledException baseada na exception recebida
    * @author Felipe Cardozo | 02/10/2019
    * @param e Exception para montar AuraHandledException
    * @return AuraHandledException
    **/
   public static AuraHandledException MontarAuraHandledException(Exception e)
   {
      String errorMessage = e.getMessage();

      if (errorMessage.contains('REQUIRED_FIELD_MISSING'))
      {
         List<String> textoMsgSplit = errorMessage.split(',');
         string       textostr      = 'Erro de campos obrigatório \n';
         for (integer i = 1; i < textoMsgSplit.size(); i++)
         {
            textostr += textoMsgSplit[i] + ',';
         }
         textostr = textostr.removeEnd(',');
         return new AuraHandledException(JSON.serialize(new ErroMessageDto('ERROR', textostr, 500)));
      }
      if (errorMessage.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))
      {
         return new AuraHandledException(JSON.serialize(new ErroMessageDto('ERROR', errorMessage.split(',')[1], 500)));
      }

      return new AuraHandledException(JSON.serialize(new ErroMessageDto('ERROR', 'Erro não tratado! >' + e.getMessage(), 500)));
   }

   public class ErroMessageDto
   {
      public String name;
      public String message;
      public Integer code;

      public ErroMessageDto(String name, String message, Integer code)
      {
         this.name    = name;
         this.message = message;
         this.code    = code;
      }
   }
}