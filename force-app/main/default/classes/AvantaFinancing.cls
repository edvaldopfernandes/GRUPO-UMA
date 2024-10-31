@RestResource(urlMapping='/avanta-financing/*')
global without sharing class AvantaFinancing {
    
    global class Response{
        String message;
        
        public Response(){
            this.message = 'Asynchronous processing started...';
        }
    }
    @HttpPost
    global static Response getCsv() {
        RestRequest request = RestContext.request;
        Map<String,Map<String,String>> csvMap = CsvToMap.ConvertToMap(request.requestBody.toString());
        System.debug(JSON.serializePretty(csvMap));
        Id jobId = System.enqueueJob(new CsvFinancing(csvMap));
        return new AvantaFinancing.Response();
    }
    
}