@isTest
public with sharing class addDataToLWCTest {
    @isTest
    public static void addDataToLWCTest() {

        List<ShowMetadata__c> testList = new List<ShowMetadata__c>();
        ShowMetadata__c testObj1 = new ShowMetadata__c();
        ShowMetadata__c testObj2 = new ShowMetadata__c();
        testList.add(testObj1);
        testList.add(testObj2);
        insert testList;

        System.assertEquals(2, [SELECT Id FROM ShowMetadata__c WHERE Insert_Now__c = true].size());

        ShowMetadata__c testObj3 = new ShowMetadata__c();
        insert testObj3;

        System.assertEquals(1, [SELECT Id FROM ShowMetadata__c WHERE Insert_Now__c = true].size());

        addDataToLWC.getData();
        System.assertEquals(1, [SELECT Id FROM ShowMetadata__c WHERE Insert_Now__c = true].size());

    }
}
