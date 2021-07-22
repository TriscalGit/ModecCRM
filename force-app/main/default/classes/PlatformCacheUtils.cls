global class PlatformCacheUtils {

    @InvocableMethod(label='PlatformCacheUtils_manageValuesOnPartition()')
    global static List<List<String>> manageValuesOnPartition(List<Parametro> params){
        List<List<String>> retorno = null;
        for(Parametro param: params) {
            IF(param.operation == 'get'){
                retorno = getValueOnPartition(new List<Parametro>{param});
            } else if(param.operation == 'set') {
                setValueOnPartition(new List<Parametro>{param});
            } else if(param.operation == 'remove') {
                removeValueOnPartition(new List<Parametro>{param});
            }
        }
        return retorno;
    }
    
    global static void setValueOnPartition(List<Parametro> params){
        for(Parametro param: params){
            Cache.SessionPartition sessionPart = Cache.Session.getPartition(param.particao);
            sessionPart.put(param.particaoItem, param.value);
        }
    }
    
    global static List<List<String>> getValueOnPartition(List<Parametro> params){
        List<List<String>> retorno = new List<List<String>>();
        for(Parametro param: params){
            Cache.SessionPartition sessionPart = Cache.Session.getPartition(param.particao);
            retorno.add((List<String>) sessionPart.get(param.particaoItem));
        }
        return retorno;
    }
    
    global static void removeValueOnPartition(List<Parametro> params){
        for(Parametro param: params){
            Cache.SessionPartition sessionPart = Cache.Session.getPartition(param.particao);
            sessionPart.put(param.particaoItem, '');
        }
    }
    
    global class Parametro {
        @InvocableVariable
        global String particao;
        @InvocableVariable
        global String particaoItem;
        @InvocableVariable
        global List<String> value;
        @InvocableVariable
        global String operation; //Valores: get, set, remove
    }
}