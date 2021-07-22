/**
 * @File Name          : T_MODEC_CustomSettingsRep.cls
 * @Description        : 
 * @Author             : Rafael Hadama
 * @Group              : 
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 10/02/2020 13:13:45
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    28/01/2020   Rafael Hadama     Initial Version
**/
public class T_MODEC_CustomSettingsRep {

    public TW1_End_Fiscal_Period__c GetFiscalPeriodDates(){

        TW1_End_Fiscal_Period__c CustomFiscalPeriodDates = [SELECT Id, Name, TW1_JAN_INI__c, TW1_FEB_INI__c, TW1_MAR_INI__c, TW1_APR_INI__c, TW1_MAY_INI__c, TW1_JUN_INI__c, TW1_JUL_INI__c, TW1_AUG_INI__c, TW1_SEP_INI__c, TW1_OCT_INI__c, TW1_NOV_INI__c, TW1_DEC_INI__c, TW1_JAN_END__c, TW1_FEB_END__c, TW1_MAR_END__c, TW1_APR_END__c, TW1_MAY_END__c, TW1_JUN_END__c, TW1_JUL_END__c, TW1_AUG_END__c, TW1_SEP_END__c, TW1_OCT_END__c, TW1_NOV_END__c, TW1_DEC_END__c FROM TW1_End_Fiscal_Period__c];

        return CustomFiscalPeriodDates;

    }
    
}