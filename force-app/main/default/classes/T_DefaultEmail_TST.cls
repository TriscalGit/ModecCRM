/**
 * @description       :
 * @author            : Gabriel Uchôa
 * @group             :
 * @last modified on  : 24-02-2021
 * @last modified by  : Gabriel Uchôa
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   24-02-2021   Gabriel Uchôa   Initial Version
 **/

@isTest
public class T_DefaultEmail_TST { 

    @isTest
    public static void TestMethod_sendEmail(){
        Blob arquivo = Blob.valueOf('TestClass');
        
        T_DefaultEmail.EmailFile EmailFile = new T_DefaultEmail.EmailFile();
        EmailFile.file = arquivo;
        EmailFile.fileName = 'TestClass.csv';
        
        T_DefaultEmail.Email email = new T_DefaultEmail.Email();
        email.assunto = 'TestClass Subject';
        email.destinatarios = new List<string>{'TestClass@TestClass.com'};
        email.files = new List<T_DefaultEmail.EmailFile>{EmailFile};
        email.htmlBody = 'TestClass HTMLBODY';
        email.ReplyTo = 'TestClass@TestClass.com';
        
        List<T_DefaultEmail.EmailError> retornoEmails = T_DefaultEmail.sendEmail(new List<T_DefaultEmail.Email>{email});
        System.assertEquals(false, retornoEmails.get(0).error);
    }
    
    @isTest
    public static void TestMethod_sendEmail_errorCase(){
        
        T_DefaultEmail.Email email = new T_DefaultEmail.Email();
        email.emailTemplateDeveloperName = 'TestClass';
        email.destinatarios = new List<string>{'TestClass@TestClass.com'};
        email.recordId = 'TestClass';
        email.ContactLeadOrUserId = 'TestClass';
        
        List<T_DefaultEmail.EmailError> retornoEmails = T_DefaultEmail.sendEmail(new List<T_DefaultEmail.Email>{email});
        System.assertEquals(true, retornoEmails.get(0).error);
    }
}