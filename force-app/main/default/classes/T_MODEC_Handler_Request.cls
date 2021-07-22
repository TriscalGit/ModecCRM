/**
 * @File Name          : T_MODEC_Handler_Request.cls
 * @Description        :
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 09-03-2020
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    05/11/2019   Mario Oliveira     Initial Version
 **/
public with    sharing class T_MODEC_Handler_Request
    implements ITrigger {
    private boolean m_isExecuting  = false;
    private integer BatchSize      = 0;
    public static boolean firstRun = true;

    // Construtor
    public T_MODEC_Handler_Request(boolean isExecuting, integer size)
    {
        system.debug('Criou Handler Request');
        m_isExecuting = isExecuting;
        BatchSize     = size;
    }

    public void bulkBefore()
    {
    }

    public void bulkAfter()
    {
    }

    public void beforeInsert(SObject so)
    {
        /*TW1_Fidelidade__c historico = (TW1_Fidelidade__c)so;
         * T_Ancar_TriggerFidelidade.validacriacaoFidelidade(historico);*/

        T_SDK_DebugLog.EscreverLog('Executando método beforeInsert da trigger 3 do objeto Request');
        TW1_Request__c oldRequest = (TW1_Request__c)so;
        TW1_Request__c newRequest = (TW1_Request__c)so;
        //This boolean is true when the SAP StatusBoletim RestResource is called.
        if (TriggerFactory.validateRequesterEmail)
        {
            T_SDK_DebugLog.EscreverLog('beforeInsert Irá executar método validarSupplierEmail');
            T_MODEC_Request_App.validarSupplierEmail(oldRequest, newRequest);
        }
    }

    public void beforeUpdate(SObject oldSo, SObject so)
    {
        //T_SDK_DebugLog.EscreverLog('Executando método beforeUpdate da trigger 3 do objeto Request');
        TW1_Request__c oldRequest = (TW1_Request__c)oldSo;
        TW1_Request__c newRequest = (TW1_Request__c)so;

        Controle_de_Triggers__c ctrlTriggers = Controle_de_Triggers__c.getInstance();

        if (ctrlTriggers.Request_Vendor_Vetting_RecId__c == oldRequest.RecordTypeId || oldRequest.RecordtypeId == Schema.SObjectType.TW1_Request__c.getRecordTypeInfosByDeveloperName().get('TW3_Vendor_Vetting_Senegal').getRecordTypeId())
        {
            system.debug('Metodo checkAllApprovalls.');
            T_MODEC_Request_App.checkAllApprovalls(oldRequest, newRequest);
        }

        if (TriggerFactory.validateRequesterEmail)
        {
            T_SDK_DebugLog.EscreverLog('beforeUpdate Irá executar método validarSupplierEmail');
            T_MODEC_Request_App.validarSupplierEmail(oldRequest, newRequest);
        }
        //Validating if is rectype inspection - this saves time and cpu process.
        if (oldRequest.RecordtypeId == Schema.SObjectType.TW1_Request__c.getRecordTypeInfosByDeveloperName().get('Inspection').getRecordTypeId())
        {
            T_MODEC_Request_App.validateSendInspectionAction(oldRequest, newRequest);
            T_MODEC_Request_App.validateCancelInspectionAction(oldRequest, newRequest);
        }
    }

    public void beforeDelete(SObject so)
    {
        // Adicionando o erro ao objeto
        //Object.addError('Você não pode deletar o seu contato Oportunidade');
    }

    public void afterInsert(SObject so)
    {
        //T_SDK_DebugLog.EscreverLog('Executando método afterInsert da trigger 1 do objeto Request');
        TW1_Request__c          request      = (TW1_Request__c)so;
        Controle_de_Triggers__c ctrlTriggers = Controle_de_Triggers__c.getInstance();

        if (ctrlTriggers.Request_Vendor_Vetting_RecId__c == request.RecordTypeId)
        {
            system.debug('Metodo criarCategoriasdaHomologacao.');
            T_MODEC_Request_App.criarCategoriasdaHomologacao(request);
        }
    }

    public void afterUpdate(SObject oldSo, SObject so)
    {
        //T_SDK_DebugLog.EscreverLog('Executando método afterUpdate da trigger 2 do objeto Request');
        TW1_Request__c          oldReq       = (TW1_Request__c)oldSo;
        TW1_Request__c          newReq       = (TW1_Request__c)so;
        Controle_de_Triggers__c ctrlTriggers = Controle_de_Triggers__c.getInstance();

        if (ctrlTriggers.Request_Vendor_Vetting_RecId__c == oldReq.RecordTypeId || oldReq.RecordtypeId == Schema.SObjectType.TW1_Request__c.getRecordTypeInfosByDeveloperName().get('TW3_Vendor_Vetting_Senegal').getRecordTypeId())
        {
            system.debug('Metodo homologarCategorias.');
            T_MODEC_Request_App.homologarCategorias(oldReq, newReq);
        }
    }

    public void afterDelete(SObject so)
    {
    }

    public void OnUndelete(SObject restoredSObject)
    {
    }

    public void andFinally()
    {
    }
}