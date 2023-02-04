@isTest
public with sharing class LeadProcessorTest {
    @isTest
    public static void  LeadProcessorTest() {
        List<Lead> listLead = new List<Lead>();

        for(Integer i = 0; i < 200; i++){
            Lead ldd = new Lead();
            ldd.LastName = 'Batata';
            ldd.LeadSource = ('Teste' + i);
            ldd.Company = 'Testando';

            listLead.add(ldd);
        }
        insert listLead;

        test.startTest();
            LeadProcessor uca = new LeadProcessor();
            Database.executeBatch(uca);
        test.stopTest();
        System.AssertEquals(200, [SELECT count() FROM Lead WHERE LeadSource = 'Dreamforce']);
    }
}