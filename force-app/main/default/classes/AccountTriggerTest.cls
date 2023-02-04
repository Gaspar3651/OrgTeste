@isTest
public with sharing class AccountTriggerTest {
    @isTest
    static void makeData(){
        
        List<Account> listAcc = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            Account acc = new Account();
            acc.Name = 'Batata';
            acc.BillingState = 'CA';
            listAcc.add(acc);
        }
        test.StartTest();
            insert listAcc;
        test.StopTest();
        
        List<Account> acc = [SELECT ShippingState FROM Account];
        for(Account item: acc){
            System.assertEquals('CA', item.ShippingState);
        }
        
        System.AssertEquals(200, [SELECT count() FROM Account WHERE ShippingState = 'CA']);
    }
}