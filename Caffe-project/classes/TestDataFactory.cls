@isTest
public with sharing class TestDataFactory {

    public static Map<CustomOrder__c, List<OrderItem__c>> createTestCustomOrdersWithItems(Integer num){
        Map<CustomOrder__c, List<OrderItem__c>> ordersWithItems = new Map<CustomOrder__c, List<OrderItem__c>>();
        List<OrderItem__c> orderItemsToInesrt = new List<OrderItem__c>();
        List<CustomOrder__c> newCustomOrders = createTestCustomOrders(num);
        Integer counter = 1;
        for (CustomOrder__c order : newCustomOrders){
            List<OrderItem__c> itemsInOrder = addOrderItemsToOrder(order, counter);
            ordersWithItems.put(order, itemsInOrder);
            orderItemsToInesrt.addAll(itemsInOrder);
            counter++;
        }
        insert orderItemsToInesrt;
        return ordersWithItems;
    }
    
    public static List<CustomOrder__c> createTestCustomOrders(Integer num){
        List<CustomOrder__c> customOrders = new List<CustomOrder__c>();
        List<User> users = [ SELECT Id FROM User WHERE Name = 'Arsentii Poltavchenko' LIMIT :num];
        for (Integer i=0; i < num; i++){
            customOrders.add(getNewCustomOrder(i, users.get(Integer.valueof((Math.random() * (users.size() - 1))))));
        }
        insert customOrders;
        return customOrders;
    }

    public static void systemDebug(Set<CustomOrder__c> orders){
        for(CustomOrder__c order : orders){
            System.debug('Order testing: ' + order.Id);
        }
    }

    public static CustomOrder__c getNewCustomOrder(Integer i, User user){
        i++;
        CustomOrder__c newOrder = new CustomOrder__c(
            TabelNumber__c = i,
            ClientsAmount__c = i,
            EmailWhenReady__c = true,
            Status__c = 'Accepted',
            OrderCompletionTime__c = DateTime.now().addMinutes(30 + i),
            Description__c = String.valueOf(i),
            Customer__c = user.Id
            );
        return newOrder;
    }

    public static List<OrderItem__c> addOrderItemsToOrder(CustomOrder__c order, Integer counter){
        List<OrderItem__c> newOrderItems = new List<OrderItem__c>();
        for(Integer i = 1; i < 3; i++){
            newOrderItems.add(new OrderItem__c(
                Name = ('Item ' + i),
                Price_Per_Unit__c = counter,
                Amount__c = counter,
                Order__c = order.Id
            ));
        }
        return newOrderItems;
    }











}
