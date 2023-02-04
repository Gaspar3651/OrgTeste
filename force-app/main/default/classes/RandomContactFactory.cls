public class RandomContactFactory {
    public static List<Contact> generateRandomContacts(Integer numContact, String lastNameContact){
        List<Contact> ctt = new List<Contact>();
        for(Integer i=1; i<=numContact; i++){
            Contact ctt1 = new Contact();
            ctt1.FirstName = 'Test ' + i;
            ctt1.LastName = lastNameContact;
            System.debug(ctt1);
            ctt.add(ctt1);
        }
        return ctt;
    }
}