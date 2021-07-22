/**
* @description       :
* @author            : Hugo Brito
* @group             :
* @last modified on  : 05-10-2021
* @last modified by  : Hugo Brito
* Modifications Log
* Ver   Date         Author       Modification
* 1.0   05-10-2021   Hugo Brito   Criação da classe
**/
public class T_DocumentationREP {
    
    public static List<TW1_Documentation__c> getInspectionDocumentation(Set<String> ids) {     
                
        return [select id from TW1_Documentation__c 
                where id in: ids and 
                RecordType.DeveloperName = 'TW1_Inspection_Documentation' and 
                (TW1_Request__r.TW1_Inspection_Status__c = 'Approved' or 
                TW1_Request__r.TW1_Inspection_Status__c = 'Approved with Restriction' or
                TW1_Request__r.TW1_Inspection_Status__c = 'Canceled' or
                TW1_Request__r.TW1_Inspection_Status__c = 'Rejected' or
                TW1_Request__r.TW1_Inspection_Status__c = 'Reproved')
               ];
        
    }
    
    public static Map<id, TW1_Documentation__c> getInspectionDocumentationMap(Set<String> ids) {        
        return new Map<id, TW1_Documentation__c>([select id from TW1_Documentation__c 
                where id in: ids and 
                RecordType.DeveloperName = 'TW1_Inspection_Documentation' and 
                (TW1_Request__r.TW1_Inspection_Status__c = 'Approved' or 
                TW1_Request__r.TW1_Inspection_Status__c = 'Approved with Restriction' or
                TW1_Request__r.TW1_Inspection_Status__c = 'Canceled' or
                TW1_Request__r.TW1_Inspection_Status__c = 'Rejected' or
                TW1_Request__r.TW1_Inspection_Status__c = 'Reproved')
               ]); 
    }
}