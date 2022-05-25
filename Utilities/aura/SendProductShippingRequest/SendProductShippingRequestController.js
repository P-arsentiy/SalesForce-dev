({
   sendRequest: function(component, event, helper) {
    if(helper.validateNewRequest(component)){
        component.set("v.newRequest.OwnedBy__c", component.get("v.recordId"));
        var newRequest = component.get("v.newRequest");
        helper.createNewRequest(component, newRequest);
    }
   },

   handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire() 
    }
  
})