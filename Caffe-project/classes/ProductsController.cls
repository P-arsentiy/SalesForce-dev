public with sharing class ProductsController {
    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getPricebookEntries() {
        List<PricebookEntry> pricebookEntries = [
            SELECT Id, Name, UnitPrice, Description__c, Image_Link__c
            FROM PricebookEntry
            WHERE IsActive = true
            WITH SECURITY_ENFORCED
            ORDER BY Name
        ];
        return fixEntriesImages(pricebookEntries);
    }

    private static List<PricebookEntry> fixEntriesImages(List<PricebookEntry> entries){
        List<PricebookEntry> fixedEntries = new List<PricebookEntry>();
        for(PricebookEntry entry : entries){
            if(String.isBlank(entry.Image_Link__c)){
                entry.Image_Link__c = Label.Standart_Menu_Image;
            }
            fixedEntries.add(entry);
        }
        return fixedEntries;
    }

}
