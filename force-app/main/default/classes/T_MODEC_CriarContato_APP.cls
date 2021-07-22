/**
 * @File Name          : T_MODEC_CriarContato_APP.cls
 * @Description        : Classe application para receber regra de negócio do object - Account vindo da Trigger.
 * @Author             : Mario Oliveira
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 28/01/2020 15:32:04
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    05/12/2019   Mario Oliveira     Initial Version
 **/
public without sharing class T_MODEC_CriarContato_APP {
   public T_MODEC_CriarContato_APP() {}

   public static void criarContatoAssocConta(Account conta)
   {
      // Método da Trigger responsável por criar um contato sempre que uma conta for criada (contato deve ser associado à conta)
      T_SDK_DebugLog.EscreverLog('Entrou no metodo "criarContatoAssocConta"');
      T_SDK_DebugLog.EscreverLog('Account Id >'+conta.Id);
      Contact newContact = new Contact();

      newContact.LastName  = conta.TW1_Contact_Name__c;
      newContact.Phone     = conta.TW1_Contact_Phone__c;
      newContact.Email     = conta.TW1_Contact_email_address__c;
      newContact.AccountId = conta.Id;

      insert newContact;
      T_SDK_DebugLog.EscreverLog('Inserção de novo contato realizada.');
      T_SDK_DebugLog.EscreverLog('Novo Contato: '+newContact);
   }
   
}