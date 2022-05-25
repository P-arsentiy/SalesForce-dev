public class OpportunityDiscountByTimeHandler {
    public void beforeInsert(List<Opportunity> newOpportunities){
        Map<Id, Account> accounts = new Map<Id, Account>([SELECT Id, Registration_Date__c FROM Account WHERE Id IN :getAccountsIdsFromOpps(newOpportunities)]);
        List<DiscountByTime__mdt> discounts = DiscountByTime__mdt.getAll().values();
        for (Opportunity opp : newOpportunities){
            Date registrationDate = accounts.get(opp.AccountId)?.Registration_Date__c;
            if(registrationDate != null){
                Integer yearsPassed = registrationDate.monthsBetween(Date.today()) / 12;
                Decimal discountToApply = (opp.Amount / 100) * getDiscountByTime(yearsPassed, discounts);
                opp.Amount = opp.Amount - discountToApply;
            }
        }  
    }
    
    private List<ID> getAccountsIdsFromOpps(List<Opportunity> opportunities){
        List<ID> accountsIds = new List<ID>();
        for (Opportunity opp : opportunities){
            accountsIds.add(opp.AccountId);
        }
        return accountsIds;
    } 
    
    private Decimal getDiscountByTime(Integer passedYears, List<DiscountByTime__mdt> discounts){
        Decimal discAmount = 0;
        for (DiscountByTime__mdt disc : discounts){
            if(passedYears >= disc.YearsToApply__c && disc.DiscountPercent__c > discAmount){
                discAmount = disc.DiscountPercent__c;
            }
        }
        return discAmount;
    }
    
}