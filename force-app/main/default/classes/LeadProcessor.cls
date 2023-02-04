public with sharing class LeadProcessor implements Database.Batchable<sObject>, Database.Stateful  {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Database.QueryLocator retorno = DataBase.getQueryLocator('SELECT Id, LeadSource FROM Lead WHERE LeadSource != \'Dreamforce\'');
        return retorno;
    }

    public void execute(Database.BatchableContext bc, List<Lead> scope){
        for (Lead ldd : scope) {
            ldd.LeadSource = 'Dreamforce';
        }
        update scope;
    }

    public void finish(Database.BatchableContext bc){

    }
}