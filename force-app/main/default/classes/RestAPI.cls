// REST API INTERNO
// PARA FAZER UM GET OU POST COM INFORMAÇÕES DENTRO DO SALESFORCE
/* 
    ENDPOINT PADRÃO: https://suaInstância.my.salesforce.com/services/apexrest/
    ENDPOINT DESTA ORG: https://brave-narwhal-nmq6k3-dev-ed.my.salesforce.com/services/apexrest/Convert/Lead/*
*/

@RestResource(urlMapping='/ConvertLead/*')
global with sharing class RestAPI {
    @HttpPatch
    global static RestAPIBody.rest convertLead(RestAPIBody leadId){
        RestResponse resultRest = RestContext.response;
        Lead leadConvert = [SELECT Id FROM Lead WHERE Id = :leadId.leadId];
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(leadConvert.id);

        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        lc.setDoNotCreateOpportunity(false);

        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());


        Lead leadConverted = [SELECT Id, ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId FROM Lead WHERE Id = :leadId.leadId];

        RestAPIBody.rest retorno = new RestAPIBody.rest();
        retorno.AccountId = leadConverted.ConvertedAccountId;
        retorno.ContactId = leadConverted.ConvertedContactId;
        retorno.OpportunityId = leadConverted.ConvertedOpportunityId;

        // Map<String, Id> retorno = new Map<String, Id>();
        // retorno.put('AccountId', leadConverted.ConvertedAccountId);
        // retorno.put('ContactId', leadConverted.ConvertedContactId);
        // retorno.put('OpportunityId', leadConverted.ConvertedOpportunityId);

        resultRest.responseBody = Blob.valueOf(JSON.serialize(retorno));
        resultRest.statusCode = 200;

        return retorno;
    }
}