@isTest
public with sharing class AnimalsCalloutsTest {
    @isTest
    static void testGetCallout(){
        Test.setMock(HttpCalloutMock.class, new GetAnimalsHttpCalloutMock());

        HttpResponse response = AnimalsCallouts.makeGetCallout();

        String retornoEsperado = '{"animals": ["majestic badger", "fluffy bunny", "scary bear", "chicken"]}';

        System.AssertEquals(retornoEsperado, response.getBody());
    }

    @isTest 
    static  void testPostCallout(){
        Test.setMock(HttpCalloutMock.class, new AnimalsHttpCalloutMock());

        HTTPResponse response = AnimalsCallouts.makePostCallout();

        String retornoEsperado = '{"animals": ["majestic badger", "fluffy bunny", "scary bear", "chicken", "mighty moose"]}';

        System.AssertEquals(retornoEsperado, response.getBody());
    }
}