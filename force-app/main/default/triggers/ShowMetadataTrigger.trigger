trigger ShowMetadataTrigger on ShowMetadata__c (after insert) {

    ShowMetadataTriggerHelper.ShowMetadataTriggerHelper(trigger.new);

}