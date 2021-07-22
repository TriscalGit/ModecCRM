@isTest
public class T_MODEC_Handler_ContentDocumentTST {

    @isTest
    public static void TestMethod1(){
        T_MODEC_Handler_ContentDocument handler = new T_MODEC_Handler_ContentDocument(true, 6);
        handler.bulkBefore();
        handler.bulkAfter();
        handler.beforeInsert(null);
        handler.beforeUpdate(null, null);
        handler.beforeDelete(null);
        handler.afterInsert(null);
        handler.afterUpdate(null, null);
        handler.afterDelete(null);
        handler.OnUndelete(null);
        handler.andFinally();
    }
}