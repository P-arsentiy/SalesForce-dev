public with sharing class AccountOutboundCallouts {

    public static final String ENDPOINT_BASE = Label.CalloutsEndpointForAccounts + 'Account/';
    public static final String GET_METHOD = 'GET';
    public static final String POST_METHOD = 'POST';
    public static final String DELETE_METHOD = 'DELETE';
    public static HttpResponse getAccountCallout(Id accountId){
        String endpoint = ENDPOINT_BASE + accountId;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod(GET_METHOD);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');

        HttpResponse response = http.send(request);
        return response;
    }

    public static HttpResponse postAccountCallout(String name, String phone, String website){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT_BASE);
        request.setMethod(POST_METHOD);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        JSONGenerator generator = JSON.createGenerator(false);
        generator.writeStartObject();
        generator.writeStringField('name', name);
        generator.writeStringField('phone', phone);
        generator.writeStringField('website', website);
        generator.writeEndObject();
        request.setBody(generator.getAsString());

        HttpResponse response = http.send(request);
        return response;
    }

    public static HttpResponse deleteAccountCallout(Id accountId){
        String endpoint = ENDPOINT_BASE + accountId;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod(DELETE_METHOD);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');

        HttpResponse response = http.send(request);
        return response;
    }

}