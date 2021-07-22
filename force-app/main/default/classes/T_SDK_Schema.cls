/**
 * @File Name          : T_SDK_Schema.cls
 * @Description        : 
 * @Author             : Rafael Hadama
 * @Group              : 
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 04/11/2019 15:25:54
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    04/11/2019   Rafael Hadama     Initial Version
**/
public class T_SDK_Schema {
   /**
    * @description Método que recebe o nome do objeto e nome do campo, e retorna uma lista com as opções da picklist.
    * @author Rafael Hadama | 24/10/2019
    * @param apinameObjeto
    * @param apinameCampo
    * @return list<DtoFieldPicklist> retorno seguindo um dto DtoFieldPicklist, pois é utilizado em LightningComponents
    **/
   public static list<DtoFieldPicklist> getFieldPicklistValues(string apinameObjeto, string apinameCampo)
   {
      List<String>               picklistValues   = new List<String>();
      SObjectType                objectType       = Schema.getGlobalDescribe().get(apinameObjeto);
      List<Schema.PicklistEntry> pick_list_values = objectType.getDescribe()
                                                       .fields.getMap()
                                                       .get(apinameCampo)
                                                       .getDescribe().getPickListValues();

      List<DtoFieldPicklist> DtoListFieldPicklist = new List<DtoFieldPicklist>();

      for (Schema.PicklistEntry aPickListValue : pick_list_values)
      {
         system.debug('getvalue() :' + aPickListValue.getValue());
         system.debug('getlabel() :' + aPickListValue.getLabel());

         DtoFieldPicklist ItemListFieldPicklist = new DtoFieldPicklist();
         ItemListFieldPicklist.value = aPickListValue.getValue();
         ItemListFieldPicklist.label = aPickListValue.getLabel();
         //picklistValues.add(aPickListValue.getValue());

         DtoListFieldPicklist.add(ItemListFieldPicklist);
      }

      return DtoListFieldPicklist;
   }

   /**
    * @description Método que retorna a label de um campo.
    * @author Rafael Hadama | 24/10/2019
    * @param apinameObjeto
    * @param apinameCampo
    * @return string (label do campo informado)
    **/
   public static string getFieldLabel(string apinameObjeto, string apinameCampo)
   {
      List<Schema.DescribeSObjectResult> describeSobjectsResult = Schema.describeSObjects(new List<String> { apinameObjeto }); // this can accept list of strings, we describe only one object here
      //System.debug(describeSobjectsResult);
      Map<String, Schema.SObjectField> allFields = describeSobjectsResult[0].fields.getMap();
      //System.debug(allFields);
      String fieldLabel = allFields.get(apinameCampo).getDescribe().getLabel();

      return fieldLabel;
   }

   /**
    * @description : Método que recebe o nome do objeto e nome do campo, e retorna map com a assinatura Map<String,String>
    * @author Rafael Hadama | 24/10/2019
    * @param apinameObjeto Developername do Objeto
    * @param apinameCampo  ApiName do campo
    * @return map<string, string> key apiname, value label
    **/
   public static map<string, string> getMapPicklistValuesLabels(string apinameObjeto, string apinameCampo)
   {
      SObjectType                objectType       = Schema.getGlobalDescribe().get(apinameObjeto);
      List<Schema.PicklistEntry> pick_list_values = objectType.getDescribe()
                                                       .fields.getMap()
                                                       .get(apinameCampo)
                                                       .getDescribe().getPickListValues();

      map<string, string> mapLabelValues = new map<string, string>();

      for (Schema.PicklistEntry aPickListValue : pick_list_values)
      {
         system.debug('getvalue() :' + aPickListValue.getValue());
         system.debug('getlabel() :' + aPickListValue.getLabel());
         mapLabelValues.put(aPickListValue.getValue(), aPickListValue.getLabel());
      }

      return mapLabelValues;
   }

   public class DtoFieldPicklist {
      @AuraEnabled
      public String value;
      @AuraEnabled
      public String label;
   }
}