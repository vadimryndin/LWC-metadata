public with sharing class retrieveMetadata {
    @AuraEnabled
    public static List<ShowMetadata__c> retrieveMetadata(String objectApiName, String layoutName) {

        List<String> layoutNameList = new List<String>{layoutName};
        List<String> layoutItemfieldsFromLayout = new List<String>();

        System.debug('******List<String> layoutNameList: ' + layoutNameList);
        System.debug('******String layoutName: ' + layoutName);
        System.debug('******String objectApiName: ' + objectApiName);

        // get fields from Layout
        List<Metadata.Metadata> layouts = 
            Metadata.Operations.retrieve(Metadata.MetadataType.Layout, layoutNameList);
        System.debug('*****layouts size: ' + layouts.size());

        Metadata.Layout layoutFromLwc = new Metadata.Layout();
        if(!layouts.isEmpty()) {
            layoutFromLwc = (Metadata.Layout) layouts.get(0);
            System.debug('*****layoutFromLwc: ' + layoutFromLwc);
        }
        
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
                        System.debug('****item.field: ' + item.field);
                    }
                }
            }
        }
        System.debug('****layoutItemfieldsFromLayout: ' + layoutItemfieldsFromLayout);

        // get fields from Object
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe()
            .get(objectApiName)
            .getDescribe()
            .fields
            .getMap();
        System.debug('****Fields: ' + fieldMap);

        Map<String, List<String>> fieldsFromObj = new Map<String, List<String>>();
        
        for (String fieldName : fieldMap.keySet()) {
            List<String> result = new List<String>();

            Schema.DescribeFieldResult dfr = fieldMap.get(fieldName).getDescribe();  
            String name = String.valueOf(dfr.getName());
            String label = String.valueOf(dfr.getLabel());
            String type = String.valueOf(dfr.getType());
            String isAccessible = String.valueOf(dfr.isAccessible());
            String isCreateable = String.valueOf(dfr.isCreateable());
            String isUpdateable = String.valueOf(dfr.isUpdateable());
            result.add(name);
            result.add(label);
            result.add(type);
            result.add(isAccessible);
            result.add(isCreateable);
            result.add(isUpdateable);
            
            fieldsFromObj.put(fieldName, result);
        }
        System.debug('****fieldsFromObj: ' + fieldsFromObj);

        // Data for insert to Object
        Map<String,List<String>> mapToInsert = new Map<String,List<String>>();
        List<String> values = new List<String>();
        System.debug('************fieldsFromLayout size: ' + layoutItemfieldsFromLayout.size());
        System.debug('************fieldsFromObj size: ' + fieldsFromObj.size());

        for(String strVar : layoutItemfieldsFromLayout) {
        //    if(strVar != null) {
                values = fieldsFromObj.get(strVar.toLowerCase());
                mapToInsert.put(strVar, values);
        //    }
        }
        System.debug('****mapToInsert: ' + mapToInsert);
        System.debug('************mapToInsert size: ' + mapToInsert.size());

        List<ShowMetadata__c> listToInsert = new List<ShowMetadata__c>();

        for(String keyVar :  mapToInsert.keySet()) {
            ShowMetadata__c objToInsert = new ShowMetadata__c();

        //    if(keyVar != null) {
                if(mapToInsert.get(keyVar) != null){
                    objToInsert.Layout_Field__c = keyVar;
                    objToInsert.ObjectName__c = mapToInsert.get(keyVar).get(0);
                    objToInsert.ObjectLabel__c = mapToInsert.get(keyVar).get(1);
                    objToInsert.Object_Type__c = mapToInsert.get(keyVar).get(2);
                    objToInsert.Object_Is_Accessible__c = mapToInsert.get(keyVar).get(3);
                    objToInsert.Object_is_Createable__c = mapToInsert.get(keyVar).get(4);
                    objToInsert.Object_Is_Updateable__c = mapToInsert.get(keyVar).get(5);
                    objToInsert.Insert_Now__c = true; 
        
                    listToInsert.add(objToInsert);
                }
        //    }
        }
            
        try {
            insert listToInsert;
        }
        catch(DmlException e) {
            System.debug(e.getMessage());
        }
        System.debug('******************** listToInsert size: ' + listToInsert.size());
        System.debug('******************** listToInsert: ' + listToInsert);
        // this 2 linse for debug only
        List<ShowMetadata__c> test = [SELECT Id FROM ShowMetadata__c WHERE Insert_Now__c = true];
        System.debug('*************RETURN Id----: ' + test.size());

        // fire return data to LWC
        List<ShowMetadata__c> dataToReturn = addDataToLWC.getData();
        System.debug('*************RETURN DATA----: ' + dataToReturn.size());
        return dataToReturn;
   
    }    
}
