public with sharing class retrieveMetadata {
    @AuraEnabled(cacheable=true)
    public static void retrieveMetadata(String objectApiName, String layoutName) {

        List<String> layoutNameList = new List<String>{layoutName};
        List<String> layoutItemfieldsFromLayout = new List<String>();

        System.debug('List<String> layoutNameList: ' + layoutNameList);
        System.debug('String layoutName: ' + layoutName);
        System.debug('String objectApiName: ' + objectApiName);

        // get fields from Layout
        List<Metadata.Metadata> layouts = 
            Metadata.Operations.retrieve(Metadata.MetadataType.Layout, layoutNameList);

        Metadata.Layout layoutFromLwc = (Metadata.Layout) layouts.get(0);
        System.debug(layoutFromLwc);
    /*    
        for(Metadata.Metadata layout : layouts) {
            System.debug('The layouts are:'+ layout.fullname);        
        }
    */
        for (Metadata.LayoutSection section : layoutFromLwc.layoutSections) {

            for (Metadata.LayoutColumn column : section.layoutColumns) {
                if (column.layoutItems != null) {

                    for (Metadata.LayoutItem item : column.layoutItems) {
                        layoutItemfieldsFromLayout.add(item.field);
                    }
                }
            }
        }
        System.debug('layoutItemfieldsFromLayout: ' + layoutItemfieldsFromLayout);

        // get fields from Object
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe()
            .get(objectApiName)
            .getDescribe()
            .fields
            .getMap();
        System.debug('Fields: ' + fieldMap);

        Map<String, List<String>> fieldsFromObj = new Map<String, List<String>>();
        
        for (String fieldName : fieldMap.keySet()) {
            List<String> result = new List<String>();
            String nameS = fieldMap.get(fieldName).getDescribe().getName();
            String labelS = fieldMap.get(fieldName).getDescribe().getLabel();
            String typeS = String.valueOf(fieldMap.get(fieldName).getDescribe().getType());
            String isAccessibleS = String.valueOf(fieldMap.get(fieldName).getDescribe().isAccessible());
            String isCreateableS = String.valueOf(fieldMap.get(fieldName).getDescribe().isCreateable());
            String isUpdateableS = String.valueOf(fieldMap.get(fieldName).getDescribe().isUpdateable());
            result.add(nameS);
            result.add(labelS);
            result.add(typeS);
            result.add(isAccessibleS);
            result.add(isCreateableS);
            result.add(isUpdateableS);
            
            fieldsFromObj.put(fieldName, result);
        }
        System.debug('fieldsFromObj: ' + fieldsFromObj);

        // Data for insert to Object
        Map<String,List<String>> mapToInsert = new Map<String,List<String>>();

        for(String strVar : layoutItemfieldsFromLayout) {
            List<String> values = fieldsFromObj.get(strVar.toLowerCase());
            mapToInsert.put(strVar, values);
        }
        System.debug('mapToInsert: ' + mapToInsert);

        System.debug('************mapToInsert size: ' + mapToInsert.size());
        System.debug('************fieldsFromLayout size: ' + layoutItemfieldsFromLayout.size());
        System.debug('************fieldsFromObj size: ' + fieldsFromObj.size());

        List<ShowMetadata__c> listToInsert = new List<ShowMetadata__c>();

        for(String keyVar :  mapToInsert.keySet()) {
            ShowMetadata__c objToInsert = new ShowMetadata__c();

            objToInsert.Layout_Field__c = keyVar;
            objToInsert.ObjectName__c = mapToInsert.get(keyVar).get(0);
            objToInsert.ObjectLabel__c = mapToInsert.get(keyVar).get(1);
            objToInsert.Object_Type__c = mapToInsert.get(keyVar).get(2);
            objToInsert.Object_Is_Accessible__c = mapToInsert.get(keyVar).get(3);
            objToInsert.Object_is_Createable__c = mapToInsert.get(keyVar).get(4);
            objToInsert.Object_Is_Updateable__c = mapToInsert.get(keyVar).get(5);

            listToInsert.add(objToInsert);
            }
            
        try {
            insert listToInsert;
        }
        catch(DmlException e) {
            System.debug(e.getMessage());
        }
        System.debug('******************** listToInsert size: ' + listToInsert.size());
        System.debug('******************** listToInsert: ' + listToInsert);

        // fire return data to LWC
        addDataToLWC.getData();
   
    }    
}
