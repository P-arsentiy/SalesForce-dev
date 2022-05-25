public with sharing class SendProductShippingRequestController {
    public static final String ENDPOINT_BASE = 'https://test-soap-dev-developer-edition.na150.force.com/services/apexrest/shippingRequest';
    public static final String POST_METHOD = 'POST';
    @AuraEnabled
    public static Integer saveNewRequest(ShippingRequest__c newRequest){
        Integer result = null;
        newRequest.Shipping_Name__c = newRequest.Shipping_Name__c.replace('&', '/');
        try {
            HttpResponse response = postAccountCallout(newRequest);
            result = response.getStatusCode();
            if(result == 201){
                newRequest.ShippingRequestResponse__c = response.getBody().split('"').get(4).removeEnd('\\');
                insert newRequest;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return result;
    }

    public static HttpResponse postAccountCallout(ShippingRequest__c newRequest){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT_BASE);
        request.setMethod(POST_METHOD);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        JSONGenerator generator = JSON.createGenerator(false);
        generator.writeStartObject();
        generator.writeStringField('id', newRequest.Product_Name__c);
        generator.writeNumberField('quantity', newRequest.Shipping_Quantity__c);
        generator.writeStringField('address', newRequest.Shipping_Address__c);
        generator.writeStringField('name', newRequest.Shipping_Name__c);
        generator.writeEndObject();
        request.setBody(generator.getAsString());

        HttpResponse response = http.send(request);
        return response;
    }

}
