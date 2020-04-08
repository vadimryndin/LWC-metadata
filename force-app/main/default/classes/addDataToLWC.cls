public with sharing class addDataToLWC {
    @AuraEnabled(cacheable=true)
    public static List<ShowMetadata__c> getData() {

        List<ShowMetadata__c> test = [SELECT Id FROM ShowMetadata__c WHERE Insert_Now__c = true];

            System.debug('*************RETURN Id: ' + test.size());



        return [SELECT Layout_Field__c, ObjectName__c, ObjectLabel__c, 
            Object_Type__c, Object_Is_Accessible__c, Object_is_Createable__c, Object_Is_Updateable__c 
            FROM ShowMetadata__c WHERE Insert_Now__c = true]; 

            
    /*    List<String> dataToLWC = new List<String>();

        for(ShowMetadata__c objVar : ShowMetadataAfterInsert) {
            String info = 'Layout Field' + ' : ' +  objVar.Layout_Field__c + ' , ' +
                'Object Name' + ' : ' +  objVar.ObjectName__c + ' , ' +
                'Object Label' + ' : ' +  objVar.ObjectLabel__c + ' , ' +
                'Object Type' + ' : ' +  objVar.Object_Type__c + ' , ' +
                'Object Is Accessible' + ' : ' +  objVar.Object_Is_Accessible__c + ' , ' +
                'Object Is Createable' + ' : ' +  objVar.Object_is_Createable__c + ' , ' +
                'Object Is Updateable' + ' : ' +  objVar.Object_Is_Updateable__c + '.  ';

            dataToLWC.add(info);
        }  
    */
    }
}
