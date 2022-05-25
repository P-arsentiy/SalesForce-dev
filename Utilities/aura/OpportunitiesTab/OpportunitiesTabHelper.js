({
    refreshOpportunitiesTab : function(component, filter){
        component.set("v.Columns", [
	    {label:"Opportunity Name", fieldName:"Name", type:"text"},
	    {label:"Amount", fieldName:"Amount", type:"currency"},
	    {label:"Expected vs. Actual", fieldName:"ExpectedRevenue", type:"currency"},
        {label:"Result", cellAttributes:
            {iconName: { fieldName: 'ResultIcon' },   class: { fieldName: 'CSSClassResult' }  , iconPosition: 'right' }},
        {label: 'Probability' , cellAttributes:
            {iconName: { fieldName: 'CyrcleIcon' },   class: { fieldName: 'CSSClassCyrcle' }  , iconPosition: 'right' }},
        {label:"Stage", fieldName:"StageName", type:"text"},
        {label:"Close Date", fieldName:"CloseDate", type:"date"},
		{label : 'PDF', type:  'button', typeAttributes: {
		label: 'PDF', name: 'createPDF', title: 'createPDF', disabled: false, value: 'Id'}}
		]);
		var action = component.get("c.getOpportunities");
			action.setParams({
		    recordId: component.get("v.recordId"),
            filter: filter
		});
		action.setCallback(this, function(response) {
			let state = response.getState();
			if(state === "SUCCESS"){
				let objects= response.getReturnValue();
				for(var object of objects){
					object.CyrcleIcon = 'utility:record';
                    object.CSSClassCyrcle = this.getCyrcleCSSClass(object.Probability);
					object.ResultIcon = this.getResultIcon(object.Amount, object.ExpectedRevenue);
					object.CSSClassResult = 'resultIcon';
				component.set("v.Opportunities", objects);
				}
                if(filter === null){
                    this.fireLoadedEvent();
                }
			} else if (state === "ERROR"){
				let errors = response.getError();
				if(errors){
					if(errors[0] && errors[0].message){
						console.log("Error message: " + errors[0].message);
					}
				}
			}
			
		});
		$A.enqueueAction(action);
    },

    pdfAction : function(component, row){
        var opportunityId = '';
        let opportunities = component.get("v.Opportunities");
        for(var opp of opportunities){
            if(opp.Name === row.Name){
                opportunityId = opp.Id;
            }
        }
        var pdfUrl = "/apex/OpportunityReportPDF?id=" + opportunityId;
       var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": pdfUrl
    });
    urlEvent.fire();
    },

    getCyrcleCSSClass : function(probability){
        var iconColor = '';
        if(probability <= 30){
            iconColor = 'iconRed';
		} else if (probability >= 31 && probability <= 70){
            iconColor = 'iconYellow';
		} else {
            iconColor = 'iconGreen';
		}
        return (iconColor);
    },

    getResultIcon : function(amount, expextedAmount){
        var resultIcon = 'utility:assignment';
        if(amount > expextedAmount){
            resultIcon = 'utility:arrowup'
        } else if(amount < expextedAmount){
            resultIcon = 'utility:arrowdown';
        }
        return (resultIcon);
    },
    
    fireLoadedEvent : function(){
        var loadedEvent = $A.get("e.c:summaryLoadedEvent");
        loadedEvent.setParams({"isLoaded" : true });
        loadedEvent.fire();
    }
})
