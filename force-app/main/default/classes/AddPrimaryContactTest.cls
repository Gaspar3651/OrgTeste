@isTest
public with sharing class AddPrimaryContactTest {
    @isTest
    public static void Main() {
        List<Account> listaAcc = new List<Account>();
        for(Integer i = 0; i < 100; i++){
            Account acc = new Account();
            acc.Name = 'BATATA';
            if(i<50){
                acc.BillingState = 'AC';
            }else{
                acc.BillingState = 'NY';
            }
            
            listaAcc.add(acc);
        }
        insert listaAcc;

        Contact ctt = new Contact();
        ctt.LastName = 'Batata Frita';
        insert ctt;

        Test.StartTest();
            AddPrimaryContact addPc = new AddPrimaryContact(ctt, 'AC');
            System.enqueueJob(addPc);

            System.AssertEquals(50, [SELECT count() FROM Account WHERE BillingState = 'AC']);
        Test.StopTest();        
    }
}