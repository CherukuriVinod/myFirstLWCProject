@istest
public with sharing class TestOwnerChange {

    @istest
    
    private static void TestOwnerChange1()
    {
        // Create some test contacts
        List<Contact> newContacts = InitTestContacts('c', 5);

        User u = initTestUser('myname', 'myname');

        System.runAs(u)
        {
            // These contacts will be created with a fake user as owner
            insert newContacts;
        }

        Test.startTest();

        for(Contact ct: newContacts)
        {
            ct.OwnerId = UserInfo.getUserId();
            ct.Email = 'someone@somewhere.com';
        }

        update newContacts;

        Test.stopTest();

        System.assertEquals(newContacts.size(), ProgramFlowExperiment.EmailCounter);

    }

    public static List<Contact> InitTestContacts(String prefix, Integer count)
    {
        List<Contact> results = new List<Contact>();
        for(Integer x = 0; x<count; x++)
        {
            results.add(new Contact(LastName = prefix + '_' + string.valueOf(x),
                                    email = prefix + '_' + string.valueOf(x) + '@apex4devs.com'));
        }
        return results;
    }

    public static User initTestUser(String username, String thealias)  
    {    
        User u = new User(Alias = thealias, 
        Email = username + '@apexfundementals.com', 
       FirstName='Joe', LastName= username,    
       TimeZoneSidKey = 'America/Los_Angeles', 
       UserName = username + '@apex4devs.com', 
       UserPermissionsMarketingUser=true,    LocaleSidKey='en_US', 
       EmailEncodingKey='UTF-8', LanguageLocaleKey = 'en_US');
       u.ProfileID = userinfo.getProfileId();
       return u;  
    }
}