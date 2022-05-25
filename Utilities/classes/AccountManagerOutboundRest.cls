@RestResource(urlMapping='/Account/*')
global with sharing class AccountManagerOutboundRest {

    @HttpGet
    global static String getAccountById() {
        RestRequest request = RestContext.request;
        // grab the caseId from the end of the URL f
        String accountId = request.requestURI.substring(
          request.requestURI.lastIndexOf('/')+1);
        HttpResponse response = AccountOutboundCallouts.getAccountCallout(accountId);
        String result = null;
        try{
            result = response.getBody();
        } catch (Exception ex){
            result = null;
            System.debug('Fail to get Account with ID: ' + accountId);
        }
        return result;
    }

    @HttpPost
    global static String createAccount(String name, String phone, String website) {
        HttpResponse response = AccountOutboundCallouts.postAccountCallout(name, phone, website);
        return response.getBody();
    }  

    @HttpDelete
    global static void deleteAccount() {
        RestRequest request = RestContext.request;
        String accountId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        HttpResponse response = AccountOutboundCallouts.deleteAccountCallout(accountId);
    } 

}