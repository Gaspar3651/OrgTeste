@isTest
public class AccountProcessorTest {
    @isTest
    static void AccountProcessorTest() {
        Account acc1 = new Account(Name = 'Batata');
        Account acc2 = new Account(Name = 'Batata');
        Account acc3 = new Account(Name = 'Batata');
        insert acc1;
        insert acc2;
        insert acc3;

        List<Id> listAcc = new List<Id>();
        listAcc.add(acc1.Id);
        listAcc.add(acc2.Id);
        listAcc.add(acc3.Id);

        Test.startTest();
            AccountProcessor.countContacts(listAcc);
        Test.stopTest();
    }
}