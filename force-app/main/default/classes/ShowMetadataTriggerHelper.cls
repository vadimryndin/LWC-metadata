public with sharing class ShowMetadataTriggerHelper {
    public static void ShowMetadataTriggerHelper(List<ShowMetadata__c> ListShowMetadata) {

        List<ShowMetadata__c> fromPreviousInsert = [SELECT Insert_Now__c FROM ShowMetadata__c
            WHERE Insert_Now__c = true];

        if(!fromPreviousInsert.isEmpty()) {

            Database.DeleteResult[] drList1 = Database.delete(fromPreviousInsert, false);
            // Iterate through each returned result
            for(Database.DeleteResult dr : drList1) {
                if (dr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully deleted Objects with ID: ' + dr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : dr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }

        List<ShowMetadata__c> insertNow = [SELECT Id FROM ShowMetadata__c WHERE Id IN : ListShowMetadata];
        
        for(ShowMetadata__c var : insertNow) {
            var.Insert_Now__c = true;
            insertNow.add(var);
        }

        try {
            update insertNow;
        }
        catch(DmlException e) {
            System.debug(e.getMessage());
        }
        System.debug('******************** insertNow size: ' + insertNow.size());
        System.debug('******************** insertNow: ' + insertNow);
        

        List<ShowMetadata__c> ShowMetadataAfterInsert = [SELECT Layout_Field__c, ObjectName__c, ObjectLabel__c, 
            Object_Type__c, Object_Is_Accessible__c, Object_is_Createable__c, Object_Is_Updateable__c 
            FROM ShowMetadata__c WHERE Id IN : ListShowMetadata]; 
            
        List<String> dataToLWC = new List<String>();

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
        System.debug('************//////**** dataToLWC: ' + dataToLWC);

    }
}
