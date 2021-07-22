public class CollectionUtil {

	public static void carregarMap(Map<Id, SObject> mapSObj, String campoChave, List<SObject> lstSObj) {
        Map<Object, SObject> mapAux = carregarMapObject(campoChave, lstSObj);
        
        for(Object chave : mapAux.keySet()){
            mapSObj.put((Id)chave, mapAux.get(chave));
        }
    }

    public static void carregarMap(Map<Integer, SObject> mapSObj, String campoChave, List<SObject> lstSObj) {
        Map<Object, SObject> mapAux = carregarMapObject(campoChave, lstSObj);
        
        for(Object chave : mapAux.keySet()){
            mapSObj.put((Integer)chave, mapAux.get(chave));
        }
    }

    public static void carregarMap(Map<String, SObject> mapSObj, String campoChave, List<SObject> lstSObj) {
        Map<Object, SObject> mapAux = carregarMapObject(campoChave, lstSObj);
        
        for(Object chave : mapAux.keySet()){
            mapSObj.put((String)chave, mapAux.get(chave));
        }
    }

    public static void carregarMap(Map<String, SObject> mapSObj, Set<String> setCamposChave, List<SObject> lstSObj) {
        Map<String, SObject> mapAux = carregarMapObject(setCamposChave, lstSObj);
        
        for(String chave : mapAux.keySet()){
            mapSObj.put(chave, mapAux.get(chave));
        }
    }

    public static void carregarMap(Map<Id, List<SObject>> mapSObj, String campoChave, List<SObject> lstSObj) {
        Map<Object, List<SObject>> mapAux = carregarMapListSObject(campoChave, lstSObj);

        for(Object chave : mapAux.keySet()){
            if(!mapSObj.containsKey((Id)chave)){
                mapSObj.put(((Id)chave), new List<SObject>());
            }               
            mapSObj.get((Id)chave).addAll(mapAux.get(chave));
        }
    }

    public static void carregarMap(Map<Integer, List<SObject>> mapSObj, String campoChave, List<SObject> lstSObj) {
        Map<Object, List<SObject>> mapAux = carregarMapListSObject(campoChave, lstSObj);

        for(Object chave : mapAux.keySet()){
            if(!mapSObj.containsKey((Integer)chave)){
                mapSObj.put(((Integer)chave), new List<SObject>());
            }               
            mapSObj.get((Integer)chave).addAll(mapAux.get(chave));
        }
    }

    public static void carregarMap(Map<String, List<SObject>> mapSObj, String campoChave, List<SObject> lstSObj) {
        Map<Object, List<SObject>> mapAux = carregarMapListSObject(campoChave, lstSObj);

        for(Object chave : mapAux.keySet()){
            if(!mapSObj.containsKey((String)chave)){
                mapSObj.put(((String)chave), new List<SObject>());
            }               
            mapSObj.get((String)chave).addAll(mapAux.get(chave));
        }
    }

    public static void carregarMap(Map<String, List<SObject>> mapSObj, Set<String> setCamposChave, List<SObject> lstSObj) {
        Map<String, List<SObject>> mapAux = carregarMapListSObject(setCamposChave, lstSObj);

        for(String chave : mapAux.keySet()){
            if(!mapSObj.containsKey(chave)){
                mapSObj.put(chave, new List<SObject>());
            }               
            mapSObj.get(chave).addAll(mapAux.get(chave));
        }
    }

    public static void carregarMap(Map<String, String> mapObj, String campoChave, String campoValor, List<SObject> lstSObj){
        Map<Object, Object> mapAux = carregarMapObject(campoChave, campoValor, lstSObj);

        for(Object chave : mapAux.keySet()){
            mapObj.put((String)chave, (String)mapAux.get(chave));
        }
    }

    public static void carregarMap(Map<Id, String> mapObj, String campoChave, String campoValor, List<SObject> lstSObj){
        Map<Object, Object> mapAux = carregarMapObject(campoChave, campoValor, lstSObj);

        for(Object chave : mapAux.keySet()){
            mapObj.put((Id)chave, (String)mapAux.get(chave));
        }
    }

    public static void carregarMap(Map<Id, Integer> mapObj, String campoChave, String campoValor, List<SObject> lstSObj){
        Map<Object, Object> mapAux = carregarMapObject(campoChave, campoValor, lstSObj);

        for(Object chave : mapAux.keySet()){
            mapObj.put((Id)chave, (Integer)mapAux.get(chave));
        }
    }

    public static void carregarMap(Map<Id, Decimal> mapObj, String campoChave, String campoValor, List<SObject> lstSObj){
        Map<Object, Object> mapAux = carregarMapObject(campoChave, campoValor, lstSObj);

        for(Object chave : mapAux.keySet()){
            mapObj.put((Id)chave, (Decimal)mapAux.get(chave));
        }
    }

    public static void carregarMap(Map<String, Integer> mapObj, String campoChave, String campoValor, List<SObject> lstSObj){
        Map<Object, Object> mapAux = carregarMapObject(campoChave, campoValor, lstSObj);

        for(Object chave : mapAux.keySet()){
            mapObj.put((String)chave, (Integer)mapAux.get(chave));
        }
    }

    public static void carregarMap(Map<String, Decimal> mapObj, String campoChave, String campoValor, List<SObject> lstSObj){
        Map<Object, Object> mapAux = carregarMapObject(campoChave, campoValor, lstSObj);

        for(Object chave : mapAux.keySet()){
            mapObj.put((String)chave, (Decimal)mapAux.get(chave));
        }
    }

    public static void carregarSet(Set<Id> setIds, String campoChave, List<SObject> lstSObj) {
        Id chave = null;
        
        for(SObject sObj : lstSObj) {
            chave = (Id) sObj.get(campoChave);

            setIds.add(chave);
        }
    }

    public static void carregarSet(Set<Integer> setInteger, String campoChave, List<SObject> lstSObj) {
        Integer chave = null;
        
        for(SObject sObj : lstSObj) {
            chave = (Integer) sObj.get(campoChave);

            setInteger.add(chave);
        }
    }

    public static void carregarSet(Set<String> setString, String campoChave, List<SObject> lstSObj) {
        String chave = null;
        
        for(SObject sObj : lstSObj) {
            chave = (String) sObj.get(campoChave);

            setString.add(chave);
        }
    }

    public static void carregarList(List<Id> listIds, String campoChave, List<SObject> lstSObj) {
        Id chave = null;
        
        for(SObject sObj : lstSObj) {
            chave = (Id) sObj.get(campoChave);

            listIds.add(chave);
        }
    }

    public static void carregarList(List<String> listString, String campoChave, List<SObject> lstSObj) {
        String chave = null;
        
        for(SObject sObj : lstSObj) {
            chave = (String) sObj.get(campoChave);

            listString.add(chave);
        }
    }

    private static Map<Object, SObject> carregarMapObject(String campoChave, List<SObject> lstSObj){
        Map<Object, SObject> mapSObj = new Map<Object, SObject>();
        String campoPai = null;
        String sObjectPai = null;
        Object chave = null;
        
        for(SObject obj : lstSobj)
        {
            if(campoChave.indexOf('.') > 0){
                List<String> arrObjetoCampo = campoChave.split('\\.');
                sObjectPai = arrObjetoCampo.get(0);
                campoPai = arrObjetoCampo.get(1);
            }

            chave = (sObjectPai == null ? obj.get(campoChave) : obj.getSObject(sObjectPai).get(campoPai));
            mapSObj.put(chave, obj);   
        }

        return mapSObj;
    }

    private static Map<Object, Object> carregarMapObject(String campoChave, String campoValor, List<SObject> lstSObj){
        Map<Object, Object> mapSObj = new Map<Object, Object>();
        Object chave = null;
        Object valor = null;
        String campoPai = null;
        String sObjectPai = null;
        String campoPai2 = null;
        String sObjectPai2 = null;
        

        for(SObject obj : lstSObj)
        {
            if(campoChave.indexOf('.') > 0){
                List<String> arrObjetoCampo = campoChave.split('\\.');
                sObjectPai = arrObjetoCampo.get(0);
                campoPai = arrObjetoCampo.get(1);
            }

            if(campoValor.indexOf('.') > 0){
                List<String> arrObjetoCampo2 = campoValor.split('\\.');
                sObjectPai2 = arrObjetoCampo2.get(0);
                campoPai2 = arrObjetoCampo2.get(1);
            }

            chave = (sObjectPai == null ? obj.get(campoChave) : obj.getSObject(sObjectPai).get(campoPai));
            valor = (sObjectPai2 == null ? obj.get(campoValor) : obj.getSObject(sObjectPai2).get(campoPai2));
            mapSObj.put(chave, valor);
        }

        return mapSObj;
    }

    private static Map<Object, List<SObject>> carregarMapListSObject(String campoChave, List<SObject> lstSObj){
        Map<Object, List<SObject>> mapSObj = new Map<Object, List<SObject>>();
        String campoPai = null;
        String sObjectPai = null;
        Object chave = null;

        for(SObject obj : lstSObj)
        {
            campoPai = null;
            sObjectPai = null;
            chave = null;

            if(campoChave.indexOf('.') > 0){
                List<String> arrObjetoCampo = campoChave.split('\\.');
                sObjectPai = arrObjetoCampo.get(0);
                campoPai = arrObjetoCampo.get(1);
            }

            chave = (sObjectPai == null ? obj.get(campoChave) : obj.getSObject(sObjectPai).get(campoPai));

            List<SObject> lst = mapSObj.get(chave);
            if(lst == null) {
                lst = new List<SObject>();
                mapSObj.put(chave, lst);
            }

            lst.add(obj);
        }

        return mapSObj;       
    }

    private static Map<String, SObject> carregarMapObject(Set<String> setCamposChave, List<SObject> lstSObj) {
        Map<String, SObject> mapSObj = new Map<String, SObject>();
        
        for(SObject obj : lstSobj) {
            String campoPai = null;
            String sObjectPai = null;
            String chave = null;
            String chaveComposta = null;
            List<String> lstChaves = new List<String>();

            for(String campoChave : setCamposChave) {
                if(campoChave.indexOf('.') > 0){
                    List<String> arrObjetoCampo = campoChave.split('\\.');
                    sObjectPai = arrObjetoCampo.get(0);
                    campoPai = arrObjetoCampo.get(1);
                }
                chave = (sObjectPai == null ? (String)obj.get(campoChave) : (String)obj.getSObject(sObjectPai).get(campoPai));
                lstChaves.add(chave);
            }

            chaveComposta = String.join(lstChaves, '_');
            mapSObj.put(chaveComposta, obj);   
        }

        return mapSObj;
    }

    private static Map<String, List<SObject>> carregarMapListSObject(Set<String> setCamposChave, List<SObject> lstSObj) {
        Map<String, List<SObject>> mapSObj = new Map<String, List<SObject>>();
        
        for(SObject obj : lstSObj) {
            String campoPai = null;
            String sObjectPai = null;
            String chave = null;
            String chaveComposta = null;
            List<String> lstChaves = new List<String>();

            for(String campoChave : setCamposChave) {
                chave = null;
                if(campoChave.indexOf('.') > 0) {
                    List<String> arrObjetoCampo = campoChave.split('\\.');
                    sObjectPai = arrObjetoCampo.get(0);
                    campoPai = arrObjetoCampo.get(1);
                }

                chave = (sObjectPai == null ? (String)obj.get(campoChave) : (String)obj.getSObject(sObjectPai).get(campoPai));
                lstChaves.add(chave);
            }

            chaveComposta = String.join(lstChaves, '_');
            List<SObject> lst = mapSObj.get(chaveComposta);
            if(lst == null) {
                lst = new List<SObject>();
                mapSObj.put(chaveComposta, lst);
            }

            lst.add(obj);
        }

        return mapSObj;       
    }
}