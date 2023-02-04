trigger AccountAddressTrigger on Account ( before insert, before update) {
    for (Account i: Trigger.new) {
        if (i.Match_Billing_Address__c) {
            i.ShippingPostalCode = i.BillingPostalCode;
        }
    }
}