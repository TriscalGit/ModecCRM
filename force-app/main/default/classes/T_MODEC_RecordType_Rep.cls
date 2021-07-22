/**
 * @File Name          : T_MODEC_RecordType_Rep.cls
 * @Description        : 
 * @Author             : Rafael Hadama
 * @Group              : 
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 19/02/2020 13:29:40
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    04/11/2019   Rafael Hadama     Initial Version
**/
public class T_MODEC_RecordType_Rep {

    public RecordType GetVendorNotHomologRecType (){
        return [SELECT Id,SObjectType, developername 
                FROM RecordType 
                WHERE SObjectType = 'Account' And developername = 'TW1_Vendor_Not_Homologated' 
                limit 1];
    }
    
    public static List<RecordType> getCategoryRecordTypes(){
        return [select id, developerName, name 
                from RecordType 
                where SObjectType =: 'TW1_Category__c' 
                order by Name asc
                limit 100];
    }
}