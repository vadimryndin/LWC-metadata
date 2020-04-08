public with sharing class ShowMetadataTriggerHelper {
    public static void ShowMetadataTriggerHelper(List<ShowMetadata__c> ListShowMetadata) {

        System.debug('******************** ListShowMetadata: ' + ListShowMetadata);
        System.debug('******************** ListShowMetadata size: ' + ListShowMetadata.size());
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
   
        System.debug('******************** Trigger end *******' );
    }
}
