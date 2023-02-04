@isTest
public class TestRestrictContactByName {
	@isTest
    public static void TestLastNameError(){
        Contact ctt = new Contact();
        ctt.LastName = 'Batata';
        insert(ctt);
        
        Contact ctt2 = new Contact();
        ctt2.LastName = 'INVALIDNAME';
        insert(ctt2);
    }
}