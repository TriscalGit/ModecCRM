/**
 * @File Name          : T_MODEC_Request_App.cls
 * @Description        : Classe application para receber regra de negócio do object - TW1_Request__c vindo da trigger.
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 07-22-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    05/11/2019   Mario Oliveira     Initial Version
 **/
public class T_MODEC_Request_App {
    /**
     * @description Método para criar categorias a serem homologadas
     * @author Mario Oliveira | 05/11/2019
     * @param objeto do tipo TW1_Request__c
     * @return void
     **/
    public static void criarCategoriasdaHomologacao(TW1_Request__c request)
    {
        /*
         *  Criar regras de negocio aqui.
         */

        //Realizar Query no Recordtype e comparar ao do request.
        RecordType vendorVetting = [SELECT SobjectType, Id, DeveloperName, Name FROM RecordType where DeveloperName = 'TW1_Vendor_Vetting'];

        T_SDK_DebugLog.EscreverLog('Recordtype vendorVetting :' + vendorVetting);

        if (request.RecordtypeId != vendorVetting.id)
        {
            T_SDK_DebugLog.EscreverLog('Saindo do método criarCategoriasdaHomologacao, request não é do tipo TW1_Vendor_Vetting');
            return;
        }

        //Buscar com o id da conta request.TW1_Vendor__c
        //Chamando rep de vendor category
        //buscando categorias nao homologadas.
        //List<vendorcateogry> listacategorias = repVendeorCategory.Buscarcategoriasnaohomologadas(request.TW1_Vendor__c)

        List<TW1_Vendor_Category__c>    listaReqCategory = T_MODEC_Account_REP.getVendorCategoryById(request.TW1_Vendor__c);
        List<TW1_Requested_Category__c> listacategorias  = new list<TW1_Requested_Category__c>();
        T_SDK_DebugLog.EscreverLog('listaReqCategory :' + listaReqCategory);
        if (listaReqCategory.size() == 0)
        {
            request.AddError('Fornecedor não possui categorias para homologar.');
            return;
        }

        for (TW1_Vendor_Category__c vCategory :listaReqCategory)
        {
            TW1_Requested_Category__c req = new TW1_Requested_Category__c();
            req.TW1_Request__c         = request.id;
            req.TW1_Vendor_Category__c = vCategory.id;
            req.Name = (vCategory.TW1_Category__r.TW1_Category__c).abbreviate(80);
            if (vCategory.TW1_Category__r.TW1_Sub_Category__c != null)
            {
                req.Name = (req.Name + vCategory.TW1_Category__r.TW1_Sub_Category__c).abbreviate(80);
            }
            listacategorias.add(req);
        }
        T_SDK_DebugLog.EscreverLog('Inserindo categorias no banco.');
        insert listacategorias;
    }
    
    public static void criarShare(TW1_Request__c newReq)
    {
        //SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause, LastModifiedDate, LastModifiedById FROM TW1_Request__Share where ParentId = 'a0a2h000004jy0WAAQ'
        //
        TW1_Request__Share reqshare = new TW1_Request__Share();
        reqshare.ParentId = newReq.Id;
        reqshare.UserOrGroupId = '00G2h000001FheoEAC';
        reqshare.AccessLevel = 'Read';
        reqshare.RowCause = 'manual';
        system.debug('Share >'+reqshare);
        
        insert reqshare;
             
    }

    /**
     * @description Método que executa o processo de homologação
     * @author Mario Oliveira | 06/11/2019
     * @param oldReq objeto Request antes do update
     * @param newReq objeto Request apos update
     * @return void
     **/
    public static void homologarCategorias(TW1_Request__c oldReq, TW1_Request__c newReq)
    {
        T_SDK_DebugLog.EscreverLog('Entrou no metodo "homologarCategorias"');
        if ((oldReq.TW1_Homologation_Process_Status__c != newReq.TW1_Homologation_Process_Status__c) && ((newReq.TW1_Homologation_Process_Status__c == 'Approved') || (newReq.TW1_Homologation_Process_Status__c == 'Approved with red flag')))
        {
            //Executa ação de homologar.

            T_SDK_DebugLog.EscreverLog('Entrou no "IF" do metodo "homologarCategorias"');

            List<TW1_Requested_Category__c> listNotHomologId = [SELECT Id, TW1_Vendor_Category__r.Id, TW1_Vendor_Category__r.TW1_Status__c FROM TW1_Requested_Category__c where TW1_Request__c = :newReq.Id];
            List<TW1_Request__c>            listExpDate      = [SELECT Id, TW1_Shelf_Life_Vetting_Date__c FROM TW1_Request__c where Id = :newReq.Id];
            List<TW1_Vendor_Category__c>    vendorList       = new List<TW1_Vendor_Category__c>();

            Set<String> vendorCatIds = new Set<String>();
            for (integer i = 0; i < listNotHomologId.size(); i++)
            {
                T_SDK_DebugLog.EscreverLog('Entrou no "FOR" que popula "vendorCatIds"(SET)');
                vendorCatIds.add(listNotHomologId [i].TW1_Vendor_Category__r.Id);
            }

            for (String vendorCateg :vendorCatIds)
            {
                T_SDK_DebugLog.EscreverLog('Entrou no "FOR" que percorre "vendorCatIds"(SET) e popula "vendorList"');
                TW1_Vendor_Category__c vendCat = new TW1_Vendor_Category__c();
                vendCat.Id                     = vendorCateg;
                vendCat.TW1_Status__c          = 'Homologated';
                vendCat.TW1_Expiration_Date__c = listExpDate [0].TW1_Shelf_Life_Vetting_Date__c;
                vendorList.add(vendCat);
            }

            T_SDK_DebugLog.EscreverLog('Update no metodo "homologarCategorias"');
            upsert vendorList;
        }
    }

    /**
     * @description validar se e-mails do objeto TW1_Request__c estão em TW1_Email_List__c
     * @author Mario Oliveira | 03/12/2019
     * @param oldRequest
     * @param newRequest
     * @return void
     **/
    public static void validarSupplierEmail(TW1_Request__c oldRequest, TW1_Request__c newRequest)
    {
        T_SDK_DebugLog.EscreverLog('Entrando no método validarSupplierEmail');

        //Realizar Query no Recordtype e comparar ao do request.
        RecordType BM = [SELECT SobjectType, Id, DeveloperName, Name FROM RecordType where DeveloperName = 'TW1_BM'];

        T_SDK_DebugLog.EscreverLog('Recordtype TW1_BM :' + BM);

        if (oldRequest.RecordtypeId != BM.Id)
        {
            T_SDK_DebugLog.EscreverLog('Saindo do método validarSupplierEmail, request não é do tipo TW1_BM');
            return;
        }

        if ((oldRequest.RecordtypeId == BM.Id) && (newRequest.BM_Status__c != 'Não enviado'))
        {
            T_SDK_DebugLog.EscreverLog('Saindo do método validarSupplierEmail, request é do tipo TW1_BM mas Status != Nao Enviado');
            return;
        }

        //
        string rectypeIdEmailListBM       = Schema.SObjectType.TW1_Email_List__c.getRecordTypeInfosByDeveloperName().get('TW1_BM_Email').getRecordTypeId();
        List<TW1_Email_List__c> emailList = [SELECT TW1_Email__c, TW1_Status__c FROM TW1_Email_List__c WHERE TW1_Status__c = 'Ativo' AND RecordtypeId = :rectypeIdEmailListBM];
        T_SDK_DebugLog.EscreverLog('lista de emails :' + emailList);
        List<string> listEmailsAtivos = new List<string>();

        for (TW1_Email_List__c em :emailList)
        {
            listEmailsAtivos.add(em.TW1_Email__c);
        }

        //Verificar se emails de TW1_Modec_Requester_Email__c (TW1_Request__c) estão em TW1_Email__c (TW1_Email_List__c)
        if (!listEmailsAtivos.contains(newRequest.TW1_Modec_Requester_Email__c))
        {
            T_SDK_DebugLog.EscreverLog('Entrou na comparação entre emails em TW1_Modec_Requester_Email__c e TW1_Email__c');
            //Validating user language to display correct message
            String currentuserId   = UserInfo.getUserId();
            User   currentUserInfo = [select LanguageLocaleKey from User where Id = :UserInfo.getUserId()];
            if (currentUserInfo.LanguageLocaleKey == 'pt_BR')
            {
                newRequest.AddError('Email do Requisitante MODEC não está cadastrado como ativo.');
            }
            else
            {
                newRequest.AddError('Modec Requester Email is not registered as active.');
            }
        }
    }

    public static void checkAllApprovalls(TW1_Request__c oldRequest, TW1_Request__c newRequest)
    {
        //Validando que só entra neste metódo quando o request é do tipo Vendor Vetting

        /*T_SDK_DebugLog.EscreverLog('Validando que só entra neste metódo quando o request é do tipo Vendor Vetting');
         * RecordType VendorVettingRecType = [SELECT SobjectType, Id, DeveloperName, Name FROM RecordType where DeveloperName = 'TW1_Vendor_Vetting'];
         * if(oldRequest.RecordTypeId != VendorVettingRecType.id) {
         *      T_SDK_DebugLog.EscreverLog('Saindo do método pois não é do tipo VendorVetting');
         *      return;
         * }*/
        //Validando que um dos campos de controle foi atualizado.
        if ((oldRequest.TW1_Approval_Status_Compliance_Step_1__c != newRequest.TW1_Approval_Status_Compliance_Step_1__c) || (oldRequest.TW1_Approval_Status_Compliance_Step_2__c != newRequest.TW1_Approval_Status_Compliance_Step_2__c) || (oldRequest.TW1_Approval_Status_Docs_Validation_VV__c != newRequest.TW1_Approval_Status_Docs_Validation_VV__c) || (oldRequest.TW1_Approval_Status_Engineering__c != newRequest.TW1_Approval_Status_Engineering__c) || (oldRequest.TW1_Approval_Status_Finance_Step_1__c != newRequest.TW1_Approval_Status_Finance_Step_1__c) || (oldRequest.TW1_Approval_Status_Finance_Step_2__c != newRequest.TW1_Approval_Status_Finance_Step_2__c) || (oldRequest.TW1_Approval_Status_HSEQ_EPCI_or_Op__c != newRequest.TW1_Approval_Status_HSEQ_EPCI_or_Op__c) || (oldRequest.TW1_Approval_Status_Initial_Validation__c != newRequest.TW1_Approval_Status_Initial_Validation__c) || (oldRequest.TW1_Approval_Status_Procurement_Manager__c != newRequest.TW1_Approval_Status_Procurement_Manager__c) || (oldRequest.TW1_Approval_Status_Quality__c != newRequest.TW1_Approval_Status_Quality__c))
        {
            //Validar se todos os campos picklist estão com valor 'Approved' ou 'Approved with Red Flag'
            if (((newRequest.TW1_Approval_Status_Compliance_Step_1__c == 'Approved') || (newRequest.TW1_Approval_Status_Compliance_Step_1__c == 'Approved with Red Flag') || (newRequest.TW1_Approval_Status_Compliance_Step_1__c == 'N/A')) && ((newRequest.TW1_Approval_Status_Compliance_Step_2__c == 'Approved') || (newRequest.TW1_Approval_Status_Compliance_Step_2__c == 'Approved with Red Flag') || (newRequest.TW1_Approval_Status_Compliance_Step_2__c == 'N/A')) && ((newRequest.TW1_Approval_Status_Docs_Validation_VV__c == 'Approved') || (newRequest.TW1_Approval_Status_Docs_Validation_VV__c == 'Approved with Red Flag') || (newRequest.TW1_Approval_Status_Docs_Validation_VV__c == 'N/A')) && ((newRequest.TW1_Approval_Status_Engineering__c == 'Approved') || (newRequest.TW1_Approval_Status_Engineering__c == 'Approved with Red Flag') || (newRequest.TW1_Approval_Status_Engineering__c == 'N/A')) && ((newRequest.TW1_Approval_Status_Finance_Step_1__c == 'Approved') || (newRequest.TW1_Approval_Status_Finance_Step_1__c == 'Approved with Red Flag') || (newRequest.TW1_Approval_Status_Finance_Step_1__c == 'N/A')) && ((newRequest.TW1_Approval_Status_Finance_Step_2__c == 'Approved') || (newRequest.TW1_Approval_Status_Finance_Step_2__c == 'Approved with Red Flag') || (newRequest.TW1_Approval_Status_Finance_Step_2__c == 'N/A')) && ((newRequest.TW1_Approval_Status_HSEQ_EPCI_or_Op__c == 'Approved') || (newRequest.TW1_Approval_Status_HSEQ_EPCI_or_Op__c == 'Approved with Red Flag') || (newRequest.TW1_Approval_Status_HSEQ_EPCI_or_Op__c == 'N/A')) && ((newRequest.TW1_Approval_Status_Initial_Validation__c == 'Approved') || (newRequest.TW1_Approval_Status_Initial_Validation__c == 'Approved with Red Flag') || (newRequest.TW1_Approval_Status_Initial_Validation__c == 'N/A')) && ((newRequest.TW1_Approval_Status_Procurement_Manager__c == 'Approved') || (newRequest.TW1_Approval_Status_Procurement_Manager__c == 'Approved with Red Flag') || (newRequest.TW1_Approval_Status_Procurement_Manager__c == 'N/A')) && ((newRequest.TW1_Approval_Status_Quality__c == 'Approved') || (newRequest.TW1_Approval_Status_Quality__c == 'Approved with Red Flag') || (newRequest.TW1_Approval_Status_Quality__c == 'N/A')))
            {
                T_SDK_DebugLog.EscreverLog('Request VendorVetting aprovado, marcando TW1_All_Approvals__c = true');
                newRequest.TW1_All_Approvals__c = true;
            }
        }
    }

    /**
     * @description validar se e-mails do objeto TW1_Request__c estão em TW1_Email_List__c
     * @author Mario Oliveira | 03/12/2019
     * @param MapOldRequest
     * @param MapNewRequest
     * @return void
     **/
    /*
     * public static void validarSupplierEmailBULK(Map<Id, Sobject> MapOldRequest, Map<Id, Sobject> MapNewRequest)
     * {
     *  T_SDK_DebugLog.EscreverLog('Entrando no método validarSupplierEmailBULK');
     *
     *  //Realizar Query no Recordtype e comparar ao do request.
     *  RecordType BM = [SELECT SobjectType, Id, DeveloperName, Name FROM RecordType where DeveloperName = 'TW1_BM'];
     *
     *  T_SDK_DebugLog.EscreverLog('Recordtype TW1_BM :' + BM);
     *
     *  //Querying EmailList records to validate BM.TW1_Modec_Requester_Email__c
     *  List<TW1_Email_List__c> emailList = [SELECT TW1_Email__c, TW1_Status__c FROM TW1_Email_List__c WHERE TW1_Status__c = 'Ativo'];
     *  T_SDK_DebugLog.EscreverLog('lista de emails :' + emailList);
     *  List<string> listEmailsAtivos = new List<string>();
     *
     *  for (TW1_Email_List__c em :emailList)
     *  {
     *      listEmailsAtivos.add(em.TW1_Email__c);
     *  }
     *
     *  //Validating user language to display correct message
     *  String currentuserId   = UserInfo.getUserId();
     *  User   currentUserInfo = [select LanguageLocaleKey from User where Id = :UserInfo.getUserId()];
     *
     *  for (Sobject sobjectOld :MapOldRequest.values())
     *  {
     *      TW1_Request__c requestOld = (TW1_Request__c)sobjectOld;
     *      if ((requestOld.RecordtypeId != BM.Id) && (requestOld.BM_Status__c != 'Não enviado'))
     *      {
     *          T_SDK_DebugLog.EscreverLog('Request is not a BM , And Status != Nao Enviado');
     *          continue;
     *      }
     *
     *
     *
     *      //Verificar se emails de TW1_Modec_Requester_Email__c (TW1_Request__c) estão em TW1_Email__c (TW1_Email_List__c)
     *      TW1_Request__c requestNew = (TW1_Request__c)MapNewRequest.get(requestOld.Id);
     *      if (!listEmailsAtivos.contains(requestNew.TW1_Modec_Requester_Email__c))
     *      {
     *          T_SDK_DebugLog.EscreverLog('Entrou na comparação entre emails em TW1_Modec_Requester_Email__c e TW1_Email__c');
     *
     *          if (currentUserInfo.LanguageLocaleKey == 'pt_BR')
     *          {
     *              MapNewRequest.get(requestOld.Id).AddError('Email do Requisitante MODEC não está cadastrado como ativo.');
     *          }
     *          else
     *          {
     *              MapNewRequest.get(requestOld.Id).AddError('Modec Requester Email is not registered as active.');
     *          }
     *      }
     *  }
     * }*/

    /**
     * @description
     * @author Rafael Hadama | 25/06/2020
     * @return void
     **/
    public static void validateSendInspectionAction(TW1_Request__c oldRequest, TW1_Request__c newRequest)
    {
        T_MODEC_ScheduleInspection_App ScheduleApp = new T_MODEC_ScheduleInspection_App();



        if ((oldRequest.TW1_Inspection_Sent__c != newRequest.TW1_Inspection_Sent__c) && (newRequest.TW1_Inspection_Sent__c == true))
        {
            system.debug('Inspection sent boolean == true');
            system.debug('oldRequest.TW1_Inspection_Status__c :' + oldRequest.TW1_Inspection_Status__c);
            system.debug('newRequest.TW1_Inspection_Status__c :' + newRequest.TW1_Inspection_Status__c);
            if (oldRequest.TW1_Inspection_Status__c != 'Not Submitted')
            {
                system.debug('Retornando erro a action');
                newRequest.addError('You cannot send an inspection that was already sent.');
            }
            else
            {
                T_MODEC_ScheduleInspection_Ctrl.InspectionDatesDto InspectionDatesDto = new T_MODEC_ScheduleInspection_Ctrl.InspectionDatesDto();
                InspectionDatesDto.EmergencyInspectionDate = oldRequest.TW1_Emergency_Date__c;
                InspectionDatesDto.InspectionDate1         = oldRequest.TW1_Inspection_Date_Option_1__c;
                InspectionDatesDto.InspectionDate2         = oldRequest.TW1_Inspection_Date_Option_2__c;
                InspectionDatesDto.InspectionDate3         = oldRequest.TW1_Inspection_Date_Option_3__c;
                InspectionDatesDto.InspectionNote          = oldRequest.TW1_Note__c;
                InspectionDatesDto.RequestId      = oldRequest.Id;
                InspectionDatesDto.EmergencyEmail = oldRequest.TW1_Emergency_Email__c;

                if (oldRequest.TW1_Emergency_Date__c == null)
                {
                    InspectionDatesDto.InspectionType = 'normal';
                }
                else
                {
                    InspectionDatesDto.InspectionType = 'emergencial';
                }
                T_MODEC_ScheduleInspection_Ctrl.InspectionResponseDto response = new T_MODEC_ScheduleInspection_Ctrl.InspectionResponseDto();
                response = ScheduleApp.ValidateScheduledInspection(InspectionDatesDto, false);

                if (response.Status == 'Erro')
                {
                    system.debug('Response com status erro: ' + response);
                    String currentuserId   = UserInfo.getUserId();
                    User   currentUserInfo = [select LanguageLocaleKey from User where Id = :UserInfo.getUserId()];
                    if (currentUserInfo.LanguageLocaleKey == 'pt_BR')
                    {
                        newRequest.addError('Datas agendadas estão inválidas, por favor agende novamente.');
                    }
                    else
                    {
                        newRequest.addError('Schedule dates are invalid, please schedule inspection again.');
                    }
                }
            }

            newRequest.TW1_Inspection_Sent__c = false;
        }
    }

    public static void validateCancelInspectionAction(TW1_Request__c oldRequest, TW1_Request__c newRequest)
    {
        //TW1_Inspection_Scheduled_Date__c
        //validar se é do tipo inspection e TW1_Cancel_Inspection__c = true(desta forma sei que é a action fazendo isto)
        //

        //validando que está vindo da action, pois ela marca este booleano TW1_Cancel_Inspection__c
        if ((oldRequest.TW1_Cancel_Inspection__c != newRequest.TW1_Cancel_Inspection__c) && (newRequest.TW1_Cancel_Inspection__c == true))
        {
            if (newRequest.TW1_Inspection_Scheduled_Date__c != null)
            {
                boolean  ReproveRequest   = false;
                Datetime CancelledDateNow = Datetime.now();
                system.debug('CancelledDateNow >' + CancelledDateNow);
                ReproveRequest = T_MODEC_StepTrigger_App.ValidateTimeBetweenTwoDateTimes(newRequest.TW1_Inspection_Scheduled_Date__c, CancelledDateNow);

                if (ReproveRequest)
                {
                    system.debug('ReproveRequest >' + ReproveRequest);
                    newRequest.TW1_Inspection_Status__c = 'Reproved';
                }
                else
                {
                    system.debug('ReproveRequest >' + ReproveRequest);
                    newRequest.TW1_Inspection_Status__c = 'Canceled';
                }
            }
            else
            {
                system.debug('TW1_Inspection_Scheduled_Date__c >' + newRequest.TW1_Inspection_Scheduled_Date__c);
                newRequest.TW1_Inspection_Status__c = 'Canceled';
            }
        }
    }
}