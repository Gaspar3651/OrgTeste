@isTest
public class DailyLeadProcessorTest {
    @isTest
    public static void DailyLeadProcessorTest() {
        List<Lead> listLead = new List<Lead>();

        for(Integer i = 0; i<200; i++){
            Lead ld = new Lead();
            ld.LastName = 'Testando';
            ld.LeadSource = null;
            ld.Company = 'Batata';

            listLead.add(ld);
        }
        insert listLead;

        Test.startTest();
            DailyLeadProcessor dlp = new DailyLeadProcessor();
            String jobId = System.schedule('Testando Schedule', '0 55 * * * ? *', dlp);

        Test.stopTest();
        
        System.AssertEquals(200, [SELECT count() FROM Lead WHERE LeadSource = 'Dreamforce']);
    }
}