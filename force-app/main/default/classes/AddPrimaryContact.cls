public class AddPrimaryContact implements Queueable {
    private Contact contato;
    private String estado;
    public AddPrimaryContact(Contact ctt, String state) {
        this.contato = ctt;
        this.estado = state;
    }

    public void execute(QueueableContext context){
        List<Account> listAcc = [SELECT Id, BillingState, (SELECT Id, AccountId FROM Contacts) FROM Account WHERE BillingState = :this.estado LIMIT 200];
        List<Contact> listCtt = new List<Contact>();

        for(Account acc: listAcc){
            Contact ctt = contato.clone();
            ctt.AccountId = acc.Id;
            listCtt.add(ctt);
        }
        
        insert listCtt;
    }
}