@isTest
public class UpdateOpportunityStageTest {

    @TestSetup
    static void makeData(){
        insert new Pais__c(Name = 'Guatemala', Impuesto__c = 15, CurrencyIsoCode = 'USD', 
        Codigo_ISO__c = 'GT');
        insert new Pais__c(Name = 'El Salvador', Impuesto__c = 15, CurrencyIsoCode = 'USD', 
        Codigo_ISO__c = 'SV');
        insert new Financiamiento__c (IdSolicitud__c ='102031');
    }
    @isTest static void testProcessOpportunityFailure() {
        RestRequest request = new RestRequest();
        request.requestUri = 'https://grupouma2023--dev.sandbox.my.salesforce.com/services/apexrest/avanta-opportunities/';
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = [SELECT Body FROM StaticResource WHERE Name = 'mockupUpdateOpportunityStage' LIMIT 1][0].Body;
        RestContext.request = request;
        UpdateOpportunityStage.processOpportunities();
        //System.debug(response.responseBody.get('updateFailure'));
        //Assert.areEqual('Couldn\'t find opportunities to update.', response.responseBody.get('updateFailure'));
    }
    
    @isTest static void testProcessOpportunitySuccess() {
        List<Pais__c> paises = [SELECT Id,Name FROM Pais__c];
        Map<String,String> mapPaises = new Map<String,String>();
        for(Pais__c pais : paises) {
            mapPaises.put(pais.Name, pais.Id);
        }
        Id personaNaturalRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Account acc1 = new Account(RecordTypeId=personaNaturalRTId,
                                   Tipo_de_cuenta__c = 'Persona Natural',
                                   FirstName = 'Juan',
                                   MiddleName = 'Felipe',
                                   LastName = 'Gómez Hernández',
                                   Pais__c = mapPaises.get('Guatemala'),
                                   Pais_picklist__c = 'Guatemala',
                                   PersonMobilePhone = '12345678',
                                   Tipo_de_Documento_Identificacion__c = 'DPI',
                                   Nro_de_Documento_de_Identificacion__c = '2610026270301'
                                  );
        Account acc2 = new Account();
        acc2.RecordTypeId = personaNaturalRTId;
        acc2.Tipo_de_cuenta__c = 'Persona Natural';
        acc2.FirstName = 'Gabriel';
        acc2.MiddleName = 'Jaime';
        acc2.LastName = 'Diaz';
        acc2.PersonMobilePhone = '12345670';
        acc2.Pais__c = mapPaises.get('El Salvador');
        acc2.Pais_picklist__c = 'El Salvador';
        acc2.Tipo_de_Documento_Identificacion__c = 'DUI';
        acc2.Nro_de_Documento_de_Identificacion__c = '123456789';
        insert new List<Account>{acc1,acc2};
        Opportunity opp1 = new Opportunity();
        opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AVANTA').getRecordTypeId();
        opp1.Name = 'Nombre';
        opp1.StageName = 'Inicio';
        opp1.CloseDate = System.today() + 1;
        opp1.AccountId = acc1.Id;
        Opportunity opp2 = new Opportunity();
        opp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AVANTA').getRecordTypeId();
        opp2.Name = 'Nombre2';
        opp2.StageName = 'Inicio';
        opp2.CloseDate = System.today() + 1;
        opp2.AccountId = acc2.Id;
        opp2.IdSolicitud__c = '102031';
        insert new List<Opportunity>{opp1,opp2};
        RestRequest request = new RestRequest();
        request.requestUri = 'https://grupouma2023--dev.sandbox.my.salesforce.com/services/apexrest/avanta-opportunities/';
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = [SELECT Body FROM StaticResource WHERE Name = 'mockupUpdateOpportunityStage' LIMIT 1][0].Body;
        RestContext.request = request;
        UpdateOpportunityStage.processOpportunities();
        List<Id> oppIds = new List<Id>{opp1.Id, opp2.Id};
        Map<Id,Opportunity> stageMap = new Map<Id,Opportunity>([SELECT Id,StageName,IdSolicitud__c FROM Opportunity WHERE Id IN :oppIds]);
       // System.assertEquals('RECHAZADO'.toLowercase(), stageMap.get(opp1.Id).StageName.toLowercase());
       // System.assertEquals('102030', stageMap.get(opp1.Id).IdSolicitud__c);
       // System.assertEquals('APROBADO'.toLowercase(), stageMap.get(opp2.Id).StageName.toLowercase());
    }
    
    @isTest static void testProcessOpportunityNoUpdates() {
        List<Pais__c> paises = [SELECT Id,Name FROM Pais__c];
        Map<String,String> mapPaises = new Map<String,String>();
        for(Pais__c pais : paises) {
            mapPaises.put(pais.Name, pais.Id);
        }
        Id personaNaturalRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Account acc1 = new Account(RecordTypeId=personaNaturalRTId,
                                   Tipo_de_cuenta__c = 'Persona Natural',
                                   FirstName = 'Juan',
                                   MiddleName = 'Felipe',
                                   LastName = 'Gómez Hernández',
                                   Pais__c = mapPaises.get('Guatemala'),
                                   Tipo_de_Documento_Identificacion__c = 'DPI',
                                   Pais_picklist__c = 'Guatemala',
                                   PersonMobilePhone = '12345678',
                                   Nro_de_Documento_de_Identificacion__c = '2610026270301'
                                  );
        Account acc2 = new Account();
        acc2.RecordTypeId = personaNaturalRTId;
        acc2.Tipo_de_cuenta__c = 'Persona Natural';
        acc2.FirstName = 'Gabriel';
        acc2.MiddleName = 'Jaime';
        acc2.LastName = 'Diaz';
        acc2.Pais__c = mapPaises.get('El Salvador');
        acc2.Pais_picklist__c = 'El Salvador';
        acc2.PersonMobilePhone = '12345670';
        acc2.Tipo_de_Documento_Identificacion__c = 'DUI';
        acc2.Nro_de_Documento_de_Identificacion__c = '123456783';
        insert new List<Account>{acc1,acc2};
        Opportunity opp1 = new Opportunity();
        opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('UMA').getRecordTypeId();
        opp1.Name = 'Nombre';
        opp1.StageName = 'Inicio';
        opp1.CloseDate = System.today() + 1;
        opp1.AccountId = acc1.Id;
        Opportunity opp2 = new Opportunity();
        opp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AVANTA').getRecordTypeId();
        opp2.Name = 'Nombre2';
        opp2.StageName = 'Inicio';
        opp2.CloseDate = System.today() + 1;
        opp2.AccountId = acc2.Id;
        opp2.IdSolicitud__c = '102039';
        insert new List<Opportunity>{opp1,opp2};
        RestRequest request = new RestRequest();
        request.requestUri = 'https://grupouma2023--dev.sandbox.my.salesforce.com/services/apexrest/avanta-opportunities/';
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = [SELECT Body FROM StaticResource WHERE Name = 'mockupUpdateOpportunityStage' LIMIT 1][0].Body;
        RestContext.request = request;
        UpdateOpportunityStage.processOpportunities();
        //System.debug(response.responseBody.get('updateFailure'));
        //Assert.areEqual('Couldn\'t find opportunities to update.', response.responseBody.get('updateFailure'));
    }
}