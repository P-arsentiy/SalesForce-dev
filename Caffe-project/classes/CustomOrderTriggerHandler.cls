public with sharing class CustomOrderTriggerHandler {
    public CustomNotificationType notificationType;
    private Map<Id, User> usersInOrdersByIDs = new Map<Id, User>();
    public CustomOrderTriggerHandler() {
        this.notificationType = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'OrderIsReadyNotification'];
    }

    public void afterUpdate(List<CustomOrder__c> newCustomOrders, Map<Id, CustomOrder__c> oldCustomOrders){
        collectUsersInOrders(newCustomOrders);
        for(CustomOrder__c order : newCustomOrders){
            CustomOrder__c oldOrder = oldCustomOrders.get(order.Id);
            Boolean isNew = (oldOrder.Status__c != 'Ready' && oldOrder.Status__c != 'Done');
            if(order.Status__c == 'Ready' && order.EmailWhenReady__c && isNew){
                handleMessages(order);
            }
        }
    }

    public void handleMessages(CustomOrder__c order){
        User user = this.usersInOrdersByIDs.get(order.Id);
        sendNotification(user, order);
        sendMail(user, order);
    }

    public void sendMail(User orderUser, CustomOrder__c order){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toaddresses = new String[] { orderUser.Email };
        message.optOutPolicy = 'FILTER';
        message.subject = 'Order is Ready';
        message.plainTextBody = ('Your order №' + getOrderNumber(order) + ' is ready, go and get it!');
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
            }
    }

    public void sendNotification(User orderUser, CustomOrder__c order){
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setBody('Your order is ready');
        notification.setTitle('Order №' + getOrderNumber(order) + ' is Ready');
        notification.setNotificationTypeId(this.notificationType.id);
        notification.setTargetId(order.Id); // target object id
        notification.send(new Set<String> { orderUser.Id });
    }

    public void collectUsersInOrders(List<CustomOrder__c> orders){
        List<Id> usersIds = getUsersIds(orders);
        List<User> users = [SELECT Id, Name, Email FROM User WHERE Id IN :usersIds];
        for(CustomOrder__c order : orders){
            for(User user : users){
                if(order.Customer__c == user.Id){
                    this.usersInOrdersByIDs.put(order.Id, user);
                }
            }
        }
    }

    private List<Id> getUsersIds(List<CustomOrder__c> orders){
        List<Id> usersIds = new List<Id>();
        for(CustomOrder__c order : orders){
            usersIds.add(order.Customer__c);
        }
        return usersIds;
    }

    private String getOrderNumber(CustomOrder__c order){
        return order.Name.split('-')[1];
    }



}
