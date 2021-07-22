/**
 * @File Name          : T_MODEC_ChangeLanguageTST.cls
 * @Description        : 
 * @Author             : Rafael Hadama
 * @Group              : 
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 10/02/2020 13:11:49
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    06/02/2020   Rafael Hadama     Initial Version
**/
@IsTest
public class T_MODEC_ChangeLanguageTST {
    
    @isTest public static void changeLangTST(){
        Test.startTest();
        string retorno = T_MODEC_ChangeLanguageCTRL.changeLang('pt_BR');
        Test.stopTest();
        system.assertEquals('OK', retorno);
        system.assertEquals('pt_BR', UserInfo.getLanguage());
    }
    
    @isTest public static void GetUserLanguageTST(){
        Test.startTest();
        string retorno = T_MODEC_ChangeLanguageCTRL.changeLang('pt_BR');
        string retornoTeste = T_MODEC_ChangeLanguageCTRL.GetUserLanguage();
        Test.stopTest();

        system.assertEquals('pt_BR', retornoTeste);
    }
}