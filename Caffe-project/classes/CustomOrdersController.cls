public with sharing class CustomOrdersController {
    @AuraEnabled(cacheable=true)
    public static List<CustomOrder__c> getCustomOrdersByUser(Id userId) {
            return [ SELECT Id, Name, TotalPrice__c, Status__c, Customer__c, CreatedDate
            FROM CustomOrder__c
            WHERE Customer__c = :userId
            WITH SECURITY_ENFORCED
            ORDER BY Name DESC ];
    }

    @AuraEnabled(cacheable=true)
    public static List<OrderItem__c> getOrderItemsByUser(Id userId){
            return [ SELECT Id, Name, Amount__c, Price_Per_Unit__c, Order__c, Order_Price__c
            FROM OrderItem__c
            WHERE Order__r.Customer__c = :userId
            WITH SECURITY_ENFORCED
            ORDER BY Name ];
    }

    @AuraEnabled(cacheable=true)
    public static List<CustomOrder__c> getCustomOrdersByStatus(String status){
            return [ SELECT Id, Name, TotalPrice__c, Status__c, Customer__c, Description__c, OrderCompletionTime__c
            FROM CustomOrder__c
            WHERE Status__c = :status
            WITH SECURITY_ENFORCED
            ORDER BY Name ASC ];
    }

    @AuraEnabled(cacheable=true)
    public static List<OrderItem__c> getOrderItemsByStatus(String status){
            return [ SELECT Id, Name, Amount__c, Price_Per_Unit__c, Order__c, Order_Price__c
            FROM OrderItem__c
            WHERE Order__r.Status__c = :status
            WITH SECURITY_ENFORCED
            ORDER BY Name ];
    }

    @AuraEnabled
    public static boolean createOrder(CustomOrder__c order, List<OrderItem__c> orderItems){
        try {
            insert order;
            createOrderItemsForOrder(orderItems, order.Id);
            return true;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static void createOrderItemsForOrder(List<OrderItem__c> orderItems, Id customOrderId){
        List<OrderItem__c> orderItemsToInsert = new List<OrderItem__c>();
        for(OrderItem__c orderItem : orderItems){
            orderItem.Order__c = customOrderId;
            orderItemsToInsert.add(orderItem);
        }
        insert orderItemsToInsert;
    }

    @AuraEnabled
    public static void upgradeOrderStatus(CustomOrder__c order){
        try {
            switch on order.Status__c {
                when 'New' { order.Status__c = 'Accepted'; }
                when 'Accepted' { order.Status__c = 'Ready'; }
                when 'Ready' { order.Status__c = 'Done'; }
            }
            update order;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    

}
