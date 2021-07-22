public class T_DefineSObjectTypeInvocable {

    @InvocableMethod(label='T_DefineSObjectTypeInvocable_getSObjectType()' description='Get SObjectType from Id')
    public static List<String> getSObjectType(List<Id> recordIds){
        List<String> retorno = new List<String>();
        
        For(Id recordId: recordIds){
        	retorno.add(recordId.getSObjectType().getDescribe().getName());
        }
        return retorno;
    }
}