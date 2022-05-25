({
    fireFilterEvent : function(component, event, helper) { 
        var filterEvent = $A.get("e.c:customFilterEvent"); 
        filterEvent.setParams({"filter" : component.get("v.filterField") });
        filterEvent.fire();
    },

    handleLoadedEvent : function(component, event, helper){
        component.set("v.isLoaded", true);
    }
})
