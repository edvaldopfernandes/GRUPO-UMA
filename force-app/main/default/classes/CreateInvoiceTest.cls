@isTest
private class CreateInvoiceTest {
   
    @TestSetup 
    static void makeData() {
        insert new Pais__c(Name = 'Guatemala', Impuesto__c = 15, CurrencyIsoCode = 'USD', 
        Codigo_ISO__c = 'GT');
        insert new Pais__c(Name = 'El Salvador', Impuesto__c = 15, CurrencyIsoCode = 'USD', 
        Codigo_ISO__c = 'SV');
    }

    @isTest 
    static void testCreateInvoice() {
        RestRequest request = new RestRequest();
        request.requestUri = 'https://grupouma2023--dev.sandbox.my.salesforce.com/services/apexrest/invoice/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = [SELECT Body FROM StaticResource WHERE Name = 'mockupCreateInvoice' LIMIT 1][0].Body;
        RestContext.request = request;
        CreateInvoice.Response response = CreateInvoice.processInvoice();
        Account acc = [SELECT Id FROM Account];
        Assert.areEqual(acc.Id, response.responseBody.get('clientId'));
       	Factura__c factura = [SELECT Id,Name FROM Factura__c LIMIT 1];
        factura.Name = '124023N';
        update factura;
    }

    @isTest 
    static void testCreateInvoice2() {
        RestRequest request = new RestRequest();
        request.requestUri = 'https://grupouma2023--dev.sandbox.my.salesforce.com/services/apexrest/invoice/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = [SELECT Body FROM StaticResource WHERE Name = 'mockupCreateInvoice2' LIMIT 1][0].Body;
        RestContext.request = request;
        CreateInvoice.Response response = CreateInvoice.processInvoice();
        Account acc = [SELECT Id FROM Account];
        CreateInvoice crt = new CreateInvoice();
        Assert.areEqual(acc.Id, response.responseBody.get('clientId'));
    }

}