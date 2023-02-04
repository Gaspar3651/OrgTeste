public class AnimalsCallouts {
    public static HttpResponse makeGetCallout() {
        Http http = new Http();

        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
        request.setMethod('GET');

        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        
        if(response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

            List<Object> animals = (List<Object>) results.get('animals');

            System.debug('====================== ANIMAIS ======================');

            for(Object item: animals){
                System.debug('=====================> ' + item);
            }
        }
        return response;
    }

    public static HttpResponse makePostCallout() {
        Http http = new Http();
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody('{"name":"BATATA"}');

        HttpResponse response = http.send(request);

        // Parse the JSON response
        if(response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

            List<Object> animals = (List<Object>) results.get('animals');

            System.debug('====================== ANIMAIS ======================');

            for(Object item: animals){
                System.debug('=====================> ' + item);
            }
        }

        return response;
    }        
}