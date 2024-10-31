@isTest
public class AvantaFinancingTest {

    @TestSetup
    static void makeData(){
        insert new Pais__c(Name = 'Guatemala', Impuesto__c = 15, CurrencyIsoCode = 'USD', 
        Codigo_ISO__c = 'GT');
    }

    @isTest static void testCallout() {
        RestRequest request = new RestRequest();
        request.requestUri = 'https://grupouma2023--dev.sandbox.my.salesforce.com/services/apexrest/avanta-financing/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = [SELECT Body FROM StaticResource WHERE Name = 'mockupMambu' LIMIT 1][0].Body;
        RestContext.request = request;
        Test.startTest();
        AvantaFinancing.Response response = AvantaFinancing.getCsv();
        CurrencyHelper.getCurrencyISOCodeByCountryName('Colombia');
        Test.stopTest();
        System.assertEquals(1, [SELECT count() FROM Account]);
        System.assertEquals(2, [SELECT count() FROM Financiamiento__c]);
        System.assertEquals(4, [SELECT count() FROM Pago__c]);
    }
}