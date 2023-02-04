trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    List<Task> tsk = new List<Task>();

    for (Opportunity opp: Trigger.New) {
        if (opp.StageName == 'Closed Won') {
            Task tt = new Task();
            tt.Subject = 'Follow Up Test Task';
            tt.WhatId = opp.Id;

            tsk.add(tt);
        }
    }
    
    if(tsk.size() > 0){
        insert tsk;
    }
}