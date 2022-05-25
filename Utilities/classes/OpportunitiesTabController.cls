public with sharing class OpportunitiesTabController {
    @AuraEnabled
	public static List<Opportunity> getOpportunities(Id recordId, String filter) {
    List<Opportunity> opportunities = [SELECT Id, Name, Amount, ExpectedRevenue, Probability, StageName, CloseDate FROM Opportunity WHERE AccountId = :recordId];
        if(filter != null){
            return getFilteredOpportunities(opportunities, filter);
        } else {
            return opportunities;
        }
    }

    public static List<Opportunity> getFilteredOpportunities(List<Opportunity> opportunities, String filter){
        List<Opportunity> filteredOpps = new List<Opportunity>();
            for(Opportunity opp : opportunities){
                if(opp.Name.toLowerCase().contains(filter) || opp.StageName.toLowerCase().contains(filter)){
                    filteredOpps.add(opp);
                }
            }
            return filteredOpps;
    }

}
