/**
 * @File Name          : T_MODEC_ContratoSuporteReq_TST.cls
 * @Description        :
 * @Author             : Mario Oliveira
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 11/02/2020 12:37:04
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    04/11/2019   Mario Oliveira     Initial Version
 **/
@isTest
public with sharing class T_MODEC_ContratoSuporteReq_TST {
   @isTest
   public static void T_MODEC_ContratoSuporteReq_TST()
   {
      /*
       * Passo 1 - Referenciar pagina visualforce
       * que será usada (Dar um nome. Para este caso,
       * foi dado o nome "myVFPage")
       */
      Pagereference myVFPage = Page.T_ContratoSuporteReqVF;

      /*
       *    Passo 2 - Setar pagina corrente padrão
       *	(Neste caso, a pagina padrão será a pagina
       *	referenciada no passo 1)
       */
      Test.setCurrentPage(myVFPage);

      /*
       *	Passo 3 - Criar uma variavel do tipo do objeto
       *  e igualar à classe de teste, chamando o metodo de mock
       */
      TW1_MODEC_Contract__c contractTest = T_MODEC_ContratoSuporteReq_TST.criarRegistroMock();

      /*
       *    Passo 4 - Dar "put" do id do contrato mockado
       *	no parametro da pagina referenciada
       */
      ApexPages.currentPage().getParameters().put('contratoId', contractTest.id);

      /*
       *    Passo 5 - Criar conexão com a classe controller
       */
      T_MODEC_ContratoSuporteReq_CTRL ctrl = new T_MODEC_ContratoSuporteReq_CTRL();
   }

   //Passo 6 - Classe Mock
   public static TW1_MODEC_Contract__c criarRegistroMock()
   {
      /*
       *    Passo 7 - Inserir conta mock (Pois há um relacionamento
       *	entre "TW1_Vendor__c" e "Account", então, para que seja
       *	possivel criar um registro no campo "TW1_Vendor__c"
       *	deve ser criado antes este registro em "Account")
       */

      //Buscando Usuário de integração para preencher custom settings devido ao process builder Account - General process
      
      ID_Account__c customSettingsIDAccount = new ID_Account__c();

      customSettingsIDAccount.Id_IntegrationUser__c = UserInfo.getUserId();
      insert customSettingsIDAccount;

      Account conta = new Account();
      conta.Name            = 'Teste conta';
      conta.TW1_SAP_Code__c = '252525';
      Insert conta;

      /*
       *    Passo 8 - Inserir informações mock relativas ao contrato
       */
      TW1_MODEC_Contract__c contractTST = new TW1_MODEC_Contract__c();

      contractTST.TW1_SAP_Outline_Agreement_Number__c = '00000001';
      contractTST.TW1_Type_of_Contract__c             = 'Service';
      contractTST.TW1_Requestor_Sponsor__c            = 'Michael Carlson Test';
      contractTST.TW1_Job_Title__c = 'CEO';
      contractTST.TW1_Date__c      = date.parse('05/11/2019');
      T_SDK_DebugLog.EscreverLog('Conta :' + conta);
      contractTST.TW1_Vendor__c        = conta.Id;
      contractTST.TW1_BID__c           = 'Yes';
      contractTST.TW1_Justification__c = 'Sit amet, lorem consectetur adipiscing, sed eiusmod tempor  ut labore et dolore magna aliqua.';
      contractTST.TW1_Contempled_in_this_Agreement__c   = 'Lorem consectetur adipiscing, sed eiusmod tempor  ut labore et dolore';
      contractTST.TW1_Termination_Conditions_Penalty__c = 'String teste 0';
      contractTST.TW1_Previous_Contract_Amount_A__c     = 1000.00;
      contractTST.TW1_Contracted_Value_B__c             = 10000.50;
      contractTST.TW1_Increase__c               = 0.56;
      contractTST.TW1_Annual_Estimate__c        = 100000.80;
      contractTST.CurrencyIsoCode               = 'BRL';
      contractTST.TW1_Monthly_If_Fixed__c       = 'Depends Demand';
      contractTST.TW1_Escalation__c             = 'IGPM';
      contractTST.TW1_Duration__c               = '24 Months';
      contractTST.TW1_Payment_Term__c           = '30 Days';
      contractTST.TW1_Start_Date__c             = date.parse('11/11/2019');
      contractTST.TW1_End_Date__c               = date.parse('11/11/2019');
      contractTST.TW1_Payment_Conditions__c     = 'String teste 3';
      contractTST.TW1_PO_Number__c              = 'String teste 4';
      contractTST.TW1_Budgeted_2019__c          = 'Yes';
      contractTST.TW1_Budgeted_Justification__c = 'String teste 7';
      contractTST.TW1_Cost_Center__c            = 'String teste 8';
      contractTST.TW1_WBS_Number__c             = 'String teste 9';
      contractTST.TW1_Department_Code__c        = 'String teste 10';
      contractTST.TW1_Cost_Controller__c        = 'String teste 11';

      /*
       ***** NÃO PRECISAM SER PREENCHIDOS (CAMPOS FORMULA) *****
       *****contractTST.Name
       *****contractTST.TW1_Vendor_CNPJ__c
       *****contractTST.TW1_Vendor_Vetting__c
       *****contractTST.TW1_Main_Contact__c
       *****contractTST.TW1_Party_Email__c
       *****contractTST.TW1_Accumulated_Contract_Amout__c
       */

      insert contractTST;

      /*
       *    Passo 9 - Retornar informações de "contractTST" para
       *  a variavel "contractTest" (Passo 3)
       */
      return contractTST;
   }
}