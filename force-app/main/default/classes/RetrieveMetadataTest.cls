@isTest
public with sharing class RetrieveMetadataTest {
    @isTest
    public static void retrieveMetadataTest() {
        final  String objectApiName = 'Contact';
        final  String objectApiName1 = 'Case';
        final  String layoutName = 'Contact-Contact Layout';

        RetriveMetadata.retriveMetadata(objectApiName, layoutName); 

        System.assertEquals(23, [SELECT Id FROM ShowMetadata__c].size());

        RetriveMetadata.retriveMetadata(objectApiName1, layoutName); 

        System.assertEquals(5, [SELECT Id FROM ShowMetadata__c].size());
        

    }
}
