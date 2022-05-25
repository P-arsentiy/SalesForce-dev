({
	
    fillOpportunitiesTab : function(component, event, helper) {
        helper.refreshOpportunitiesTab(component, null);
    },

	handleFilterEvent : function(component, event, helper){
		helper.refreshOpportunitiesTab(component, event.getParam("filter"));
		//helper.filterEvent(component, 'Negotiation');
	},

	handlePDFAction : function(component, event, helper){
		var action = event.getParam('action');
    	var row = event.getParam('row');
    	if (action.name === 'createPDF') {
    	        helper.pdfAction(component, row);
    	}
	}
})
