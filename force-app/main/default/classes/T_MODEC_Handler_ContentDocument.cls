/**
 * @description       :
 * @author            : Rafael Hadama
 * @group             :
 * @last modified on  : 10-07-2020
 * @last modified by  : Saulo Silva
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   09-21-2020   Rafael Hadama   Initial Version
 **/
public class T_MODEC_Handler_ContentDocument implements ITrigger {
    
   private boolean m_isExecuting  = false;
   private integer BatchSize      = 0;
   public static boolean firstRun = true;

   // Construtor
   public T_MODEC_Handler_ContentDocument(boolean isExecuting, integer size)
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
      /*TW1_Step__c OldStep = (TW1_Step__c)oldSo;
      TW1_Step__c NewStep = (TW1_Step__c)so;

      system.debug('Trigger beforeUpdate TW1_Step__c Object >' + OldStep.TW1_Request__r.RecordtypeId);*/
      //T_MODEC_StepTrigger_App.ValidateIfStepIsClosed(OldStep, NewStep);
   }

   public void beforeDelete(SObject so)
   {            
       /*ContentDocument oContentDocument = (ContentDocument)so;
     
       T_MODEC_ContentDocumentApp.ValidateDeletedDocument(oContentDocument);*/
   }

   public void afterInsert(SObject so)
   {
   }

   public void afterUpdate(SObject oldSo, SObject so)
   {
      //T_SDK_DebugLog.EscreverLog('Executando método afterUpdate da trigger 2 do objeto Request');
      /*TW1_Step__c OldStep = (TW1_Step__c)oldSo;
      TW1_Step__c NewStep = (TW1_Step__c)so;

      system.debug('Trigger AfterUpdate TW1_Step__c Object');*/
      //T_MODEC_StepTrigger_App.ValidateApprovalStepInspection(OldStep, NewStep);
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