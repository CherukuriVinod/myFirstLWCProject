public with sharing class ProgramFlowExperiment {

    public static Integer EmailCounter = 0;

    private void SendEmail()
    {
        EmailCounter++;
        System.debug('Queuing email to send');
    }

    private void SendQueuedEmails()
    {
        System.debug('Sending Email Queue');
    }

    private static Set<ID> alreadyProcessedList = null;

    public void HandleContactUpdateTrigger1(List<contact> newList, Map<ID, Contact> oldMap)
    {
        if(alreadyProcessedList==null) alreadyProcessedList = new Set<ID>();

        for(Contact ct: newList)
        {
            if(alreadyProcessedList.contains(ct.id)) continue;
            if(ct.OwnerId != oldMap.get(ct.id).OwnerId)
            {
                alreadyProcessedList.add(ct.id);
                SendEmail();
            }
        }
        SendQueuedEmails();
    }

    // This is the original version of the HandleContactUpdateTrigger function before
    // adding reentrancy detection
    public void HandleContactUpdateTriggerOriginal(List<contact> newList, Map<ID, Contact> oldMap)
    {
        for(Contact ct: newList)
        {
            if(ct.OwnerId != oldMap.get(ct.id).OwnerId)
            {
                SendEmail();
            }
        }
        SendQueuedEmails();
    }
}

//This class will be called during the after update trigger on the Contact to detect when the owner of the Contact has changed.
//the idea is to send out an email every time the Contact's owner changes