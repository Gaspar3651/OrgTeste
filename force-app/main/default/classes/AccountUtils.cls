public with sharing class AccountUtils {
    public static List<Account> accountsByState(String state) {
        List<Account> listReturn = [SELECT Id, Name FROM Account WHERE BillingState = :state];
        return listReturn;
    }
}