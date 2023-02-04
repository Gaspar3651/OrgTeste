public with sharing class AccountTriggerHandler {
    public static void CreateAccounts(List<Account> listaAccount) {
        for (Account item: listaAccount) {
            if(item.ShippingState != item.BillingState){
                item.ShippingState = item.BillingState;
            }
        }
    }
}