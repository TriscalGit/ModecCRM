/**
 * @File Name          : T_MODEC_ContratoSuporteReq_CTRL.cls
 * @Description        : 
 * @Author             : Mario Oliveira
 * @Group              : 
 * @Last Modified By   : Mario Oliveira
 * @Last Modified On   : 03/12/2019 17:56:10
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    01/11/2019   Mario Oliveira     Initial Version
**/
public with sharing class T_MODEC_ContratoSuporteReq_CTRL {
    
    public ModecContractDTO contratoVF {get;set;}
    

    public T_MODEC_ContratoSuporteReq_CTRL(){

        string pageId = ApexPages.currentPage().getParameters().get('contratoId');
        
        ModecContractDTO contratoDto = T_MODEC_ContratoSuporteReq_App.mapearDto(pageId);
        contratoVF = contratoDto;
        
    }

    public class ModecContractDTO{
        
        public string NameDTO {get;set;}
        public string SapOutlineAgreementNumberDTO {get;set;}
        public string TypeOfContractDTO {get;set;}
        public string RequestorSponsorDTO {get;set;}
        public string JobTitleDTO {get;set;}
        public date DateDTO {get;set;}
        //SIGNATURE

        public string VendorDTO {get;set;}
        public string VendorCNPJDTO {get;set;}
        public string VendorVettingDTO {get;set;}
        public string SAPCodeDTO {get;set;}
        public string MainContactDTO {get;set;}
        public string PartyEmailDTO {get;set;}
        //Telephone
        public string BIDDTO {get;set;}
        public string JustificationDTO {get;set;}

        public string ContempledInThisAgreementDTO {get;set;}
        public string TerminationConditionsPenaltyDTO {get;set;}

        public double PreviousContractAmountADTO {get;set;}
        public double AccumulatedContractAmoutDTO {get;set;}
        public double ContractedValueBDTO {get;set;}
        public double IncreaseDTO {get;set;}
        public double AnnualEstimateDTO {get;set;}
        public string CurrencyIsoCodeDTO {get;set;}
        public string MonthlyIfFixedDTO {get;set;}
        public string EscalationDTO {get;set;}
        public string DurationDTO {get;set;}
        public string PaymentTermDTO {get;set;}
        public date StartDateDTO {get;set;}
        public date EndDateDTO {get;set;}
        public string PaymentConditionsDTO {get;set;}
        public string PONumberDTO {get;set;}
        public string Budgeted2019DTO {get;set;}
        public string BudgetedJustificationDTO {get;set;}
        public string CostCenterDTO {get;set;}
        public string WBSNumberDTO {get;set;}
        public string DepartmentCodeDTO {get;set;}
        public string CostControllerDTO {get;set;}

        //CONTRACT OWNER DATE:
        //LEGAL TEAM DATE: 
        //SUPPLY CHAIN TEAM DATE 1:
        //SUPPLY CHAIN TEAM DATE 2:
        //SUPPLY CHAIN TEAM DATE 3:
        //MODEC PRESIDENT/VICE PRESIDENT DATE:
        //OTHERS DATE:

    }
}