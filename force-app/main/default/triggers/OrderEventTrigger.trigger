trigger OrderEventTrigger on Order_Event__e (after insert){
    System.debug('--------------->');
    List<Task> listTarefas = new List<Task>();

    // Iterate through each notification.
    for (Order_Event__e item : Trigger.New) {
        if (item.Has_Shipped__c  == true) {
            // Create Task to dispatch new team.
            Task tarefa = new Task(
                Priority = 'Medium',
                Subject = 'Follow up on shipped order 105',
                OwnerId = item.CreatedById
            );

            listTarefas.add(tarefa);
        }
   }
    System.debug('--------------->');

    // Insert all tasks corresponding to events received.
    insert listTarefas;
    System.debug('--------------->');
}