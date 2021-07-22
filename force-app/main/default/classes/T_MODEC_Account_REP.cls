/**
 * @File Name          : T_MODEC_Account_REP.cls
 * @Description        : 
 * @Author             : Mario Oliveira
 * @Group              : 
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 29/01/2020 15:09:32
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    06/11/2019   Mario Oliveira     Initial Version
**/
public class T_MODEC_Account_REP {
    
    /**
    * @description Buscando categorias relacionadas a conta do fornecedor que não estão homelogadas.
    * @author Mario Oliveira | 06/11/2019 
    * @param accountId referente a TW1_Request__c com recordtype - TW1_Vendor_Vetting
    * @return list<TW1_Vendor_Category__c> 
    **/
    private static Id RTAccountSupplierHomologated;
    private static Id RTAccountSupplierHomologatedSenegal;
    private static Id RTAccountSupplierNotHomologated;
    private static Id RTAccountSupplierNotHomologatedSenegal;
    
    private static Id VendorVettingActive;    
    
    public static List<Schema.PicklistEntry> getPicklistVendorVetting(String apiFieldName){   
        List<Schema.PicklistEntry> entries;
        if(apiFieldName == 'TW1_Vendor_Vetting__c'){
            entries = Account.TW1_Vendor_Vetting__c.getDescribe().getPicklistValues();
        }
		List<Schema.PicklistEntry> activeEntries = new List<Schema.PicklistEntry>();
    	for (Schema.PicklistEntry entry : entries) {
        	if (entry.isActive()) {                
            	activeEntries.add(entry);
        	}
    	}
        return activeEntries;
    }    
    
    private static void getRecordTypes(){
        RTAccountSupplierHomologated = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('TW1_Vendor_Homologated').getRecordTypeId();
        //RTAccountSupplierHomologatedSenegal = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('TW3_Supplier_Homologated_Senegal').getRecordTypeId();
        RTAccountSupplierNotHomologated = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('TW1_Vendor_Not_Homologated').getRecordTypeId();
        //RTAccountSupplierNotHomologatedSenegal = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('TW3_Supplier_Not_Homologated_Senegal').getRecordTypeId();
    }
    
    public static list<TW1_Vendor_Category__c> getVendorCategoryById(String accountId){ 
        return [SELECT id, Name, TW1_VEndor__c, TW1_Category__c, TW1_Category__r.TW1_Category__c, TW1_Category__r.TW1_Sub_Category__c
                FROM TW1_Vendor_Category__c
                WHERE TW1_VEndor__c =: accountId];
    }

    public static list<Account> buscarContasExpiradas(){ 
        return [SELECT id, Name, TW1_Shelf_Life_Vetting_Date__c, RecordType.developerName
                FROM Account
                WHERE TW1_Shelf_Life_Vetting_Date__c < TODAY AND RecordType.developerName = 'TW1_Vendor_Homologated'];
    }
    
    public list<Account> SearchAccountByCNPJ(string cnpj){
        return [SELECT id, Name, TW1_CNPJ__c
                FROM Account
                WHERE TW1_CNPJ__c =:cnpj];
    }
    
    public static List<Account> getSuppliersByNameAndCategoryType(String name, String categoryType, String vendorVetting){
        List<Account> retorno = new List<Account>();
        
        try {
            String soql = 'select id, Name, TW1_CNPJ__c, TW1_Supplier_Type__c, TW1_Vendor_Vetting__c from Account where Id != null ';
            
            IF(name != null && name != ''){
                soql += 'and Name like \'%'+name+'%\' ';
            }
            
            IF(categoryType == 'TW1_Service'){
                soql += 'and T_Quantity_of_Service_Supplier_Category__c > 0 ';
            } else if(categoryType == 'TW1_Material'){
                soql += 'and T_QuantityMaterialSupplierCategory__c > 0 ';
            }
            
            IF(vendorVetting != null && vendorVetting != '') {
                soql += 'and TW1_Vendor_Vetting__c like \'%'+vendorVetting+'%\' ';
            }
            
            getRecordTypes();
            soql += 'and (';
            soql += 'RecordTypeId = \''+ RTAccountSupplierHomologated + '\' or ';
            //soql += 'RecordTypeId = \''+ RTAccountSupplierHomologatedSenegal + '\' or ';
            soql += 'RecordTypeId = \''+ RTAccountSupplierNotHomologated + '\'';
            //soql += 'RecordTypeId = \''+ RTAccountSupplierNotHomologatedSenegal + '\'';
            soql += ') ';
            soql += 'order by Name asc ';
            soql += 'limit 10000';
            
            retorno = Database.query(soql);
        } catch(Exception e) {
            retorno = null;
            System.debug('Error - T_MODEC_Account_REP.class - Method: getSuppliersByNameAndCategoryType() - Description error: '+e.getMessage());
        }
        return retorno;
    }
    
    public static List<Account> getSuppliersByCategoryAndSubCategory(String category, String SubCategory, String vendorVetting){
        List<Account> retorno = new List<Account>();
        
        try {            
            String soql = 'select id, Name, TW1_CNPJ__c, TW1_Supplier_Type__c, TW1_Vendor_Vetting__c from Account ';
            
            soql += 'where Id IN (SELECT TW1_Vendor__c FROM TW1_Vendor_Category__c where id != null ';
            
            IF(category != null && category != '') {
                soql += 'and TW1_Category__r.TW1_Category__c like \'%'+category+'%\' ';
            }
            
            IF(SubCategory != null && SubCategory != ''){
                soql += ' and TW1_Category__r.TW1_Sub_Category__c like \'%'+SubCategory+'%\' ';
            }      
            
            soql += ') ';
            
            IF(vendorVetting != null && vendorVetting != '') {
                soql += 'and TW1_Vendor_Vetting__c like \'%'+vendorVetting+'%\' ';
            }
            
            getRecordTypes();
            soql += 'and (';
            soql += 'RecordTypeId = \''+ RTAccountSupplierHomologated + '\' or ';
            //soql += 'RecordTypeId = \''+ RTAccountSupplierHomologatedSenegal + '\' or ';
            soql += 'RecordTypeId = \''+ RTAccountSupplierNotHomologated + '\'';
            //soql += 'RecordTypeId = \''+ RTAccountSupplierNotHomologatedSenegal + '\'';
            soql += ') ';
            soql += 'order by Name asc ';
            soql += ' limit 10000';
            
            retorno = Database.query(soql);
            
        } catch(Exception e) {
            retorno = null;
            System.debug('Error - T_MODEC_Account_REP.class - Method: getSuppliersByCategoryAndSubCategory() - Description error: '+e.getMessage());
        }
        return retorno;
    }
}