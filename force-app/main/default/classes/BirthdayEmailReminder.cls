public with sharing class BirthdayEmailReminder implements Schedulable {
    

    global void execute (SchedulableContext ctx) {
        sendBirthdayEmail();
    }

    public static void sendBirthdayEmail() {
        
        //EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where Id = '00Xp0000000XRhY'];
        EmailTemplate emailTemplate = [select Id, Subject,Name, HtmlValue, Body from EmailTemplate where Name = 'Notify Birthday from TimeTrigger'];
        
        system.debug('emailTemplate @@@@' + emailTemplate.Name);
        
       List<Account> contaclist =  [SELECT Id,OwnerId,Name,Email__c,MobilePhone, Owner,
                                     Birthdate FROM Account 
                                    WHERE Birthdate = : system.Today().addDays(1)];
        
       
        
      Birthday_Alert__mdt bdalerts = [Select Email_1__c, Email_2__c, BCC1__c from Birthday_Alert__mdt];
        
        String toaddress1 = bdalerts.Email_1__c;
        String toaddress2 = bdalerts.Email_2__c;
        String bccaddress1 = bdalerts.BCC1__c;
        
                
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        for(Contact c :contaclist ){
            
            // Email Subject
            String subject = emailTemplate.Subject;
            if(c.Name != null){
                subject = subject.replace('{!Account.Name}', c.Name); 
            }else{
                subject = subject.replace('{!Account.Name}', 'Not Defined'); 
            }
        
            
            // Email Body
            
            String plainBody = emailTemplate.Body;
            
            plainBody = plainBody.replace('{!Contact.Birthdate}', String.valueOf(c.Birthdate));
            
            if(c.Name != null){
               plainBody = plainBody.replace('{!Account.Name}', c.Name ); 
            }else{
                plainBody = plainBody.replace('{!Account.Name}', 'Not Defined' );  
            }
            
            
            if(c.Email != null){
                plainBody = plainBody.replace('{!Account.Email__c}', c.Email__c);
              }else{
					plainBody = plainBody.replace('{!Account.Email__c}', 'Not Defined'); 
               }
            
            if(c.MobilePhone != null){
                plainBody = plainBody.replace('{!Account.MobilePhone}', c.MobilePhone);
            }else{
                plainBody = plainBody.replace('{!Account.MobilePhone}', 'Not Defined');
            }
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(c.OwnerId);
            mail.setSaveAsActivity(false);
            mail.setCcAddresses(new String[]{ toaddress1, toaddress2 });
            
            if(bccaddress1 != null){
            	mail.setBccAddresses(new String[]{bccaddress1 });    
            }
            
            mail.setSubject(subject);
            mail.setPlainTextBody(plainBody);
            mails.add(mail);  
            
        }
        if(mails.size() > 0){
             Messaging.sendEmail(mails, false);
        }
    }

}
