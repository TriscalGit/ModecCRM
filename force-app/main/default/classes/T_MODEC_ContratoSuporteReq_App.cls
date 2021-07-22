/**
 * @File Name          : T_MODEC_ContratoSuporteReq_App.cls
 * @Description        : 
 * @Author             : Mario Oliveira
 * @Group              : 
 * @Last Modified By   : Mario Oliveira
 * @Last Modified On   : 04/12/2019 11:17:30
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    01/11/2019   Mario Oliveira     Initial Version
**/
public with sharing class T_MODEC_ContratoSuporteReq_App {

    /*
     *  Metodo "mapearDto" é usado na classe "T_MODEC_ContratoSuporteReq_CTRL"
     *  para, atraves do id da pagina "T_ContratoSuporteReqVF", buscar registros
     *  nos campos do objeto e atribuir tais valores às variaveis no DTO da controller  
    */
    public static T_MODEC_ContratoSuporteReq_CTRL.ModecContractDTO mapearDto(string contratoId){

        /*
        *  Metodo "buscarElemento" vem da classe "T_MODEC_ContratoSuporteReq_REP",
        *  está sendo atribuido à variavel "contrato" de tipo "TW1_MODEC_Contract__c" (sObject)
        *  e, para o parametro do metodo é passado o id da pagina "T_ContratoSuporteReqVF",
        *  que vem atraves da classe controller
        */
        TW1_MODEC_Contract__c contrato = T_MODEC_ContratoSuporteReq_REP.buscarElemento(contratoId);

        /*
         *  Atribuição dos valores dos registros do objeto "TW1_MODEC_Contract__c",
         *  que vem da classe repositorio "T_MODEC_ContratoSuporteReq_CTRL" às variaveis
         *  do DTO, na classe controller
         */
        T_MODEC_ContratoSuporteReq_CTRL.ModecContractDTO contratoDto = new T_MODEC_ContratoSuporteReq_CTRL.ModecContractDTO();
        
        contratoDto.NameDTO = contrato.Name;
        contratoDto.SapOutlineAgreementNumberDTO = contrato.TW1_SAP_Outline_Agreement_Number__c;
        contratoDto.TypeOfContractDTO = contrato.TW1_Type_of_Contract__c;
        contratoDto.RequestorSponsorDTO = contrato.TW1_Requestor_Sponsor__c;
        contratoDto.JobTitleDTO = contrato.TW1_Job_Title__c;
        contratoDto.DateDTO = contrato.TW1_Date__c;
        contratoDto.VendorDTO = contrato.TW1_Vendor__r.Name;
        contratoDto.SAPCodeDTO = contrato.TW1_Vendor__r.TW1_SAP_Code__c;
        contratoDto.VendorCNPJDTO = contrato.TW1_Vendor_CNPJ__c;
        contratoDto.VendorVettingDTO = contrato.TW1_Vendor_Vetting__c;
        contratoDto.MainContactDTO = contrato.TW1_Main_Contact__c;
        contratoDto.PartyEmailDTO = contrato.TW1_Party_Email__c;
        contratoDto.BIDDTO = contrato.TW1_BID__c;
        contratoDto.JustificationDTO = contrato.TW1_Justification__c;
        contratoDto.ContempledInThisAgreementDTO = contrato.TW1_Contempled_in_this_Agreement__c; //NewField - 03/12/2019
        contratoDto.TerminationConditionsPenaltyDTO = contrato.TW1_Termination_Conditions_Penalty__c;
        contratoDto.PreviousContractAmountADTO = contrato.TW1_Previous_Contract_Amount_A__c;
        contratoDto.AccumulatedContractAmoutDTO = contrato.TW1_Accumulated_Contract_Amout__c;
        contratoDto.ContractedValueBDTO = contrato.TW1_Contracted_Value_B__c;
        contratoDto.IncreaseDTO = contrato.TW1_Increase__c;
        contratoDto.AnnualEstimateDTO = contrato.TW1_Annual_Estimate__c;
        contratoDto.CurrencyIsoCodeDTO = contrato.CurrencyIsoCode;
        contratoDto.MonthlyIfFixedDTO = contrato.TW1_Monthly_If_Fixed__c;
        contratoDto.EscalationDTO = contrato.TW1_Escalation__c;
        contratoDto.DurationDTO = contrato.TW1_Duration__c;
        contratoDto.PaymentTermDTO = contrato.TW1_Payment_Term__c;
        contratoDto.StartDateDTO = contrato.TW1_Start_Date__c;
        contratoDto.EndDateDTO = contrato.TW1_End_Date__c;
        contratoDto.PaymentConditionsDTO = contrato.TW1_Payment_Conditions__c;
        contratoDto.PONumberDTO = contrato.TW1_PO_Number__c;
        contratoDto.Budgeted2019DTO = contrato.TW1_Budgeted_2019__c;
        contratoDto.BudgetedJustificationDTO = contrato.TW1_Budgeted_Justification__c;
        contratoDto.CostCenterDTO = contrato.TW1_Cost_Center__c;
        contratoDto.WBSNumberDTO = contrato.TW1_WBS_Number__c;
        contratoDto.DepartmentCodeDTO = contrato.TW1_Department_Code__c;
        contratoDto.CostControllerDTO = contrato.TW1_Cost_Controller__c;

        return contratoDto;
    }
}