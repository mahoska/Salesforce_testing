public without sharing class  CheckAccessRight {

    public static Boolean getwrapAccountListCRUDAccessAccessible(){
        Schema.DescribeSObjectResult wrapAccountList = Account.sObjectType.getDescribe();
        if(wrapAccountList.isAccessible()) {
            return true;
        } else {
            return false;
        }
    }

    public static Boolean getwrapAccountListFLSAccessAccessible(){
        String [] accountlistFields = new String [] {'name', 'phone'};
        Map<String,Schema.SObjectField> accountlistFieldsMap = Schema.SObjectType.Account.fields.getMap();
        
        for (String fieldToCheck : accountlistFields) {
            if (!accountlistFieldsMap.get(fieldToCheck).getDescribe().isAccessible()) 
                return false;
        }
    	return true;
    }
    
    public static Boolean getwrapAccountListCRUDAccessDeletable(){
        Schema.DescribeSObjectResult wrapAccountList = Account.sObjectType.getDescribe();
        if(wrapAccountList.isDeletable()) {
            return true;
        } else {
            return false;
        }
    }
    
    public static Boolean getwrapAccountListCRUDAccessCreateable(){
        Schema.DescribeSObjectResult wrapAccountList = Account.sObjectType.getDescribe();
        if(wrapAccountList.isCreateable()) {
            return true;
        } else {
            return false;
        }
    }

    public static Boolean getwrapAccountListFLSAccessCreateable(){
        String [] accountlistFields = new String [] {'name', 'phone'};
            Map<String,Schema.SObjectField> accountlistFieldsMap = Schema.SObjectType.Account.fields.getMap();
        
        for (String fieldToCheck : accountlistFields) {
            if (!accountlistFieldsMap.get(fieldToCheck).getDescribe().isCreateable()) 
                return false;
        }
    	return true;
    }
    
    public static Boolean getwrapAccountListCRUDAccessUpdateable(){
        Schema.DescribeSObjectResult wrapAccountList = Account.sObjectType.getDescribe();
        if(wrapAccountList.isUpdateable()) {
            return true;
        } else {
            return false;
        }
    }

    public static Boolean getwrapAccountListFLSAccessUpdateable(){
        String [] accountlistFields = new String [] {'name', 'phone'};
        Map<String,Schema.SObjectField> accountlistFieldsMap = Schema.SObjectType.Account.fields.getMap();
        
        for (String fieldToCheck : accountlistFields) {
            if (!accountlistFieldsMap.get(fieldToCheck).getDescribe().isUpdateable()) 
                return false;
        }
    	return true;
    }
   
   //Contact object Accessible
   public static Boolean getwrapContactListCRUDAccessAccessible(){
       Schema.DescribeSObjectResult ContactListDescribe = Contact.sObjectType.getDescribe();
        if(ContactListDescribe.isAccessible()) {
            return true;
        } else {
            return false;
        } 
    }

    //Contact fields Accessible
    public static Boolean getwrapContactListFLSAccessAccessible(){       
        String [] contactslistFields = new String [] {'title','name','phone'};
            Boolean contactslistFieldsAccessStauts;
        
        Map<String,Schema.SObjectField> contactlistFieldsMap = Schema.SObjectType.Contact.fields.getMap();
        
        for (String fieldToCheck : contactslistFields) {
            if (!contactlistFieldsMap.get(fieldToCheck).getDescribe().isAccessible()) {
                return false;
            }
        }
        return true;
    }

    //Contact object Createable
   public static Boolean getwrapContactListCRUDAccessCreateable(){
       Schema.DescribeSObjectResult ContactListDescribe = Contact.sObjectType.getDescribe();
        if(ContactListDescribe.isCreateable()) {
            return true;
        } else {
            return false;
        } 
    }

    //Contact fields Createable
    public static Boolean getwrapContactListFLSAccessCreateable(){       
        String [] contactslistFields = new String [] {'title','firstname','lastname','phone'};
            Boolean contactslistFieldsAccessStauts;
        
        Map<String,Schema.SObjectField> contactlistFieldsMap = Schema.SObjectType.Contact.fields.getMap();
        
        for (String fieldToCheck : contactslistFields) {
            if (!contactlistFieldsMap.get(fieldToCheck).getDescribe().isCreateable()) {
                return false;
            }
        }
        return true;
    }

}