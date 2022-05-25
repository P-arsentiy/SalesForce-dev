@isTest
public with sharing class TestDataFactory {
    
    public static List<Gift_Card__c> createTestGiftCards(Integer numCards){
        List<Gift_Card__c> giftCards = new List<Gift_Card__c>();
        for (Integer i=0; i < numCards; i++){
            giftCards.add(new Gift_Card__c(Amount__c = 5*i));
        }
        insert giftCards;
        giftCards = [SELECT Id, Name, Amount__c FROM Gift_Card__c ORDER BY Name ASC];
        return giftCards;
    }

    public static List<Account> createTestAccountsWithDiffRegDate(Integer numAccounts){
        List<Account> accounts = new List<Account>();
        if(numAccounts > 50){
            numAccounts = 50;
        }
        for (Integer i=0; i<numAccounts; i++){
            Date year = Date.today().addYears(-i - 1);
            accounts.add(new Account(Name = 'Test Account' + i, Registration_Date__c = Date.newInstance(year.year(), 1, 1)));
        }
        insert accounts;
        return accounts;
    }

    public static List<Book__c> createBooksWithAuthors(Integer numBooks){
        List<Book__c> books = new List<Book__c>();
        for (Integer i=0; i<100; i++){
            String authors = 'Stive ' + i + ',' + 'George ' + i;
            Book__c book = new Book__c(Name = 'Test book ' + i, Author__c = authors);
            books.add(book);
        }
        insert books;
        return books;
    }

    public static List<Writer__c> createWriters(String testName, Integer numWriters){
        List<Writer__c> writers = new List<Writer__c>();
        for (Integer i=0; i<100; i++){
            Writer__c writer = new Writer__c(Name = testName + i);
            writers.add(writer);
        }
        insert writers;
        return writers;
    }

}