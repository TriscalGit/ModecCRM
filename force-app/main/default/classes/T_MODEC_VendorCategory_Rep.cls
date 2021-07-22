/**
 * @File Name          : T_MODEC_VendorCategory_Rep.cls
 * @Description        : 
 * @Author             : Rafael Hadama
 * @Group              : 
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 19/02/2020 14:03:50
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    18/02/2020   Rafael Hadama     Initial Version
**/
public class T_MODEC_VendorCategory_Rep {
    
    public static list<TW1_Vendor_Category__c> getVendorCategoryById(String accountId){ 

        list<TW1_Vendor_Category__c> req = [
            SELECT
            id,
            Name,
            TW1_VEndor__c,
            TW1_Category__c,
            TW1_Category__r.TW1_Category__c,
            TW1_Category__r.TW1_Sub_Category__c
            FROM
            TW1_Vendor_Category__c
            WHERE
            TW1_VEndor__c =: accountId
        ];

        //AND TW1_Vendor_Category__c.TW1_Status__c != 'Homologated'
        return req;

    }

    public list<TW1_Vendor_Category__c> GetVendorCategoriesExpiring(){ 

        list<TW1_Vendor_Category__c> req = [
            SELECT
            id,
            Name,
            TW1_Vendor__c ,
            TW1_Category__c,
            TW1_Category__r.TW1_Category__c,
            TW1_Category__r.TW1_Sub_Category__c,
            TW1_Status__c 
            FROM
            TW1_Vendor_Category__c
            WHERE
            TW1_Expiration_Date__c  < TODAY
            AND TW1_Status__c = 'Homologated'
        ];

        return req;

    }
 }