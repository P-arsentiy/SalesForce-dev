@isTest
public with sharing class CustomOrderTriggerHandlerTest {

    @isTest
    static void CustomOrderTriggerTest(){
        final Integer itemsInTest = 10;
        List<CustomOrder__c> customOrdersAccepted = TestDataFactory.createTestCustomOrders(itemsInTest);
        Test.startTest();
        for(CustomOrder__c order : customOrdersAccepted){
            order.Status__c = 'Ready';
        }
        update customOrdersAccepted;
        Integer mailsWasSended = Limits.getEmailInvocations();
        Test.stopTest();
        System.assertEquals(itemsInTest, mailsWasSended, 'An email has not been sent');
    }

}
