public class AccountFactory {
    public static Account insertAcc(string recordTypeId, string shortName){
        Account acc = new Account(Name = 'MODEC ' + shortName, 
                                    RecordTypeId = recordTypeId, 
                                    TW1_CNPJ__c = '48855909000158',
                                    ShortName__c = shortName);
         insert acc;
         return acc;
    }
}