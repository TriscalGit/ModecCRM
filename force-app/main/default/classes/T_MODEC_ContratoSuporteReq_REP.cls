/**
 * @File Name          : T_MODEC_ContratoSuporteReq_CTRL.cls
 * @Description        : 
 * @Author             : Mario Oliveira
 * @Group              : 
 * @Last Modified By   : Mario Oliveira
 * @Last Modified On   : 04/12/2019 11:19:38
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    01/11/2019   Mario Oliveira     Initial Version
**/
public with sharing class T_MODEC_ContratoSuporteReq_REP {
    /*
     *  Metodo "buscarElemento" faz a query que busca os registros
     *  dos campos do objeto "TW1_MODEC_Contract__c"
     */
     
    public static TW1_MODEC_Contract__c buscarElemento(string idElem) {
        
        TW1_MODEC_Contract__c elem = [
            SELECT
            Name,
            TW1_SAP_Outline_Agreement_Number__c,
            TW1_Type_of_Contract__c,
            TW1_Requestor_Sponsor__c,
            TW1_Job_Title__c,
            TW1_Date__c,
            TW1_Vendor__c,
            TW1_Vendor__r.Name,
            TW1_Vendor__r.TW1_SAP_Code__c,
            TW1_Vendor_CNPJ__c,
            TW1_Vendor_Vetting__c,
            TW1_Main_Contact__c,
            TW1_Party_Email__c,
            TW1_BID__c,
            TW1_Justification__c,
            TW1_Contempled_in_this_Agreement__c, //NewField - 03/12/2019
            TW1_Termination_Conditions_Penalty__c,
            TW1_Previous_Contract_Amount_A__c,
            TW1_Accumulated_Contract_Amout__c,
            TW1_Contracted_Value_B__c,
            TW1_Increase__c,
            TW1_Annual_Estimate__c,
            CurrencyIsoCode,
            TW1_Monthly_If_Fixed__c,
            TW1_Escalation__c,
            TW1_Duration__c,
            TW1_Payment_Term__c,
            TW1_Start_Date__c,
            TW1_End_Date__c,
            TW1_Payment_Conditions__c,
            TW1_PO_Number__c,
            TW1_Budgeted_2019__c,
            TW1_Budgeted_Justification__c,
            TW1_Cost_Center__c,
            TW1_WBS_Number__c,
            TW1_Department_Code__c,
            TW1_Cost_Controller__c
            FROM
            TW1_MODEC_Contract__c
            WHERE
            id =: idElem
        ];

        return elem;
    }

    public static List<TW1_MODEC_Contract__c> buscarContratosExpirados() {

        List<TW1_MODEC_Contract__c> conts = [
            SELECT
            Id,
            TW1_Status__c,
            TW1_End_Date__c
            FROM
            TW1_MODEC_Contract__c
            WHERE
            TW1_Status__c = 'Active'
            AND
            TW1_End_Date__c < TODAY
        ];

        return conts;

    }
}