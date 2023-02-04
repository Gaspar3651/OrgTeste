@isTest
public class TestVerifyDate {
	@isTest
    public static void CheckDatesTest(){
        String dt1 = '2008-10-05 12:20:20';
        String dt2 = '2008-10-20 12:20:20';
        String dt3 = '2008-09-25 12:20:20';
        Date data1 = date.valueOf(dt1);
        Date data2 = date.valueOf(dt2);
        Date data3 = date.valueOf(dt3);
        
        Date result = VerifyDate.CheckDates(data1, data2);
        System.assertEquals(data2, result);
        
        Date result2 = VerifyDate.CheckDates(data1, data3); 
        System.assertEquals(data1, result2);
    }
}