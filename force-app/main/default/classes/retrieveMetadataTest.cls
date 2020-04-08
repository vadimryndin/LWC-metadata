@isTest
public with sharing class retrieveMetadataTest {
    @isTest
    public static void retrieveMetadataTest() {
        final  String objectApiName = 'Contact';
        final  String objectApiName1 = 'Case';
        final  String layoutName = 'Contact-Contact Layout';

        retrieveMetadata.retrieveMetadata(objectApiName, layoutName); 

        System.assertEquals(23, [SELECT Id FROM ShowMetadata__c].size());

        retrieveMetadata.retrieveMetadata(objectApiName1, layoutName); 

        System.assertEquals(5, [SELECT Id FROM ShowMetadata__c].size());
        

    }
}
