/**
 * Created by annaMahovskaya on 3/4/18.
 */
public without sharing class  CheckAccessRight {
    private static Schema.DescribeSObjectResult wrapAccountList = Account.sObjectType.getDescribe();
    private static String [] accountlistFields = new String [] {'name', 'phone'};
    private static Map<String,Schema.SObjectField> accountlistFieldsMap = Schema.SObjectType.Account.fields.getMap();
    
    private static Schema.DescribeSObjectResult ContactListDescribe = Contact.sObjectType.getDescribe();
    private static String [] contactslistFields = new String [] {'title','name','phone'};
    private static Map<String,Schema.SObjectField> contactlistFieldsMap = Schema.SObjectType.Contact.fields.getMap();

    /*сhecking account availability*/
    public static Boolean getwrapAccountListCRUDAccessAccessible(){
        return wrapAccountList.isAccessible();
    }

   /*сhecking account filds availability*/
    public static Boolean getwrapAccountListFLSAccessAccessible(){
        for (String fieldToCheck : accountlistFields) {
            if (!accountlistFieldsMap.get(fieldToCheck).getDescribe().isAccessible()) 
                return  false;
        }
    	return  true;
    }
    
    /*сhecking account on the availability of removal*/
    public static Boolean getwrapAccountListCRUDAccessDeletable(){
         return wrapAccountList.isDeletable();
    }
    
    /*сhecking account on the availability of the addition operation*/
    public static Boolean getwrapAccountListCRUDAccessCreateable(){
        return wrapAccountList.isCreateable();
    }

    /*check for the availability of entries in the fields of the account*/
    public static Boolean getwrapAccountListFLSAccessCreateable(){
        for (String fieldToCheck : accountlistFields) {
            if (!accountlistFieldsMap.get(fieldToCheck).getDescribe().isCreateable()) 
                return  false;
        }
    	return  true;
    }
    
    /*сhecking account on the availability of the updating operation*/
    public static Boolean getwrapAccountListCRUDAccessUpdateable(){
        return wrapAccountList.isUpdateable();
    }

    /*check for the availability of changes in account field values*/
    public static Boolean getwrapAccountListFLSAccessUpdateable(){ 
        for (String fieldToCheck : accountlistFields) {
            if (!accountlistFieldsMap.get(fieldToCheck).getDescribe().isUpdateable()) 
                return false;
        }
        return true;
    }
   
   /*сhecking contact availability*/
   public static Boolean getwrapContactListCRUDAccessAccessible(){
        return ContactListDescribe.isAccessible();
    }

   /*сhecking contact filds availability*/
    public static Boolean getwrapContactListFLSAccessAccessible(){       
        for (String fieldToCheck : contactslistFields) {
            if (!contactlistFieldsMap.get(fieldToCheck).getDescribe().isAccessible()) {
                return false;
            }
        }
        return true;
    }

    /*сhecking contact on the availability of the addition operation*/
   public static Boolean getwrapContactListCRUDAccessCreateable(){
        return ContactListDescribe.isCreateable();
    }

     /*check for the availability of entries in the fields of the contact*/
    public static Boolean getwrapContactListFLSAccessCreateable(){ 
        contactslistFields = new String [] {'title','firstname','lastname','phone'};
        contactlistFieldsMap = Schema.SObjectType.Contact.fields.getMap();
        
        for (String fieldToCheck : contactslistFields) {
            if (!contactlistFieldsMap.get(fieldToCheck).getDescribe().isCreateable()) {
                return false;
            }
        }
        return true;
    }

}