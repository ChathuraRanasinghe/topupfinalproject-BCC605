public with sharing class weatherapp {
    

    public String city{get; set;}
    //  public String temp{get; set;}
   public String preasure{get; set;}
    public String humidity{get; set;}
   public String temp_min{get; set;}
    public String temp_max{get; set;}
                    
    public weatherapp(ApexPages.StandardController controller){
        
      Account account =  (Account)controller.getRecord();
        account = [SELECT Id , ShippingCity from Account where Id =:account.id];
        
        String accountcity = account.ShippingCity;
        String apikey = '4096a5cf1ad39823ec1cb9b365fb854c';
       
       String reqEndPoint = 'http://api.openweathermap.org/data/2.5/weather';
        reqEndPoint +='?q='+accountcity;
        reqEndPoint += '&units=metric';
        reqEndPoint += '&APPID=' + apikey;
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(reqEndPoint);
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200){
            
            Map<String , Object> results = (Map<String , Object>)JSON.deserializeUntyped(response.getBody());
            city = String.valueOf(results.get('name'));
    
            Map<String, Object> mainres = (Map<String , Object>)results.get('main');
            preasure = String.valueOf(mainres.get('preasure'));
            humidity = String.valueOf(mainres.get('humidity'));
           temp_min = String.valueOf(mainres.get('temp_min'));
            temp_max = String.valueOf(mainres.get('temp_max'));
        } 
        else{
            
            ApexPages.Message mymsg = new ApexPages.Message(ApexPages.Severity.ERROR , 'there is an error');
            ApexPages.addMessage(mymsg);
        }
    }

}
