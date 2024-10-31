@isTest
private class GetContactWSTest {
   @TestSetup
   static void makeData(){
    
   }

    @isTest 
    static void testGetContactWSFailure() {
        RestRequest request = new RestRequest();
        request.requestUri = 'https://grupouma2023--dev.sandbox.my.salesforce.com/services/apexrest/contacts-accounts/';
        request.httpMethod = 'GET';
        RestContext.request = request;
        GetContactWS.Response response = GetContactWS.getContact();
        Assert.areEqual(false, response.success);
    }

    @isTest 
    static void testGetContactWSSuccessNatural() {
        insert new Account(Autirzo_tratamiento_de_datos_personales__c = true, Autorizacion_Tratamiento_datos_personale__c = true,
                            Tipo_de_Documento_Identificacion__c = 'ID' , Nro_de_Documento_de_Identificacion__c = '2365894',
                            Pais_picklist__c = 'Honduras', PersonMobilePhone = '12345678',
                            FirstName = 'Test acc', LastName = 'Test', Tipo_de_cuenta__c='Persona Natural',
                            RecordTypeId = Account.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId());

        List<Account> prsonaccs1 = [SELECT Id FROM Account]; //WHERE Nro_de_Documento_de_Identificacion__c = :'2365894' AND Tipo_de_Documento_Identificacion__c = :'ID' AND Tipo_de_cuenta__c='Persona Natural' LIMIT 1];
        system.debug('ENCONTRADO ' + prsonaccs1[0]);
        RestRequest request = new RestRequest();
        request.requestUri = 'https://grupouma2023--dev.sandbox.my.salesforce.com/services/apexrest/contacts-accounts/';
        request.addParameter('documentNumber', '2365894');
        request.addParameter('documentType', 'ID');
        request.httpMethod = 'GET';
        RestContext.request = request;
        GetContactWS.Response response = GetContactWS.getContact();
        Assert.areEqual(true, response.success);
    }

    @isTest 
    static void testGetContactWSSuccessEmpresa() {
        insert new Account(Autirzo_tratamiento_de_datos_personales__c = true, Autorizacion_Tratamiento_datos_personale__c = true,
                            Tipo_de_Documento_Tributario__c = 'RTN' , Nro_de_Documento_de_Tributario__c = '2365894',
                            Pais_picklist__c = 'Honduras', PersonMobilePhone = '12345678',
                            FirstName = 'Test acc', LastName = 'Test', Tipo_de_cuenta__c='Empresa',
                            RecordTypeId = Account.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId());

        List<Account> prsonaccs1 = [SELECT Id FROM Account]; //WHERE Nro_de_Documento_de_Identificacion__c = :'2365894' AND Tipo_de_Documento_Identificacion__c = :'ID' AND Tipo_de_cuenta__c='Persona Natural' LIMIT 1];
        system.debug('ENCONTRADO ' + prsonaccs1[0]);
        RestRequest request = new RestRequest();
        request.requestUri = 'https://grupouma2023--dev.sandbox.my.salesforce.com/services/apexrest/contacts-accounts/';
        request.addParameter('documentNumber', '2365894');
        request.addParameter('documentType', 'RTN');
        request.httpMethod = 'GET';
        RestContext.request = request;
        GetContactWS.Response response = GetContactWS.getContact();
        Assert.areEqual(true, response.success);
    }

}