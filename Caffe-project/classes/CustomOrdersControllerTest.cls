@isTest
public with sharing class CustomOrdersControllerTest {
    
    @isTest
    static void CustomOrdersTest(){
        final Integer itemsInTest = 20;
        Map<CustomOrder__c, List<OrderItem__c>> testOrdersWithItems = TestDataFactory.createTestCustomOrdersWithItems(itemsInTest);
        Integer createdOrdersCount = 0;
        List<CustomOrder__c> ordersByUser = new List<CustomOrder__c>();
        List<CustomOrder__c> ordersByStatus = new List<CustomOrder__c>();
        List<OrderItem__c> itemsByUser = new List<OrderItem__c>();
        List<OrderItem__c> itemsByStatus = new List<OrderItem__c>();
        Test.startTest();
        for(CustomOrder__c order : testOrdersWithItems.keySet()){
            order.Id = null;
            if(CustomOrdersController.createOrder(order, testOrdersWithItems.get(order))) {
                createdOrdersCount++;
            }
            ordersByUser.addAll(CustomOrdersController.getCustomOrdersByUser(order.Customer__c));
            ordersByStatus.addAll(CustomOrdersController.getCustomOrdersByStatus(order.Status__c));
            itemsByUser.addAll(CustomOrdersController.getOrderItemsByUser(order.Customer__c));
            itemsByStatus.addAll(CustomOrdersController.getOrderItemsByStatus(order.Status__c));
        }
        Test.stopTest();
        //System.assertEquals((itemsInTest), createdOrdersCount, 'Not all order items was created');
        System.assertEquals((itemsInTest * itemsInTest), ordersByUser.size(), 'Not all orders received by User');
        System.assertEquals((itemsInTest * itemsInTest), ordersByStatus.size(), 'Not all orders received by Status');
        System.assertEquals((itemsInTest * itemsInTest * 2), itemsByUser.size(), 'Not all order items received by User');
        System.assertEquals((itemsInTest * itemsInTest * 2), itemsByStatus.size(), 'Not all order items received by Status');
    }



}
