public with sharing class OpportunityReportPDFController {
    public Id oppId { get; set;}
    public Account oppAccount { get; set;}
    public Opportunity selectedOpportunity { get; set;}
    public List<Quote> opportunityQuotes { get; set;}

    public OpportunityReportPDFController(){
        //this.oppId = '0067Q0000027DEnQAM';
        this.oppId = ApexPages.currentPage().getParameters().get('id');
        if(String.isBlank(this.oppId)) {
            ApexPages.addMessage(new 
                ApexPages.Message(ApexPages.Severity.ERROR, 
               'Error. No opportunity ID'));
        } else {
            loadData();
        }
        
    }

    private void loadData(){
        this.selectedOpportunity = [
            SELECT Id, Name, Amount, AccountId, CloseDate 
            FROM Opportunity 
            WHERE Id = :this.oppId];
        this.opportunityQuotes = [
            SELECT Id, Name, Subtotal, Discount, TotalPrice, ExpirationDate
            FROM Quote 
            WHERE OpportunityId = :this.oppId];
        this.oppAccount = [SELECT Id, Name FROM Account WHERE Id = :selectedOpportunity.AccountId];
    }


    // public List<Quote> getRelatedQuotes(){
    //         return 
    //     }

    public ID getSelectedOppId(){
        return this.oppId;
    }
}
