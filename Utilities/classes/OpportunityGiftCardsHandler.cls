public class OpportunityGiftCardsHandler {
    
    public void beforeInsert(List<Opportunity> newOpportunities){
        Map<Opportunity, Gift_Card__c> opportunitiesCards = getOpportunitiesCards(newOpportunities);
        applyGiftCards(opportunitiesCards);
        
    }
    
    public void beforeUpdate(List<Opportunity> newOpportunities, Map<Id, Opportunity> oldOpportunities){
        Map<Opportunity, Gift_Card__c> opportunitiesCards = getOpportunitiesCards(newOpportunities);
        for(Opportunity opp : opportunitiesCards.keySet()){
            if(oldOpportunities.get(opp.Id).Gift_Card__c == opp.Gift_Card__c){
                opportunitiesCards.remove(opp);
            }
        }
        applyGiftCards(opportunitiesCards);
    }
    
    private void applyGiftCards(Map<Opportunity, Gift_Card__c> opportunitiesCards){
        if(!opportunitiesCards.isEmpty()){
            List<Gift_Card__c> cardsToUpdate = new List<Gift_Card__c>();
            for(Opportunity opp : opportunitiesCards.keySet()){
                Gift_Card__c updatedCard = opportunitiesCards.get(opp);
                if(isGiftCardAvaliable(opp, updatedCard)){
                opp.Amount = opp.Amount - updatedCard.Amount__c;
                updatedCard.Active__c = false;
                cardsToUpdate.add(updatedCard);
                }
            }
            update cardsToUpdate;
        }
    }
    
    private Map<Opportunity, Gift_Card__c> getOpportunitiesCards(List<Opportunity> newOpportunities){
        Map<Opportunity, Gift_Card__c> opportunitiesCards = new Map<Opportunity, Gift_Card__c>();
        List<Gift_Card__c> giftCards = getCardsInOpportunities(newOpportunities);
        
        for (Opportunity opp : newOpportunities){
            if(!String.isBlank(opp.Gift_Card__c)){
                opportunitiesCards.put(opp, null);
                for(Gift_Card__c card : giftCards){
                    if(opp.Gift_Card__c == card.Name){
                        opportunitiesCards.put(opp, card);
                    }
                } 
            }
        }
        return opportunitiesCards;
    }
    
    private List<Gift_Card__c> getCardsInOpportunities(List<Opportunity> newOpportunities){
        List<String> cardsNames = new List<String>();
        for (Opportunity opp : newOpportunities){
            cardsNames.add(opp.Gift_Card__c);
        }
        List<Gift_Card__c> giftCards = [SELECT Name, Amount__c, Active__c FROM Gift_Card__c WHERE Name IN :cardsNames];
        return giftCards;
    }
    
    private Boolean isGiftCardAvaliable(Opportunity opp, Gift_Card__c card){
            if(card == null){
                errorWrongGiftCard(opp);
                return false;
            } else if(!card.Active__c){
                errorInactiveGiftCard(opp);
                return false;
            }
        return true;
    }
    

    private void errorWrongGiftCard(Opportunity opp){
        opp.Gift_Card__c.addError(Label.ErrorWrongGiftCard.replace('{GiftCardName}', opp.Gift_Card__c));
    }
    
    private void errorInactiveGiftCard(Opportunity opp){
        opp.Gift_Card__c.addError(Label.ErrorInactiveGiftCard.replace('{GiftCardName}', opp.Gift_Card__c));
    }
    
}