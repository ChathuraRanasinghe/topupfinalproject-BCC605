public with sharing class SendWishestoBirthdayCelebraties {

    global   void execute(SchedulableContext dc){
        //batch class name   
         BirthdayWishes birthday =new BirthdayWishes ();
            Database.executeBatch(birthday,20);
            
            }

}
