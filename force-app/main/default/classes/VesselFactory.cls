public  class VesselFactory {
    public static Vessel__c createVessel() {

        Vessel__c vessel = new Vessel__c(
                        Name = 'FPSO MV24',
                        ShortName__c = 'MV24',
                        Status__c = 'In Operation',
                        SPC__c = AccountFactory.insertAcc(Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId(), '').Id,
                        WOAttention__c = 'WO Attention',
                        Country__c = 'Brazil',
                        FieldLocation__c = 'Iracema Sul area');
        insert vessel;
        return vessel;       
    }
}