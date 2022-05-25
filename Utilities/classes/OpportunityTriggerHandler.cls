public class OpportunityTriggerHandler {
    public void beforeInsert(List<Opportunity> newOpportunities){
        OpportunityDiscountByTimeHandler discountByTimeHandler = new OpportunityDiscountByTimeHandler();
        discountByTimeHandler.beforeInsert(newOpportunities);
        OpportunityGiftCardsHandler giftCardsHandler = new OpportunityGiftCardsHandler();
        giftCardsHandler.beforeInsert(newOpportunities);
    }
    
    public void beforeUpdate(List<Opportunity> newOpportunities, Map<Id, Opportunity> oldOpportunities){
        OpportunityGiftCardsHandler giftCardsHandler = new OpportunityGiftCardsHandler();
        giftCardsHandler.beforeUpdate(newOpportunities, oldOpportunities);
    }
}