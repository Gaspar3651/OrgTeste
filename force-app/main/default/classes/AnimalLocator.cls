public with sharing class AnimalLocator {
    public static String getAnimalNameById(Integer num) {
        Http http = new Http();

        HttpRequest request = new HttpRequest();
        String endpoint = 'https://th-apex-http-callout.herokuapp.com/animals/' + num;
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200) {

            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

            List<Object> animal = (List<Object>) results.get('animals');
            System.debug(animal);
        }
        
        return 'name';     
    }
}