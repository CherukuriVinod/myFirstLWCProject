trigger ContactOwnerChangeTrigger on Contact (after update) {
    ProgramFlowExperiment pf = new ProgramFlowExperiment();
    pf.HandleContactUpdateTrigger1(trigger.new, trigger.oldMap);
}