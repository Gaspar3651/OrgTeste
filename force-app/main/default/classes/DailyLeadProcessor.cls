public class DailyLeadProcessor implements Schedulable{
    public void execute(SchedulableContext ctx) {
        List<Lead> listLead = [SELECT Id, LeadSource FROM Lead WHERE LeadSource = null LIMIT 200];

        for(Lead item: listLead){
            item.LeadSource = 'Dreamforce';
        }

        update listLead;
    }
}