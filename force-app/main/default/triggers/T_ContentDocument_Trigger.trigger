/**
 * @description       :
 * @author            : Rafael Hadama
 * @group             :
 * @last modified on  : 10-08-2020
 * @last modified by  : Saulo Silva
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   09-21-2020   Rafael Hadama   Initial Version
 **/
trigger T_ContentDocument_Trigger on ContentDocument(before delete, before insert,after insert, before update, after update) {

    //BeforeInsert
    if(Trigger.isInsert && Trigger.isBefore){
        
    //BeforeUpdate
    } else if(Trigger.isUpdate && Trigger.isBefore){
        
    //BeforeDelete
    } else if(Trigger.isDelete && Trigger.isBefore){
        T_MODEC_ContentDocumentApp.ValidateDeletedDocument(trigger.oldMap);
            
    //AfterInsert
    } else if(Trigger.isInsert && Trigger.isAfter){
        
    //AfterUpdate
    } else if(Trigger.isUpdate && Trigger.isAfter){
        
    //AfterDelete
    } else if(Trigger.isDelete && Trigger.isAfter){
        
    }
}