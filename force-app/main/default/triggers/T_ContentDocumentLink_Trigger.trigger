/**
 * @description       :
 * @author            : Hugo Brito
 * @group             :
 * @last modified on  : 04-23-2021
 * @last modified by  : Hugo Brito
 * Modifications Log
 * Ver   Date         Author       Modification
 * 1.0   04-23-2021   Hugo Brito   Criação da trigger
 **/
Trigger T_ContentDocumentLink_Trigger on ContentDocumentLink (before insert, before update, before delete, after insert, after update, after delete) {

    //BeforeInsert
    if(Trigger.isInsert && Trigger.isBefore){
        T_ContentDocumentLinkValidationApp.ValidateInsertDocument(Trigger.new);
        
    //BeforeUpdate
    } else if(Trigger.isUpdate && Trigger.isBefore){
        T_ContentDocumentLinkValidationApp.ValidateInsertDocument(Trigger.new);
        
    //BeforeDelete
    } else if(Trigger.isDelete && Trigger.isBefore){
        T_ContentDocumentLinkValidationApp.ValidateDeleteDocument(Trigger.old);
        
    //AfterInsert
    } else if(Trigger.isInsert && Trigger.isAfter){
        
    //AfterUpdate
    } else if(Trigger.isUpdate && Trigger.isAfter){
        
    //AfterDelete
    } else if(Trigger.isDelete && Trigger.isAfter){
        
    }
}