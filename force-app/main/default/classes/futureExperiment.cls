public with sharing class futureExperiment {

    //Created a static boolean variable this will track whether or not the future call has been made 
    private static Boolean futuresent = false;

    @future
    public static void test1() 
    {
        System.debug('in future call');
    }

    //Now created the function to call that will actually tell the system that we want to make a future call
    //First it checks to see whether a call has already been made? If so, the function exits immediately; otherwise it sets the flag to true and then makes the real future call 
    public static void test2(){
        if(futuresent)return;
        futuresent=true;
        test2future();
    }
    //Now created the future call itself 
    @future
    public static void test2future(){
        system.debug('in future call');
    }

    /* It's often a good idea to have both synchronous and asynchronous entry to whatever functionality you want to use. So rather than putting your functionality in the future call
     itself, create a mirror synchronous function and call that one from the future call. One of the current limitations of Apex is you cannot make a future call from a future or 
     Batch execution context. One common technique is to detect whether you're currently in a future or Batch operation, and if you are, go ahead and make the synchronous call.  
    */

    public static void test3(){
        if(system.isFuture() || system.isBatch())
        {
            test3sync();
            return;
        }
        if(futuresent)return;
        futuresent=true;
        test2future();
    }
    @future
    public static void test3future(){
        test3sync();
    }

    public static void test3sync()
    {
        System.debug('performing operation sync or async');
    }
}