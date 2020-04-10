public with sharing class RetriveMetadata {
    @AuraEnabled
    public static List<WrapperObject> retriveMetadata(String objectApiName, String layoutName) {

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

        List<WrapperObject> listWrapObjFieldsFromObj = new List<WrapperObject>(); 

        for (String fieldName : fieldMap.keySet()) {

            Schema.DescribeFieldResult dfr = fieldMap.get(fieldName).getDescribe();  

            WrapperObject wrapObj = new WrapperObject(dfr.getName(), dfr.getLabel(), dfr.getType(), 
                dfr.isAccessible(), dfr.isCreateable(), dfr.isUpdateable()); 

            listWrapObjFieldsFromObj.add(wrapObj);  
        }
        System.debug('****fieldsFromObj: ' + listWrapObjFieldsFromObj);

        // Data for insert to Object
        Map<String, WrapperObject> mapToInsert = new Map<String, WrapperObject>();
        List<String> values = new List<String>();
        System.debug('************fieldsFromLayout size: ' + layoutItemfieldsFromLayout.size());
        System.debug('************listWrapObjFieldsFromObj size: ' + listWrapObjFieldsFromObj.size());


        for(String strVar : layoutItemfieldsFromLayout){
            
            for(WrapperObject wrapObjVar : listWrapObjFieldsFromObj){
                if(strVar == wrapObjVar.name) {
                    mapToInsert.put(strVar, wrapObjVar);
                }
            }
        }   
        
        System.debug('****mapToInsert: ' + mapToInsert);
        System.debug('************mapToInsert size: ' + mapToInsert.size());

        List<ShowMetadata__c> listToInsert = new List<ShowMetadata__c>();

        for(WrapperObject wrObjVar :  mapToInsert.values()) {

            ShowMetadata__c objToInsert = new ShowMetadata__c();

            objToInsert.Layout_Field__c = wrObjVar.name;
            objToInsert.ObjectName__c = wrObjVar.name;
            objToInsert.ObjectLabel__c = wrObjVar.label;
            objToInsert.Object_Type__c = String.valueOf(wrObjVar.type);
            objToInsert.Object_Is_Accessible__c = String.valueOf(wrObjVar.isAccessible);
            objToInsert.Object_is_Createable__c = String.valueOf(wrObjVar.isCreateable);
            objToInsert.Object_Is_Updateable__c = String.valueOf(wrObjVar.isUpdateable);
            objToInsert.Insert_Now__c = true; 

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
        List<ShowMetadata__c> MdtToReturn = addDataToLWC.getData();
        List<WrapperObject> dataToReturn = new List<WrapperObject>();

        for(ShowMetadata__c var : MdtToReturn) {
            dataToReturn.add(new WrapperObject(var.Id, var.Layout_Field__c, var.ObjectName__c, var.ObjectLabel__c, var.Object_Type__c,
                var.Object_Is_Accessible__c, var.Object_is_Createable__c, var.Object_Is_Updateable__c));
        }

        System.debug('*************RETURN MdtToReturn----: ' + MdtToReturn.size());
        System.debug('*************RETURN MdtToReturn----: ' + MdtToReturn);
        System.debug('*************RETURN DATA----: ' + dataToReturn.size());
        System.debug('*************RETURN DATA----: ' + dataToReturn);

        return dataToReturn;
    }

        public class WrapperObject {
            public String layoutFIeld;
            public String name;
            public String label;
            public Schema.DisplayType type;
            public Boolean isAccessible;
            public Boolean isCreateable;
            public Boolean isUpdateable;
            public Boolean isInsert;
            public String typeMdt;
            public String isAccessibleMdt;
            public String isCreateableMdt;
            public String isUpdateableMdt;
            public Id id;

            public WrapperObject (String name, String label, Schema.DisplayType type, 
                Boolean isAccessible, Boolean isCreateable, Boolean isUpdateable) {
                    this.name = name;
                    this.label = label;
                    this.type = type;
                    this.isAccessible = isAccessible;
                    this.isCreateable = isCreateable;
                    this.isUpdateable = isUpdateable;
            }

            public WrapperObject (Id id, String layoutFIeld, String name, String label, String typeMdt, 
                String isAccessibleMdt, String isCreateableMdt, String isUpdateableMdt) {
                    this.id = id;
                    this.layoutFIeld = layoutFIeld;
                    this.name = name;
                    this.label = label;
                    this.typeMdt = typeMdt;
                    this.isAccessibleMdt = isAccessibleMdt;
                    this.isCreateableMdt = isCreateableMdt;
                    this.isUpdateableMdt = isUpdateableMdt;
                    
            }
        }
}
