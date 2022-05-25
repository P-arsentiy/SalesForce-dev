trigger CustomOrderTrigger on CustomOrder__c (after update) {
    CustomOrderTriggerHandler triggerHandler = new CustomOrderTriggerHandler();
    if (!Trigger.isBefore){
        if(Trigger.isUpdate){
            triggerHandler.afterUpdate(Trigger.New, Trigger.oldMap);
        }
    }
}