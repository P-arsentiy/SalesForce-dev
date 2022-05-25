
String name = 'Petya Petrov';
String phone = '12345';
String website = 'acme.com';
HttpResponse response = AccountOutboundCallouts.postAccountCallout(name, phone, website);
System.debug(response.getStatusCode());
System.debug(response.getBody());

Id accountId = '0010900000wwdWnAAI';
HttpResponse response = AccountOutboundCallouts.getAccountCallout(accountId);
System.debug(response.getStatusCode());
System.debug(response.getBody());

Id accountId = '0010900000wwdWnAAI';
HttpResponse response = AccountOutboundCallouts.deleteAccountCallout(accountId);
System.debug(response.getStatusCode());
System.debug(response.getBody());