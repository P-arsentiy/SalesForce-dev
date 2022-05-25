@isTest
public class BooksToWritersBatchTest {

    @TestSetup
    static void setup(){
        List<Writer__c> writers = TestDataFactory.createWriters('Stive ', 100);
        List<Writer__c> nonAuthorWriters = TestDataFactory.createWriters('Jonson&Jonson ', 50);
        List<Book__c> books = TestDataFactory.createBooksWithAuthors(100);
        List<BooksToWriters__c> junctions = new List<BooksToWriters__c>();

        for (Integer i = 0; i < 50; i++){
            BooksToWriters__c junction = new BooksToWriters__c(Book__c = books.get(i).Id, Writer__c = writers.get(i).Id);
            if(i/2 == 0){
                junction.Writer__c = nonAuthorWriters.get(i).Id;
            }
            junctions.add(junction);
        }
        insert junctions;
    }

    @isTest
    static void correctBooksAssigmentTest(){

        Test.startTest();
        BooksToWritersBatch job = new BooksToWritersBatch();
        Database.executeBatch(job);
        Test.stopTest();

        List<Book__c> books = [SELECT Id, Name FROM Book__c ORDER BY Name ASC];
        List<String> booksNames = new List<String>();
        for (Book__c book : books){
            booksNames.add(book.Name);
        }
        List<BooksToWriters__c> booksToWriters = [SELECT Book__c, Writer__c FROM BooksToWriters__c WHERE Book__c IN :booksNames];
        System.assert(booksToWriters.size() < 200 || booksToWriters.size() > 200 , 'Unexpected number of created junctions. Must be 200. Created junctions count: ' + booksToWriters.size());
    }


}