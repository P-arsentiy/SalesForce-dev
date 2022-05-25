@isTest
public with sharing class OpportunityTriggerHandlerTest {
    @isTest
    static void OpportunityTriggerTest(){
        List<Gift_Card__c> giftCards = TestDataFactory.createTestGiftCards(75);

        List<Account> accounts = TestDataFactory.createTestAccountsWithDiffRegDate(5);
        
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Integer i=0; i<100; i++){
            Opportunity opp = new Opportunity(Name = 'TestOpp ' + i, Amount = 10*i, AccountId = accounts.get(0).Id, CloseDate = Date.today().addDays(1), StageName = 'Prospecting', Gift_Card__c = 'GIFT-00'+i);
            if(i < 25){
                opp.Gift_Card__c = giftCards.get(i).Name;
            } else if(i >= 25 && i < 50){
                opp.AccountId = accounts.get(1).Id;
                opp.Gift_Card__c = giftCards.get(i).Name;
            } else if(i >= 50 && i < 75 ){
                opp.AccountId = accounts.get(2).Id;
                opp.Gift_Card__c = null;
            } else if(i >= 75){
                opp.AccountId = accounts.get(3).Id;
            }
            opportunities.add(opp);
        }

        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        for(Integer i=0; i<75; i++){
            Opportunity opp = opportunities.get(i);
            if(i < 25){
                opp.Gift_Card__c = giftCards.get(i+50).Name;
                opportunitiesToUpdate.add(opp);
            } else {
                opp.Gift_Card__c = giftCards.get(i).Name;
                opportunitiesToUpdate.add(opp);
            }
        }

        Test.startTest();
        List<Database.SaveResult> insertResult = Database.insert(opportunities, false);
        List<Database.SaveResult> updateResult = Database.update(opportunitiesToUpdate, false);
        Test.stopTest();
    
    }


}