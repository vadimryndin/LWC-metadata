public with sharing class retrieveMetadata {
    @AuraEnabled(cacheable=true)
    public static void retrieveMetadata(String objectApiName, String layoutName) {

        List<String> layoutNameList = new List<String>{layoutName};
        List<String> layoutSectionsFromLayout = new List<String>();
        List<String> layoutItemfieldsFromLayout = new List<String>();

        System.debug('List<String> layoutNameList: ' + layoutNameList);
        System.debug('String layoutName: ' + layoutName);
        System.debug('String objectApiName: ' + objectApiName);

        // get fields from Layout
        List<Metadata.Metadata> layouts = 
            Metadata.Operations.retrieve(Metadata.MetadataType.Layout, 
            layoutNameList);

        Metadata.Layout layoutFromLwc = (Metadata.Layout) layouts.get(0);
        System.debug(layoutFromLwc);
        
        for(Metadata.Metadata layout : layouts) {
            System.debug('The layouts are:'+ layout.fullname);        
        }

        for (Metadata.LayoutSection section : layoutFromLwc.layoutSections) {
            System.debug('LayoutSection: ' + section.label);
            layoutSectionsFromLayout.add(section.label);

            for (Metadata.LayoutColumn column : section.layoutColumns) {
                if (column.layoutItems != null) {

                    for (Metadata.LayoutItem item : column.layoutItems) {
                        System.debug('LayoutItem: ' + item.field);
                        layoutItemfieldsFromLayout.add(item.field);
                    }
                }
            }
        }
         System.debug('layoutSectionsFromLayout: ' + layoutSectionsFromLayout);
         System.debug('layoutItemfieldsFromLayout: ' + layoutItemfieldsFromLayout);

        // get fields from Object
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe()
            .get(objectApiName)
            .getDescribe()
            .fields
            .getMap();
        System.debug('Fields: ' + fieldMap);

        if(!fieldMap.isEmpty()) {
            List<Schema.SObjectField> objFields = fieldMap.values();
            System.debug(objFields);
                
            Set<String> objFields1 = fieldMap.keySet();
            System.debug(objFields1);
        }
    }
/*
    @AuraEnabled(cacheable=true)
    public static List<Contact> findContacts(String searchKey) {
        String key = '%' + searchKey + '%';
        return [
            SELECT Id, Name, Title, Phone, Email, Picture__c
            FROM Contact
            WHERE Name LIKE :key AND Picture__c != null
            WITH SECURITY_ENFORCED
            LIMIT 10
        ];
    }
*/    
}
