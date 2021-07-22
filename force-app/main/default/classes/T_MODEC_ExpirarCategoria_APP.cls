/**
 * @File Name          : T_MODEC_ExpirarCategoria_APP.cls
 * @Description        : 
 * @Author             : Rafael Hadama
 * @Group              : 
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 19/02/2020 13:56:33
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    18/02/2020   Rafael Hadama     Initial Version
**/
public class T_MODEC_ExpirarCategoria_APP {

    public static void ExpirarCategoria() {
            
        T_MODEC_RecordType_Rep RecordTypeREP = new T_MODEC_RecordType_Rep();
        T_MODEC_VendorCategory_Rep VendorCategoryREP = new T_MODEC_VendorCategory_Rep();
        List<TW1_Vendor_Category__c> categorias = VendorCategoryREP.GetVendorCategoriesExpiring();
        RecordType recAcc =RecordTypeREP.GetVendorNotHomologRecType();

        T_SDK_DebugLog.EscreverLog('lista de categorias:' + categorias);

        try {

            T_SDK_DebugLog.EscreverLog('Iterando pelas categorias e modificando status ');
            for (TW1_Vendor_Category__c categoria : categorias) {

                T_SDK_DebugLog.EscreverLog('Entrou no "FOR" do "TRY" da classe "ExpirarCategoria"');
                categoria.TW1_Status__c = 'Expired';
                
            }

            T_SDK_DebugLog.EscreverLog('"UPDATE" da lista de categorias');
            update categorias;
            
        } catch (Exception exc) {
            
            T_SDK_DebugLog.EscreverLog('Entrou no "CATCH" da classe "ExpirarCategoria" em "T_MODEC_ExpirarCategoria_APP"');
            T_SDK_DebugLog.EscreverLog('' + exc.getStackTraceString());
            T_SDK_DebugLog.EscreverLog('' + exc.getMessage());

        } finally{

            T_SDK_DebugLog.EscreverLog('Entrou no "FINALLY" da classe "ExpirarCategoria" em "T_MODEC_ExpirarCategoria_APP"');
            scheaduleJobAgain('T_MODEC_SCH_ExpirarCategoria');
            
        }
        
    }

    //método para schedular novamente.
    public static void scheaduleJobAgain(String jobName){
        
        T_SDK_DebugLog.EscreverLog('Entrou na classe "scheaduleJobAgain"');
        T_SDK_ScheaduleUtils.scheadule(jobName, 1440); // 24 horas = 1440 minutos

    }

}