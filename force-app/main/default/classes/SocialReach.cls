/*
Measure Social Engagement

Create a function that allows you to determine the social activity of any account that is based on all of the contacts associated with that account. 
For example, how many of the account contacts have a TwitterID, or LinkedinID, or a FaceBookID, but more important, how many of them have different combinations? 
For example, how many of those contacts have both a TwitterID and a LinkedinID, or a TwitterID and a FaceBook ID, or a LinkedinID and a FacebookID, or all three, 
or how many of them have no social accounts at all? This function might be called in a variety of ways. 
It might be called during a trigger, say, to populate that information onto fields of the account, so that it could be accessible for reporting purposes, 
or perhaps it's something you'll expose through a web service call, so that an outside service can determine the social metrics of an account, 
or perhaps it will be part of a Lightning component or Visualforce page where you can display the information for a specific account. 
The only thing we know for sure is that this function has to be able to process multiple accounts.
*/

public with sharing class SocialReach {
    public class SocialInfo
	{
		Integer None;
		Integer Twitters;
		Integer Facebooks;
		Integer Linkedins;
		Integer TwitterPlusFacebooks;
		Integer FacebookPlusLinkedins;
		Integer TwitterPlusLinkedins;
		Integer AllThree;
		
		public SocialInfo()
		{
			None=0; Twitters=0; Facebooks=0; Linkedins=0;
			TwitterPlusFacebooks = 0; FacebookPlusLinkedins = 0;
			TwitterPlusLinkedins = 0; AllThree = 0;
		}
	}

    public static Map<ID, SocialInfo> BruteForceTest1(Map<ID, Account> accounts)
    {

        // Mark start time
        Long startTime = DateTime.Now().getTime();
        Integer startCPUTime = Limits.getCpuTime();
        
        List<Contact> allcontacts = [Select ID, AccountID, TwitterID__c, FaceBookID__c, LinkedInID__c from Contact where AccountID in :accounts.keySet()];

        Map<ID, SocialInfo> results = new Map<ID, SocialInfo>();
        

        for(Contact ct: allcontacts)
        {
            SocialInfo accountresult = results.get(ct.AccountID);
            if(accountresult == null)
            {
                accountresult = new SocialInfo();
                results.put(ct.AccountID, accountresult);
            }
            Boolean anyfound = false;
            
            if(ct.TwitterID__c!=null) 
            {
                anyfound = true;
                accountresult.Twitters++;
            }
            if(ct.FacebookID__c!=null) 
            {
                anyfound = true;
                accountresult.Facebooks++;
            }
            if(ct.LinkedInID__c!=null) 
            {
                anyfound = true;
                accountresult.Linkedins++;
            }
            if(ct.TwitterID__c !=null && ct.LinkedInID__c!=null) 
            {
                anyfound = true;
                accountresult.TwitterPlusLinkedins++;
            }
            if(ct.FacebookID__c !=null && ct.LinkedInID__c!=null) 
            {
                anyfound = true;
                accountresult.FacebookPlusLinkedins++;
            }
            if(ct.TwitterID__c !=null && ct.FacebookID__c!=null) 
            {
                anyfound = true;
                accountresult.TwitterPlusFacebooks++;
            }
            if(ct.TwitterID__c !=null && ct.FacebookID__c!=null && ct.LinkedInID__c!=null) 
            {
                anyfound = true;
                accountresult.AllThree++;
            }
            if(!anyfound) accountresult.none++;
        }

        Long elapsedTime = DateTime.now().getTime() - startTime;
        Integer elapsedCPUTime = Limits.getCpuTime() - startCPUTime;
        system.debug(LoggingLevel.Error, 'Total elapsed time: ' + elapsedTime + 'ms');
        system.debug(LoggingLevel.Error, 'Total CPU time: ' + elapsedCPUTime + 'ms');

        return results;

    }

    // Brute force search 2
     public static Map<ID, SocialInfo> BruteForceTest2(Map<ID, Account> accounts)
    {

        // Mark start time
        Long startTime = DateTime.Now().getTime();
        Integer startCPUTime = Limits.getCpuTime();

    	// Get a list of contacts for each account
    	List<Account> accountdata = [Select ID, (Select ID, TwitterID__c, FaceBookID__c, LinkedInID__c from Contacts) from Account where id in :accounts.keyset()];
    	
    	Map<ID, SocialInfo> results = new Map<ID, SocialInfo>();
    	
    	for(Account act: accountdata)
    	{
    		SocialInfo accountresult = new SocialInfo();
    		for(Contact ct: act.Contacts)
    		{
    			Boolean anyfound = false;
    			
    			if(ct.TwitterID__c!=null) 
    			{
    				anyfound = true;
    				accountresult.Twitters++;
    			}
    			if(ct.FacebookID__c!=null) 
    			{
    				anyfound = true;
    				accountresult.Facebooks++;
    			}
    			if(ct.LinkedInID__c!=null) 
    			{
    				anyfound = true;
    				accountresult.Linkedins++;
    			}
    			if(ct.TwitterID__c !=null && ct.LinkedInID__c!=null) 
    			{
    				anyfound = true;
    				accountresult.TwitterPlusLinkedins++;
    			}
    			if(ct.FacebookID__c !=null && ct.LinkedInID__c!=null) 
    			{
    				anyfound = true;
    				accountresult.FacebookPlusLinkedins++;
    			}
    			if(ct.TwitterID__c !=null && ct.FacebookID__c!=null) 
    			{
    				anyfound = true;
    				accountresult.TwitterPlusFacebooks++;
    			}
    			if(ct.TwitterID__c !=null && ct.FacebookID__c!=null && ct.LinkedInID__c!=null) 
    			{
    				anyfound = true;
    				accountresult.AllThree++;
    			}
    			if(!anyfound) accountresult.none++;

    		}
    		results.put(act.id, accountresult);
        }

        Long elapsedTime = DateTime.now().getTime() - startTime;
        Integer elapsedCPUTime = Limits.getCpuTime() - startCPUTime;
        system.debug(LoggingLevel.Error, 'Total elapsed time: ' + elapsedTime + 'ms');
        system.debug(LoggingLevel.Error, 'Total CPU time: ' + elapsedCPUTime + 'ms');

        return results;

    }

 
    // Aggregate based search 1
    public static Map<ID,SocialInfo> SoqlBasedTest1(Map<ID, Account> accounts)
    {
        // Mark start time
        Long startTime = DateTime.Now().getTime();
        Integer startCPUTime = Limits.getCpuTime();

    	// Get a list of contacts for each account
    	
    	List<AggregateResult> totals = 
    		[Select count(TwitterID__c) twits, count(FacebookID__c) likes, 
    		count(LinkedInID__c) links, AccountID from Contact 
    		where AccountID in :accounts.keyset() Group By AccountID];
    	
    	Map<ID, SocialInfo> results = new Map<ID, SocialInfo>();
    	
    	for(AggregateResult ar : totals)
    	{
			SocialInfo accountresult = new SocialInfo();
			results.put((ID)ar.get('AccountID'), accountresult);
 			accountresult.Twitters+= (Integer)ar.get('twits');
 			accountresult.Facebooks+= (Integer)ar.get('likes');
 			accountresult.Linkedins+= (Integer)ar.get('links');
    	}

		totals = [Select AccountID, count(TwitterID__c) both 
		from Contact where FaceBookID__c != null And 
		AccountID in :accounts.keyset() Group By AccountID];
		
		
    	for(AggregateResult ar : totals)
    	{
    		ID accountid = (ID)ar.get('AccountID');
			SocialInfo accountresult = results.get(accountid);
			if(accountresult == null)
			{
				accountresult = new SocialInfo();
				results.put(accountid, accountresult);
			}
			results.put((ID)ar.get('AccountID'), accountresult);
 			accountresult.TwitterPlusFacebooks+= (Integer)ar.get('both');
    	}

		totals = [Select AccountID, count(TwitterID__c) both from Contact where LinkedInID__c != null And  AccountID in :accounts.keyset() Group By AccountID];
    	for(AggregateResult ar : totals)
    	{
    		ID accountid = (ID)ar.get('AccountID');
			SocialInfo accountresult = results.get(accountid);
			if(accountresult == null)
			{
				accountresult = new SocialInfo();
				results.put(accountid, accountresult);
			}
			results.put((ID)ar.get('AccountID'), accountresult);
 			accountresult.TwitterPlusLinkedins+= (Integer)ar.get('both');
    	}
    	
		totals = [Select AccountID, count(FacebookID__c) both from Contact where LinkedInID__c != null And  AccountID in :accounts.keyset() Group By AccountID];
    	for(AggregateResult ar : totals)
    	{
    		ID accountid = (ID)ar.get('AccountID');
			SocialInfo accountresult = results.get(accountid);
			if(accountresult == null)
			{
				accountresult = new SocialInfo();
				results.put(accountid, accountresult);
			}
			results.put((ID)ar.get('AccountID'), accountresult);
 			accountresult.FacebookPlusLinkedins+= (Integer)ar.get('both');
    	}

		totals = [Select AccountID, count(FacebookID__c) both from Contact where LinkedInID__c != null And TwitterID__c!=null And  AccountID in :accounts.keyset() Group By AccountID];
    	for(AggregateResult ar : totals)
    	{
    		ID accountid = (ID)ar.get('AccountID');
			SocialInfo accountresult = results.get(accountid);
			if(accountresult == null)
			{
				accountresult = new SocialInfo();
				results.put(accountid, accountresult);
			}
			results.put((ID)ar.get('AccountID'), accountresult);
 			accountresult.AllThree+= (Integer)ar.get('both');
    	}

		List<Account> unsocial = [Select ID, (Select ID from contacts where FacebookID__c = null And TwitterID__c = null And LinkedInID__c = null) from Account where ID in :accounts.keyset()];
    	For(Account act: unsocial)
    	{
			SocialInfo accountresult = results.get(act.id);
			if(accountresult == null)
			{
				accountresult = new SocialInfo();
				results.put(act.id, accountresult);
			}
 			accountresult.None+= act.Contacts.size();
    	}
    	
        Long elapsedTime = DateTime.now().getTime() - startTime;
        Integer elapsedCPUTime = Limits.getCpuTime() - startCPUTime;
        system.debug(LoggingLevel.Error, 'Total elapsed time: ' + elapsedTime + 'ms');
        system.debug(LoggingLevel.Error, 'Total CPU time: ' + elapsedCPUTime + 'ms');

        return results;

    }  

    // Aggregate based search with custom fields
    public static Map<ID,SocialInfo> SoqlBasedTest2(Map<Id, Account> accounts)
    {

        // Mark start time
        Long startTime = DateTime.Now().getTime();
        Integer startCPUTime = Limits.getCpuTime();
		
    	List<AggregateResult> totals = [Select count(TwitterID__c) twits, 
    		count(FacebookID__c) likes, count(LinkedInID__c) links, 
    		sum(LinksAndLikes__c) linksandlikes, 
    		sum(TwitsAndLikes__c) twitsandlikes, 
    		sum(TwitsAndLinks__c) twitsandlinks, 
    		sum(AllThreeNetworks__c) allthree, 
    		sum(AntiSocial__c) antisocial, 
    		AccountID from Contact 
    		where AccountID in :accounts.keyset() Group By AccountID];
    	
    	Map<ID, SocialInfo> results = new Map<ID, SocialInfo>();
    	
    	for(AggregateResult ar : totals)
    	{
			SocialInfo accountresult = new SocialInfo();
			results.put((ID)ar.get('AccountID'), accountresult);
 			accountresult.Twitters+= (Integer)ar.get('twits');
 			accountresult.Facebooks+= (Integer)ar.get('likes');
 			accountresult.Linkedins+= (Integer)ar.get('links');

 			accountresult.TwitterPlusFacebooks+= Integer.ValueOf(ar.get('twitsandlikes'));
 			accountresult.TwitterPlusLinkedIns+= Integer.ValueOf(ar.get('twitsandlinks'));
 			accountresult.FacebookPlusLinkedins+= Integer.ValueOf(ar.get('linksandlikes'));
 			accountresult.AllThree+= Integer.ValueOf(ar.get('allthree'));
 			accountresult.None+= Integer.ValueOf(ar.get('antisocial'));
    	}

		Long elapsedTime = DateTime.now().getTime() - startTime;
        Integer elapsedCPUTime = Limits.getCpuTime() - startCPUTime;
        system.debug(LoggingLevel.Error, 'Total elapsed time: ' + elapsedTime + 'ms');
        system.debug(LoggingLevel.Error, 'Total CPU time: ' + elapsedCPUTime + 'ms');

 
    	return results;

    }   

    // ContactGroupsPerAccount has 8 permutations for each one. So 40 contacts would be 5 ContactGroupsPerAccount
    public static void initTestData(Integer accountCount, Integer ContactGroupsPerAccount)
    {
    	List<Account> socialaccounts = initTestAccounts('actci', accountCount);
    	insert socialaccounts;
    	List<Contact> socialcontacts = initTestSocialContacts('ctci', accountCount * ContactGroupsPerAccount * 8);
   		for(Integer actx = 0; actx < accountCount; actx++)
   		{
   			for(Integer x = 0; x < ContactGroupsPerAccount * 8; x++)
   			{
   				socialcontacts[actx * ContactGroupsPerAccount * 8 + x].AccountID = socialaccounts[actx].id;
   			}
   		}
   		insert socialcontacts;
    }
    
    public static List<Account> initTestAccounts(String prefix, Integer count)
	{
		List<Account> accounts = new List<Account>();
		for(Integer x=1; x<count + 1; x++)
		{
	 		accounts.add(new Account(Name= prefix + '_' + String.valueOf(x)));    
		}
		return accounts;
	}
	
	public static List<Contact> initTestSocialContacts(String prefix, Integer count)
	{

        List<Contact> results = new List<Contact>();
        for(Integer x = 0; x<count; x++)
        {
            results.add(new Contact(LastName = prefix + '_' + string.valueOf(x),
                                    email = prefix + '_' + string.valueOf(x) + '@apex4devs.com'));
        }
		for(Integer x = 0; x< results.size(); x++)
		{
			if((x & 1) == 1) results[x].TwitterID__c = '@' + prefix + '_' + string.ValueOf(x);
			if((x & 2) == 2) results[x].FaceBookID__c = prefix + 'FB_' + string.ValueOf(x);
			if((x & 4) == 4) results[x].LinkedInID__c = prefix + 'LI_' + string.ValueOf(x);
		}
		return results;
	}        
}