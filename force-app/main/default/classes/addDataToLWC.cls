public with sharing class addDataToLWC {
    @AuraEnabled(cacheable=true)
    public static List<ShowMetadata__c> getData() {

        return [SELECT Layout_Field__c, ObjectName__c, ObjectLabel__c, Object_Type__c, 
            Object_Is_Accessible__c, Object_is_Createable__c, Object_Is_Updateable__c 
            FROM ShowMetadata__c WHERE Insert_Now__c = true]; 
    }
}
