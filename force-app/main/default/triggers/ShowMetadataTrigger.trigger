trigger ShowMetadataTrigger on ShowMetadata__c (after insert) {

    if(Trigger.isAfter) {
        ShowMetadataTriggerHelper.ShowMetadataTriggerHelper(trigger.new);
    }
    

}