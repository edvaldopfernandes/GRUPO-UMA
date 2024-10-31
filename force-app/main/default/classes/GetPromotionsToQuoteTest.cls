@isTest
public with sharing class GetPromotionsToQuoteTest {

    @IsTest
    private static void testGetPromotionsToQuoteWithValidParams() {

        System.runAs(new User(Id=UserInfo.getUserId())) {
            User myUser = new User(
                Id = UserInfo.getUserId(),
                Pais__c = 'Colombia',
                Departamento__c = 'Antioquia',
                Municipio_Ciudad__c = 'Medellin',
                Region__c = 'Centro'
            );
            update myUser;
        }

        Opportunity opp = createOpportunity();
        insert opp;

        Modelo__c model = createModel();
        insert model;

        Product2 prd = createProduct(model.Id);
        insert prd;

        PricebookEntry pbe = createPricebookEntry(prd.Id);
        insert pbe;

        createPromotion(model.Id);

        Test.startTest();
        List<List<Promocion__c>> result = GetPromotionsToQuote.getPromotionsToQuote(new List<String>{pbe.Id + ',' + opp.Id});
        Test.stopTest();

        System.assertEquals(false, result.isEmpty());
        System.assertEquals(false, result[0].isEmpty());
        System.assertEquals('Promoción de Descuento', result[0][0].Name);
    }

    private static void createPromotion(Id modelId){
        Pais__c pais = new Pais__c(
            Name = 'Colombia',
            Codigo_ISO__c = '12'
        );
        insert pais;

        Departamento__c dpto = new Departamento__c(
            Name = 'Antioquia'
        );
        insert dpto;

        Municipio__c city = new Municipio__c(
            Name = 'Medellin'
        );
        insert city;

        Promocion__c promotion = new Promocion__c(
            Name = 'Promoción de Descuento',
            Fecha_de_Inicio__c = System.Today(),
            Fecha_Final__c = System.Today() + 10,
            Pais__c = pais.Id,
            Departamento__c = dpto.Id,
            Municipio__c = city.Id,
            Region__c = 'Centro',
            Marca__c = 'Bajaj',
            Modelo__c = modelId,
            Ano_Modelo__c = '2024'
        );
        insert promotion;
    }

    private static Modelo__c createModel(){
        return new Modelo__c(
            Name = 'BOXER 150X',
            A_o_Modelo__c = '2024',
            Paises_donde_se_vende__c = 'Colombia'
        );
    }

    private static Product2 createProduct(Id modelId){
        return new Product2(
            Name = 'Test Product',
            Modelo__c = modelId,
            A_o_Modelo__c = '2024',
            Marca__c = 'Bajaj',
            Region__c = 'Colombia'
        );
    }

    private static PricebookEntry createPricebookEntry(Id prdId){
        return new PricebookEntry(
            UnitPrice = 100.00,
            Product2Id = prdId,
            Pricebook2Id = Test.getStandardPricebookId()
        );
    }

    private static Opportunity createOpportunity(){
        return new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = System.Today()
        );
    }
}