/**
 * @File Name          : T_MODEC_Handler_Step.cls
 * @Description        : Classe Handler para trigger do sobject TW1_Step__c
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 07-16-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    03/07/2020   Rafael Hadama     Initial Version
 **/
public class T_MODEC_Handler_Step implements ITrigger
{
    private boolean m_isExecuting  = false;
    private integer BatchSize      = 0;
    public static boolean firstRun = true;

    // Construtor
    public T_MODEC_Handler_Step(boolean isExecuting, integer size)
    {
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
    }

    public void beforeUpdate(SObject oldSo, SObject so)
    {
        TW1_Step__c OldStep = (TW1_Step__c)oldSo;
        TW1_Step__c NewStep = (TW1_Step__c)so;

        system.debug('Trigger beforeUpdate TW1_Step__c Object >' + OldStep.TW1_Request__r.RecordtypeId);
        T_MODEC_StepTrigger_App.ValidateIfStepIsClosed(OldStep, NewStep);
    }

    public void beforeDelete(SObject so)
    {
    }

    public void afterInsert(SObject so)
    {
    }

    public void afterUpdate(SObject oldSo, SObject so)
    {
        //T_SDK_DebugLog.EscreverLog('Executando método afterUpdate da trigger 2 do objeto Request');
        TW1_Step__c OldStep = (TW1_Step__c)oldSo;
        TW1_Step__c NewStep = (TW1_Step__c)so;

        system.debug('Trigger AfterUpdate TW1_Step__c Object');
        T_MODEC_StepTrigger_App.ValidateApprovalStepInspection(OldStep, NewStep);
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