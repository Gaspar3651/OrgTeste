@isTest
public with sharing class AnimalLocatorTest {
    @isTest
    static void testandoAnimalLocator() {
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
        Test.startTest();
            String retorno = AnimalLocator.getAnimalNameById(1);
        Test.stopTest();
        System.assertEquals('name', retorno);
    }
}