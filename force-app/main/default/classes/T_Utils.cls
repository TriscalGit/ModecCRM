Public class T_Utils {
    
    //Metodo que monta um Set de String com base em um campo de uma lista de SObject
    public static Set<String> getSetIds(List<SObject> sObjs, String fieldName) {
        Set<String> ids = new Set<String>();
        for (SObject sObj : sObjs)
        {   
            if (sObj.get(fieldName) != null) ids.add( (String) sObj.get(fieldName) );
        }
        return ids;
    }
    
    //Metodo que monta um Map de String com List de SObject com base em um campo de uma lista de SObject
    public static Map<String,List<SObject>> montaMapaListaSObjectComCampoComoChave(String campoNomeAPI, List<SObject> registros) {
        Map<String,List<SObject>> retorno = new Map<String,List<SObject>>();
        
        IF(registros != null){
            for(SObject registro : registros) {
                List<SObject> temp;
                IF(retorno.ContainsKey((String) registro.get(campoNomeAPI))){
                    temp = retorno.get((String) registro.get(campoNomeAPI));
                } else {
                    temp = new List<SObject>();
                }
                temp.add(registro);
                retorno.put((String) registro.get(campoNomeAPI),temp);
            }
        }
        return retorno;
    }
    
    //Metodo que monta um Map de String com List de SObject com base em um campo de uma lista de SObject
    public static Map<String,SObject> montaMapaSObjectComCampoComoChave(String campoNomeAPI, List<SObject> registros) {
        Map<String,SObject> retorno = new Map<String,SObject>();
        
        IF(registros != null){
            for(SObject registro : registros) {
                retorno.put((String) registro.get(campoNomeAPI),registro);
            }
        }
        return retorno;
    }
}