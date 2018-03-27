public with sharing  class MittingSet {
    
	/*@AuraEnabled
    public static Map<String, TimesOfDay__c> getDayPart(){ 
        Map<String, TimesOfDay__c> dayParts = TimesOfDay__c.getAll();
        return dayParts;
    }*/
    
	@AuraEnabled
    public static List<String> getDayPartList(){ 
        Map<String, TimesOfDay__c> dayParts = TimesOfDay__c.getAll();
        Set<String> namePartDay = dayParts.keySet();
        List<String> res=new List<String>();
		res.addAll(namePartDay);
        return res;
    }
    
    @AuraEnabled
    public static  TimesOfDay__c getDayPartInfo(String namePart){ 
    	TimesOfDay__c info = TimesOfDay__c.getValues(namePart);
        return info;
    }
    
}