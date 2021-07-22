/**
 * @File Name          : T_SDK_ValidateCNPJ.cls
 * @Description        : SDK to validate CNPJ.
 * @Author             : Rafael Hadama
 * @Group              : 
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 10/02/2020 13:10:41
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    29/01/2020   Rafael Hadama     Initial Version
**/
public class T_SDK_ValidateCNPJ {
   public static Boolean validaCNPJ(String cnpj)
   {
      return validaDigitosCNPJ(cnpj.trim());
   }

   public static boolean validaDigitosCNPJ(String CNPJ)
   {
      // considera-se erro CNPJ's formados por uma sequencia de numeros iguais
      CNPJ = CNPJ.replace('.', '').replace('/', '').replace('-', '').replace(' ', '');

      if (CNPJ.equals('00000000000000') || CNPJ.equals('11111111111111') ||
          CNPJ.equals('22222222222222') || CNPJ.equals('33333333333333') ||
          CNPJ.equals('44444444444444') || CNPJ.equals('55555555555555') ||
          CNPJ.equals('66666666666666') || CNPJ.equals('77777777777777') ||
          CNPJ.equals('88888888888888') || CNPJ.equals('99999999999999') ||
          (CNPJ.length() != 14))
      {
         return false;
      }

      Integer      sm, i, r, num, peso, dig13, dig14;
      List<String> cnpjString = CNPJ.split('');
      sm   = 0;
      peso = 2;
      for (i = 11; i >= 0; i--)
      {
         num  = Integer.valueOf(cnpjString[i]);
         sm   = sm + (num * peso);
         peso = peso + 1;
         if (peso == 10)
         {
            peso = 2;
         }
      }

      r = math.mod(sm, 11);
      if ((r == 0) || (r == 1))
      {
         dig13 = 0;
      }
      else
      {
         dig13 = Integer.valueOf(11 - r);
      }

      // Calculo do 2o. Digito Verificador
      sm   = 0;
      peso = 2;
      for (i = 12; i >= 0; i--)
      {
         num  = Integer.valueOf(cnpjString[i]);
         sm   = sm + (num * peso);
         peso = peso + 1;
         if (peso == 10)
         {
            peso = 2;
         }
      }

      r = math.mod(sm, 11);
      if ((r == 0) || (r == 1))
      {
         dig14 = 0;
      }
      else
      {
         dig14 = Integer.valueOf(11 - r);
      }

      // Verifica se os dígitos calculados conferem com os dígitos informados.
      if ((dig13 == Integer.valueOf(cnpjString[12])) && (dig14 == Integer.valueOf(cnpjString[13])))
      {
         return true;
      }
      else
      {
         return false;
      }
   }
}