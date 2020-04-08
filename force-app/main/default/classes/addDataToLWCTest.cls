@isTest
public with sharing class addDataToLWCTest {
    @isTest
    public static void addDataToLWCTest() {

        ShowMetadata__c testObj1 = new ShowMetadata__c();
        ShowMetadata__c testObj2 = new ShowMetadata__c();
        insert testObj1;
        insert testObj1;

        System.assertEquals(2, [SELECT id FROM ShowMetadata__c WHERE Insert_Now__c = true].size());

        ShowMetadata__c testObj3 = new ShowMetadata__c();
        insert testObj3;

        System.assertEquals(1, [SELECT id FROM ShowMetadata__c WHERE Insert_Now__c = true].size());

    }
}
