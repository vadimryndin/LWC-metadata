public with sharing class ShowMetadataTriggerHelper {
    public static void ShowMetadataTriggerHelper(List<ShowMetadata__c> ListShowMetadata) {

        List<ShowMetadata__c> ShowMetadataAfterInsert = [SELECT Layout_Field__c, ObjectName__c, ObjectLabel__c, 
            Object_Type__c, Object_Is_Accessible__c, Object_Is_Updateable__c 
            FROM ShowMetadata__c WHERE Id IN : ListShowMetadata]; 
            
        List<String> dataToLWC = new List<String>();

        for(ShowMetadata__c objVar : ShowMetadataAfterInsert) {
            String info = 'Layout Field' + ' : ' +  objVar.Layout_Field__c + ' , ' +
                'Object Name' + ' : ' +  objVar.ObjectName__c + ' , ' +
                'Object Label' + ' : ' +  objVar.ObjectLabel__c + ' , ' +
                'Object Type' + ' : ' +  objVar.Object_Type__c + ' , ' +
                'Object Is Accessible' + ' : ' +  objVar.Object_Is_Accessible__c + ' , ' +
                'Object Is Updateable' + ' : ' +  objVar.Object_Is_Updateable__c + '.  ';

            dataToLWC.add(info);
        }  
        System.debug('************//////**** dataToLWC: ' + dataToLWC);

    }
}
