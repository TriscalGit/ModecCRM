public class TechnicalMemberSupportFactory {
    
    public static TechnicalMemberSupport__c createTechSupport(NAM__c nam, String status, User user, String phase){
        TechnicalMemberSupport__c techSupport = new TechnicalMemberSupport__c(
            NAM__c = nam.Id,
            Description__c = 'Test',
            Status__c = status,
            Responsible__c = user.Id,
            Type__c = phase
        );

        insert techSupport;
        return techSupport;
    }

    public static User createUser(String username, String profileName){
        Profile profile = [SELECT Id FROM Profile WHERE Name =: profileName];
        User user = new User(Alias = 'user1',
                             isActive = true,
                             Email = 'user@modec-test.com', 
                             EmailEncodingKey = 'UTF-8', 
                             LastName = 'user1', 
                             LanguageLocaleKey = 'en_US',
                             LocaleSidKey='en_US', 
                             ProfileId = profile.Id,
                             TimeZoneSidKey = 'America/Los_Angeles',
                             UserName = username);
        insert user;
        return user;
    }
}