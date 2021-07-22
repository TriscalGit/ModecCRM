/**
 * @File Name          : T_MODEC_ChangeLanguageCTRL.cls
 * @Description        :
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 10/02/2020 13:12:04
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    06/02/2020   Rafael Hadama     Initial Version
 **/
public class T_MODEC_ChangeLanguageCTRL {
   @AuraEnabled
   public static string changeLang(String lang)
   {
      String currentuserId   = UserInfo.getUserId();
      User   currentUserInfo = [select LanguageLocaleKey from User where Id = :UserInfo.getUserId()];

      currentUserInfo.LanguageLocaleKey = lang;
      update currentUserInfo;
      return 'OK';
   }

   @AuraEnabled
   public static string GetUserLanguage()
   {
      String currentuserId = UserInfo.getUserId();

      try{
         User currentUserInfo = [select LanguageLocaleKey from User where Id = :UserInfo.getUserId()];

         return currentUserInfo.LanguageLocaleKey;
      }
      catch (Exception e) {
          AuraHandledException auraEx = T_SDK_Exception.MontarAuraHandledException(e);
         throw auraEx;
      }
   }
}