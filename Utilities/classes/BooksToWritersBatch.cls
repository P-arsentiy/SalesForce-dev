public without sharing class BooksToWritersBatch implements Database.Batchable<sObject>, Database.Stateful, Schedulable {
    Integer recordsProcessed = 0;
    Map<String, Writer__c> writersNames = new Map<String, Writer__c>();

    public BooksToWritersBatch(){
        List<Writer__c> writers = [SELECT Id, Name FROM Writer__c];
        for(Writer__c writer : writers){
            writersNames.put(writer.Name, writer);
        }
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, Author__c FROM Book__c WHERE Author__c != null ]);
    }

    public void execute(Database.BatchableContext bc, List<Book__c> scope){
        insertNewWritersRecords(scope);
        List<BooksToWriters__c> junctionsToInsert = getNewBooksToWritersList(scope);
        insert junctionsToInsert;
    }

    public void finish(Database.BatchableContext bc){
        mailSend(Label.OnBooksProcessingFinishMailAdress);
        System.debug('Books batch finished');
        }

    public void execute(SchedulableContext sc){
        Database.executeBatch(this);
    }

    public List<BooksToWriters__c> getNewBooksToWritersList(List<Book__c> scope){
        Map<ID, List<ID>> booksToWritersAntiDuplicates = getBookAndWritersAntiDuplicateIds(scope);
        List<BooksToWriters__c> junctionsToInsert = new List<BooksToWriters__c>();
        for(Book__c book : scope){
            for(Writer__c writer : getWritersInBook(book)){
                if(booksToWritersAntiDuplicates.get(book.Id) == null || !booksToWritersAntiDuplicates.get(book.Id).contains(writer.Id)){
                    BooksToWriters__c junction = new BooksToWriters__c(Book__c = book.Id, Writer__c = writer.Id);
                    junctionsToInsert.add(junction);
                    recordsProcessed++;
                }
            }
        }
        return junctionsToInsert;
    }

    //Смотреть с осторожностью, метод может вызвать боль в глазах и желание сломать пальцы кодеру. Но на оптимизацию уже небыло времени.
    public Map<ID, List<ID>> getBookAndWritersAntiDuplicateIds(List<Book__c> scope){
        Map<ID, List<ID>> btwAntiDuplicates = new Map<ID, List<ID>>();
        Map<ID, List<BooksToWriters__c>> booksAndItsBtws = new Map<ID, List<BooksToWriters__c>>(); //Костыль :(
        List<BooksToWriters__c> booksToWriters = [SELECT Id, Book__c, Writer__c FROM BooksToWriters__c WHERE Book__c IN :getBooksIds(scope)];
        for(BooksToWriters__c btw : booksToWriters){
            if(btwAntiDuplicates.get(btw.Book__c) != null){
                btwAntiDuplicates.get(btw.Book__c).add(btw.Writer__c);
                booksAndItsBtws.get(btw.Book__c).add(btw);
            } else {
                //так и не понял как сразу засунуть список в Map, => тонна лишнего кода...
                List<BooksToWriters__c> btws = new List<BooksToWriters__c>();
                btws.add(btw);
                booksAndItsBtws.put(btw.Book__c, btws);
                List<ID> writesIds = new List<ID>();
                writesIds.add(btw.Writer__c);
                btwAntiDuplicates.put(btw.Book__c, writesIds);
                
            }
        }
        deleteExtraJunctions(booksAndItsBtws, scope);
        return btwAntiDuplicates;
    }

    //Метод как бы не мешает выполнению задачи, но он и не обязательный в данном контексте задачи. Без него код был бы значительно чище
    public void deleteExtraJunctions(Map<ID, List<BooksToWriters__c>> booksAndItsBtws, List<Book__c> scope){
        List<BooksToWriters__c> btwToDelete = new List<BooksToWriters__c>();
        for(Book__c book : scope){
            List<BooksToWriters__c> booksToWriters = booksAndItsBtws.get(book.Id);
            if(booksToWriters != null){
                    List<ID> writersIds = new List<ID>();
                for(Writer__c writer : getWritersInBook(book)){
                    writersIds.add(writer.Id);
                }
                for(BooksToWriters__c btw : booksToWriters){
                    if(!writersIds.contains(btw.Writer__c)){
                        btwToDelete.add(btw);
                    }
                }
            }
        }
        delete btwToDelete;
    }

    public List<ID> getBooksIds(List<Book__c> scope){
        List<ID> booksIds = new List<ID>();
        for(Book__c book : scope){
            booksIds.add(book.Id);
        }
        return booksIds;
    }

    public void insertNewWritersRecords(List<Book__c> scope){
        List<Writer__c> writersToInsert = new List<Writer__c>();
        for(Book__c book : scope){
            List<String> bookAuthors = book.Author__c.split(',');
            for(String author : bookAuthors){
                if(!writersNames.containsKey(author)){
                    Writer__c writer = new Writer__c(Name = author);
                    writersToInsert.add(writer);
                    writersNames.put(author, writer);
                }
            }
        }
        insert writersToInsert;
    }

    public List<Writer__c> getWritersInBook(Book__c book){
        List<Writer__c> writersInBook = new List<Writer__c>();
        List<String> bookAuthors = book.Author__c.split(',');
        for(String author : bookAuthors){
            Writer__c writer = new Writer__c();
            if(writersNames.containsKey(author)){
                writer = writersNames.get(author);
                writersInBook.add(writer);
            }
        }
        return writersInBook;
    }

    public void mailSend(String adress){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toaddresses = new String[] { adress };
        message.optOutPolicy = 'FILTER';
        message.subject = 'Assigning Writers to books';
        message.plainTextBody = (recordsProcessed + ' Links was created');
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
            }
    }

}