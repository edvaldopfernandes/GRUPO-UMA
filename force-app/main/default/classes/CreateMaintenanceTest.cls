@isTest
private class CreateMaintenanceTest {
   @TestSetup
   static void makeData(){
    insert new Pais__c(Name = 'Guatemala', Impuesto__c = 15, CurrencyIsoCode = 'USD', 
    Codigo_ISO__c = 'GT');
    insert new Pais__c(Name = 'El Salvador', Impuesto__c = 15, CurrencyIsoCode = 'USD', 
    Codigo_ISO__c = 'SV');
   }

    @isTest 
    static void testMaintenance() {
        RestRequest request = new RestRequest();
        request.requestUri = 'https://grupouma2023--dev.sandbox.my.salesforce.com/services/apexrest/maintenances/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = [SELECT Body FROM StaticResource WHERE Name = 'mockupCreateMaintenance' LIMIT 1][0].Body;
        RestContext.request = request;
        CreateMaintenance.Response response = CreateMaintenance.processInvoice();
        Account acc = [SELECT Id FROM Account];
        Assert.areEqual(acc.Id, response.responseBody.get('clientId'));
        Activo__c activo = [SELECT Id,Name FROM Activo__c LIMIT 1];
        activo.Name = 'MD2A21BX1NWC86923';
        update activo;
    }

    @isTest 
    static void testMaintenanceTwo() {
        Pais__c pais = [SELECT Id FROM Pais__c WHERE Name = 'Guatemala'];
        insert new Account(FirstName = 'Test Account' ,MiddleName = 'MiddleName' ,LastName = 'LastName',
        Pais__c = pais.Id,Pais_picklist__c = 'Guatemala',Nro_de_Documento_de_Identificacion__c = '632598450' ,
        Tipo_de_Documento_Identificacion__c = 'DPI',Nro_de_Documento_de_Tributario__c = '632598450',Tipo_de_Documento_Tributario__c = 'NIT',
        PersonMobilePhone = '12345670', PersonEmail = 'mail@mail.com',Autorizacion_Tratamiento_datos_personale__pc = true ,
        Tipo_de_cuenta__c = 'Persona Natural',Fecha_nacimiento__c = Date.today(),Genero__c = 'Masculino', BillingStreet = 'Bill St.',
        ShippingStreet = 'Shipping St');
       // WHERE Nro_de_Documento_de_Tributario__c = :documentNumber AND 
       //Tipo_de_Documento_Tributario__c= :documentType AND 
       //Tipo_de_cuenta__c='Persona Natural'<
        RestRequest request = new RestRequest();
        request.requestUri = 'https://grupouma2023--dev.sandbox.my.salesforce.com/services/apexrest/maintenances/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = [SELECT Body FROM StaticResource WHERE Name = 'mockupCreateMaintenance' LIMIT 1][0].Body;
        RestContext.request = request;
        CreateMaintenance.Response response = CreateMaintenance.processInvoice();
        Account acc = [SELECT Id FROM Account WHERE FirstName != 'Test Account'];
        Assert.areEqual(acc.Id, response.responseBody.get('clientId'));
    }

}