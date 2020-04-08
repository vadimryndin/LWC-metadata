trigger ShowMetadataTrigger on ShowMetadata__c (before insert) {

    if(Trigger.isBefore) {
        ShowMetadataTriggerHelper.ShowMetadataTriggerHelper(trigger.new);
    }
    

}