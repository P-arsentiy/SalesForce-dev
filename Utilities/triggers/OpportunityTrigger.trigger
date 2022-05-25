trigger OpportunityTrigger on Opportunity (before insert, before update) {
	OpportunityTriggerHandler triggerHandler = new OpportunityTriggerHandler();
    if (Trigger.isBefore){
        if(Trigger.isInsert){
            triggerHandler.beforeInsert(Trigger.New);
        } else if(Trigger.isUpdate){
            triggerHandler.beforeUpdate(Trigger.New, Trigger.oldMap);
        }
    }
}