/**
 * @File Name          : T_MODEC_InspecItem_REP.cls
 * @Description        :
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 29/06/2020 22:09:24
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    29/06/2020   Rafael Hadama     Initial Version
 **/
public class T_MODEC_InspecItem_REP {
    public list<TW1_Inspection_Item__c> getInspectionItensbyRequestId(string RequestId)
    {
        list<TW1_Inspection_Item__c> listInspectionItens = [SELECT Id, Name, TW1_Inspection_Appraisal__c, TW1_Quantity__c, TW1_Tag_or_Certificate_Number__c, TW1_Heat_Number__c, TW1_Item_Description__c, TW1_Rejection_Reason__c, TW1_Status__c, TW1_Request__c FROM TW1_Inspection_Item__c where TW1_Request__c =:RequestId ORDER by CreatedDate];

        return listInspectionItens;
    }
}