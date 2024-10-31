@isTest
public with sharing class TestQuotePDFController {

    @TestSetup
    static void makeData(){
        Account acc = new Account(Name = 'Test');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'Test Opp', StageName = 'Open',AccountId = acc.Id, CloseDate = Date.today());
        insert opp;
        Quote qt = new Quote(Name = 'Test quote', OpportunityId = opp.Id, Pricebook2Id = Test.getStandardPricebookId());
        insert qt;
        Product2 prod = new Product2(Name = 'Test Prod', Impuesto_de_Consumo__c = null);
        insert prod;
        PricebookEntry pbe = new PricebookEntry(Product2Id = prod.Id, Pricebook2Id = Test.getStandardPricebookId(), UnitPrice = 0, IsActive = true);
        insert pbe; 
        insert new QuoteLineItem(QuoteId = qt.Id, PricebookEntryId = pbe.Id, UnitPrice = 10, Quantity = 3, Items_Adicionales__c = 0) ;
        
    }
    @isTest
    static void testQuotePDFController() {

        Test.setCurrentPage(Page.CotizacionPDF);
        Quote qt = [SELECT Id FROM Quote];
        
        Test.StartTest(); 
            ApexPages.StandardController qtController = new ApexPages.StandardController(qt);
			ApexPages.currentPage().getParameters().put('id', String.valueOf(qt.Id));
			QuotePDFController  controller = new QuotePDFController(qtController);
		Test.StopTest();
    }
}