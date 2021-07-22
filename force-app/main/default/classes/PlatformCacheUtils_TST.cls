@isTest
public class PlatformCacheUtils_TST {

    @isTest
    Public static void TestMethod1(){
        PlatformCacheUtils.Parametro param = new PlatformCacheUtils.Parametro();
        param.operation = 'set';
        param.particao = 'Interaction';
        param.particaoItem = 'teste';
        param.value = New List<String>{'valor'};
        PlatformCacheUtils.manageValuesOnPartition(new List<PlatformCacheUtils.Parametro>{param});
    }
    
    @isTest
    Public static void TestMethod2(){
        TestMethod1();
        
        PlatformCacheUtils.Parametro param = new PlatformCacheUtils.Parametro();
        param.operation = 'get';
        param.particao = 'Interaction';
        param.particaoItem = 'teste';
        List<List<String>> listaFora = PlatformCacheUtils.manageValuesOnPartition(new List<PlatformCacheUtils.Parametro>{param});
        System.assertEquals('valor', listaFora.get(0).get(0));
    }
    
    @isTest
    Public static void TestMethod3(){
        TestMethod1();
        
        PlatformCacheUtils.Parametro param = new PlatformCacheUtils.Parametro();
        param.operation = 'remove';
        param.particao = 'Interaction';
        param.particaoItem = 'teste';
        PlatformCacheUtils.manageValuesOnPartition(new List<PlatformCacheUtils.Parametro>{param});
    }
}