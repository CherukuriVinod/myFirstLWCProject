@istest
public with sharing class TestSocialReach {


    // @TestSetup functions are used to initialize data before a test - this will be used for
    // all of the unit tests in the class

    // Note - at the time this course published, it is very hard to obtain accurate CPU time values within
    // unit tests. You can use the initTestData function from anonymous Apex to initialize records
    // in an empty scratch org, then use the same code within the tests in an anonymous Apex
    // script to perform the test outside of a unit test - CPU time results will be more accurate.
    // Be sure to run multiple tests and average the results if you want any degree of accuracy

    @TestSetup
    static void initializeTestData(){
        SocialReach.initTestData(200, 5);
    }
 
    // Brute force search
    @istest
    public static void BruteForceTest1()
    {
        Map<Id,Account> accounts = new Map<ID, Account>([Select ID from Account]);
        Test.startTest();
        Map<ID, SocialReach.SocialInfo> results = SocialReach.BruteForceTest1(accounts);
        Test.stopTest();
        system.assertEquals(200, results.size());
    }

    // Brute force search 2
    @istest
    public static void BruteForceTest2()
    {
        Map<Id,Account> accounts = new Map<ID, Account>([Select ID from Account]);
        Test.startTest();
        Map<ID, SocialReach.SocialInfo> results = SocialReach.BruteForceTest1(accounts);
        Test.stopTest();
        system.assertEquals(200, results.size());
    }
    
     // SOQL based test (design #3)
     @istest
     public static void SoqlBasedTest1()
     {
         Map<Id,Account> accounts = new Map<ID, Account>([Select ID from Account]);
         Test.startTest();
         Map<ID, SocialReach.SocialInfo> results = SocialReach.SoqlBasedTest1(accounts);
         Test.stopTest();
         system.assertEquals(200, results.size());
     }
     
     // SOQL based test (design #4)
     @istest
     public static void SoqlBasedTest2()
     {
         Map<Id,Account> accounts = new Map<ID, Account>([Select ID from Account]);
         Test.startTest();
         Map<ID, SocialReach.SocialInfo> results = SocialReach.SoqlBasedTest2(accounts);
         Test.stopTest();
         system.assertEquals(200, results.size());
    }   
}