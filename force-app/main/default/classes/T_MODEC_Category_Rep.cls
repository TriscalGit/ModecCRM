/**
 * @File Name          : T_MODEC_Category_Rep.cls
 * @Description        :
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 09-23-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    04/11/2019   Rafael Hadama     Initial Version
 **/
public class T_MODEC_Category_Rep {
    public list<TW1_Category__c> getCategoriesbyCountryAndRecType(string pais)
    {
        list<TW1_Category__c> listaCategorias = new list<TW1_Category__c>();

        listaCategorias = [SELECT Id, RecordType.DeveloperName, TW1_Code__c, TW1_Category__c, TW1_Sub_Category__c FROM TW1_Category__c WHERE TW1_Country__c =:pais ORDER BY TW1_Sub_Category__c DESC, TW1_Category__c DESC];

        return listaCategorias;
    }

    public list<TW1_Category__c> getAllCategories()
    {
        list<TW1_Category__c> listaCategorias = new list<TW1_Category__c>();

        listaCategorias = [SELECT Id, RecordType.DeveloperName, TW1_Code__c, TW1_Category__c, TW1_Sub_Category__c, TW1_SUB_CATEGORY_EN__c, TW1_Category_EN__c, TW3_Category_FR__c, TW3_Sub_Categoria_FR__c FROM TW1_Category__c ORDER BY TW1_Sub_Category__c DESC, TW1_Category__c DESC];

        return listaCategorias;
    }

    /*public list<RecordType> getRecordTypesforCategory()
     * {
     * list<RecordType> listRecTypes = [select id, DeveloperName from RecordType where SobjectType = 'TW1_Category__c'];
     *
     * return listRecTypes;
     * }*/
}