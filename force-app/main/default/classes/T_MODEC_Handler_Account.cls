/**
 * @File Name          : T_MODEC_Handler_Account.cls
 * @Description        : 
 * @Author             : Mario Oliveira
 * @Group              : 
 * @Last Modified By   : Mario Oliveira
 * @Last Modified On   : 05/12/2019 18:52:11
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    05/12/2019   Mario Oliveira     Initial Version
**/
public with sharing class T_MODEC_Handler_Account implements ITrigger
{
   private boolean m_isExecuting = false;
   private integer BatchSize = 0;
   public static boolean firstRun = true;
   
   // Construtor
   public T_MODEC_Handler_Account(boolean isExecuting, integer size)
   {
       m_isExecuting = isExecuting;        
       BatchSize = size;
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
       
   }
   
   public void beforeDelete(SObject so)
   {
       
   }
   
   public void afterInsert(SObject so)
   {    
       T_SDK_DebugLog.EscreverLog('Executando método afterInsert da trigger T_MODEC_CriarContato_APP do objeto Account');
       Account conta = (Account)so;
       if(conta.RecordTypeId != Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId()
         && conta.RecordTypeId != Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Vendor').getRecordTypeId())
            T_MODEC_CriarContato_APP.criarContatoAssocConta(conta); //DESCOMENTAR AQUI PARA TESTAR
   }
   
   public void afterUpdate(SObject oldSo, SObject so)
   {
      
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