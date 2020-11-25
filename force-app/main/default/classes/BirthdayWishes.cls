public with sharing class BirthdayWishes  implements Database.Batchable{
    
    global Iterable<Account> start(Database.BatchableContext bc){

        list<Account> cusomerslit=[select Name ,Email__c from Account where Date_of_Birth__c=today];
        return cusomerslit;

    }

    global  void execute(Database.BatchableContext bc, List<Account> lst){

        list<Messaging.SingleEmailMessage> mail = new list<Messaging.SingleEmailMessage>();

        for(Account e: lst)
        {
         Messaging.SingleEmailMessage maileach = new Messaging.SingleEmailMessage();

         list<string> toadd=new list<string>();
         toadd.add(e.Email__c);

          maileach.settoaddresses(toadd);
          maileach.setsubject('birthday wishes');
          maileach.setplaintextbody('happy birthday : '+e.Name);
          mail.add(maileach);
        }

        Messaging.SendEmailResult[]  result  = Messaging.sendEmail( mail);
    }
    global  void finish(Database.BatchableContext sc) 
   
    {
      system.debug(sc);
    
    }
      

}
