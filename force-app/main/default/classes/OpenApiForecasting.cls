public with sharing class OpenApiForecasting {
    

    public string city{get;set;}
    public string preasure{get;set;}

    public OpenApiForecasting(Apexpages.StandardController controller){
        
        Account account = (Account)controller.getRecord();
        account = [SELECT Id , ShippingCity from Account where Id =:account.id];
        
        String accountcity = account.ShippingCity;
        String apikey = '4096a5cf1ad39823ec1cb9b365fb854c';
        //4096a5cf1ad39823ec1cb9b365fb854c
        
        String reqEndPoint = 'http://api.openweathermap.org/data/2.5/weather';
        reqEndPoint +='?q='+ accountcity;
        reqEndPoint += '&units=metric';
        reqEndPoint += '&APPID='+ apikey;
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(reqEndPoint);
        request.setMethod('Get');
        
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200){
            
            Map<String, Object> result =  (Map<String, Object>)Json.deserializeUntyped(response.getBody());
            city = String.valueOf(result.get('name'));
            
            Map<String, Object> mainres = (Map<String , Object>)result.get('main');
            preasure = String.valueOf(mainres.get('preasure'));
           
        }
        else{
            
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'there is an error');
            ApexPages.addMessage(msg);
        }
        
    }


}
