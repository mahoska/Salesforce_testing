public with sharing class ImmovablesController {
 	@AuraEnabled
    public static List<Immovables__c> getImmovables(String typeIm, String statusIm, Boolean sortArea, String searchText) {
        List<Immovables__c> imms;
        if(!String.isEmpty(searchText)){
            String s = 'SELECT Id, Name,Full_address__c, Total_area__c,  toLabel(Type__c), 	Initial_cost__c,Seller__r.Id,'+
                'Seller__r.Name, Seller__r.First_Name__c,  Seller__r.Last_Name__c, Seller__r.Contact_Phone__c, toLabel(Status__c)'+
                'FROM Immovables__c  WHERE Full_address__c Like \'%' + searchText + '%\' ORDER BY Status__c';
            imms = Database.query(s);
        }else{
        if(typeIm=='all'){
            if(sortArea){
                imms =  [SELECT Id, Name, 
                Full_address__c, 
                Total_area__c, 
                toLabel(Type__c), 	
                Initial_cost__c,
                Seller__r.Id,
                Seller__r.Name, 
                Seller__r.First_Name__c, 
                Seller__r.Last_Name__c,
                Seller__r.Contact_Phone__c,
                toLabel(Status__c)
                FROM Immovables__c 
                WHERE toLabel(Status__c) =:statusIm
                ORDER BY Total_area__c ASC];
            }else{
                imms =  [SELECT Id, Name, 
                    Full_address__c, 
                    Total_area__c, 
                    toLabel(Type__c), 	
                    Initial_cost__c,
                    Seller__r.Id,
                    Seller__r.Name, 
                    Seller__r.First_Name__c, 
                    Seller__r.Last_Name__c,
                    Seller__r.Contact_Phone__c,
                    toLabel(Status__c)
                    FROM Immovables__c 
                    WHERE toLabel(Status__c) =:statusIm
                    ORDER BY Total_area__c DESC];
            }   
        }else{
             if(sortArea){
                imms =  [SELECT Id, 
                    Name, 
                    Full_address__c, 
                    Total_area__c, 
                    toLabel(Type__c), 	
                    Initial_cost__c,
                    Seller__r.Id,
                    Seller__r.Name, 
                    Seller__r.First_Name__c, 
                    Seller__r.Last_Name__c,
                    Seller__r.Contact_Phone__c,
                    toLabel(Status__c)
                    FROM Immovables__c
                    WHERE Type__c=:typeIm AND toLabel(Status__c) =:statusIm
                    ORDER BY  Total_area__c ASC];
             }else{
                  imms =  [SELECT Id, 
                    Name, 
                    Full_address__c, 
                    Total_area__c, 
                    toLabel(Type__c), 	
                    Initial_cost__c,
                    Seller__r.Id,
                    Seller__r.Name, 
                    Seller__r.First_Name__c, 
                    Seller__r.Last_Name__c,
                    Seller__r.Contact_Phone__c,
                    toLabel(Status__c)
                    FROM Immovables__c
                    WHERE Type__c=:typeIm AND toLabel(Status__c) =:statusIm
                    ORDER BY  Total_area__c DESC];
             }
        }
        }
        
        return imms;
    }
    
    @AuraEnabled
    public static AggregateResult[]  getTypes() {
        // Perform isAccessible() checking first, then
        return [SELECT 
                toLabel(Type__c)	
                FROM Immovables__c
                GROUP BY Type__c
                ];
    }
    
     @AuraEnabled
    public static AggregateResult[]  getStatus(){
         return [SELECT 
                toLabel(Status__c)	
                FROM Immovables__c
                GROUP BY Status__c
                ];
    }
    
    
    
   public static Map<Id, String> recordtypemap {get;set;}
    
   @AuraEnabled        
    public static List<String> fetchRecordTypeValues(){
        List<Schema.RecordTypeInfo> recordtypes = Immovables__c.SObjectType.getDescribe().getRecordTypeInfos();    
        recordtypemap = new Map<Id, String>();
        for(RecordTypeInfo rt : recordtypes){
            if(rt.getName() != 'Master')
            recordtypemap.put(rt.getRecordTypeId(), rt.getName());
        }        
        System.debug(recordtypemap);
        return recordtypemap.values();
    }
    
    @AuraEnabled
    public static Id getRecTypeId(String recordTypeLabel){
        Id recid = Schema.SObjectType.Immovables__c.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
        return recid;
    }  
    
    
    @AuraEnabled
    public static Integer deleteRecord(String recordId){
         AggregateResult[] countImms = [SELECT COUNT(Id) FROM Immovables__c WHERE Id = :recordId];
         AggregateResult[] countImmsAfter = new List<AggregateResult>();
        
        if(countImms.size() != 0){
            Immovables__c delRec  = new Immovables__c(Id=recordId);
          
            try {
                delete delRec;
                return countImms.size();
            } catch (DmlException e) {
                    return -1;
            }   
        }else 
            return -2;
        
    }
    
    @AuraEnabled
    public static List<Offer__c> getOffersByImm(String ImmovablesId){
        List<Offer__c> listOffer =  [
            SELECT Id, Name, Maximum_price__c, Desired_price__c,  
            Customer__r.Id,  Customer__r.First_name__c, Customer__r.Last_name__c, Customer__r.Contact_phone__c
            FROM Offer__c 
            WHERE Immovables__c=:ImmovablesId
        	ORDER BY Desired_price__c DESC];
        
        return listOffer;
    }
    
    @AuraEnabled
    public static List<Immovables__c> getSimilarImmovables (Id recordId, Integer rooms, Integer baths) {
             return [
                 SELECT Id, Name, Number_of_rooms__c,Number_of_bathrooms__c, Full_address__c,  toLabel(Status__c),  Initial_cost__c, Broker__r.Name, Broker__r.Id, toLabel(Type__c)
                 FROM Immovables__c 
                 WHERE Id != :recordId AND Number_of_rooms__c = :rooms AND Number_of_bathrooms__c = :baths 
                 ORDER BY Initial_cost__c
                 LIMIT 10
                 
             ];
        
     }
    
    @AuraEnabled
    public static List<Immovables__c> findAllWithLocation() {
    return [SELECT Id, Name, Full_address__c, Location__Latitude__s, Location__Longitude__s
            FROM Immovables__c
            WHERE Location__Latitude__s != NULL AND Location__Longitude__s != NULL
            LIMIT 10];
    }
}