public with sharing class GetPromotionsToQuote {

    private static String pais;
    private static String departamento;
    private static String municipio;
    private static String region;
    private static String marca;
    private static String modelo;
    private static String anoModelo;
    private static String financiera;
    private static String origen;

    private static User currentUser;
    private static PricebookEntry pricebookEntry;
    private static Opportunity opp;

    @InvocableMethod(label='Get Promotions to Quote')
    public static List<List<Promocion__c>> getPromotionsToQuote(List<String> params) {

        if(params.isEmpty()) return null;

        if(!params[0].contains(',')) return null;

        String pricebookEntryId = params[0].split(',')[0];
        String opportunityId = params[0].split(',')[1];

        currentUser = queryUser();
        pricebookEntry = queryPricebookEntry(pricebookEntryId);
        opp = queryOpportunity(opportunityId);

        mappingFiels();

        String query = 'SELECT Id, name, Activo__c, Pais__r.name, Departamento__r.name, Municipio__r.name, '+
        'Ano_Modelo__c, Marca__c, Descuento_Num_rico__c, Descuento_Porcentaje__c, '+
        'Financiera__r.name, Modelo__r.Name, Region__c, Fecha_de_Inicio__c, Fecha_Final__c,'+
        'Opportunity_Origen__c '+
        'FROM Promocion__c '+
        'WHERE Activo__c = TRUE AND Fecha_de_Inicio__c <= TODAY AND Fecha_Final__c >= TODAY '+
        'AND (Pais__r.Name LIKE \''+pais+'\' OR Pais__r.Name = NULL) ';

        if(currentUser.Region__c != null && currentUser.Departamento__c == null && currentUser.Municipio_Ciudad__c == null){
            query += 'AND (Region__c LIKE \''+region+'\' OR Region__c = NULL) ';
        }

        query += 'AND (Departamento__r.Name LIKE \''+departamento+'\' OR Departamento__r.Name = NULL) '+
        'AND (Municipio__r.Name LIKE \''+municipio+'\' OR Municipio__r.Name = NULL) '+
        'AND (Marca__c LIKE \''+marca+'\' OR Marca__c = NULL) '+
        'AND (Modelo__r.Name LIKE \''+modelo+'\' OR Modelo__r.Name = NULL) '+
        'AND (Ano_Modelo__c = \''+anoModelo+'\' OR Ano_Modelo__c = NULL) '+
        'AND (Financiera__r.Name LIKE \''+financiera+'\' OR Financiera__r.Name = NULL) '+
        'AND (Opportunity_Origen__c LIKE \''+origen+'\' OR Opportunity_Origen__c = NULL)';

        System.debug(query);

        List<Promocion__c> promotions = Database.query(query);

        return new List<List<Promocion__c>>{promotions};
    }

    private static void mappingFiels(){
        pais = treatAccentFields(currentUser?.Pais__c);
        departamento = treatAccentFields(currentUser?.Departamento__c);
        municipio = treatAccentFields(currentUser?.Municipio_Ciudad__c);
        region = treatAccentFields(currentUser?.Region__c);
        marca = treatAccentFields(pricebookEntry?.Marca__c);
        modelo = treatAccentFields(pricebookEntry?.Product2?.Modelo__r?.Name);
        anoModelo = treatAccentFields(pricebookEntry?.Product2?.A_o_Modelo__c);
        financiera = treatAccentFields(opp?.Financiera_Aliada__r.Name);
        origen = treatAccentFields(opp?.Origen_del_Lead__c);
    }

    private static String treatAccentFields(String value){
        if(value == null) return null;
        value = value.toLowerCase();
        value = value.replaceAll('a', '%');
        value = value.replaceAll('e', '%');
        value = value.replaceAll('i', '%');
        value = value.replaceAll('o', '%');
        value = value.replaceAll('u', '%');
        return value;
    }

    private static Opportunity queryOpportunity(Id opportunityId){
        List<Opportunity> opportunities = [
            SELECT Id, Name, Origen_del_Lead__c, Financiera_Aliada__r.Name 
            FROM Opportunity WHERE Id = :opportunityId
        ];

        if (opportunities.isEmpty()) return null;

        return opportunities[0];
    }

    private static PricebookEntry queryPricebookEntry(Id pricebookEntryId){
        List<PricebookEntry> pricebookEntries = [
            SELECT Id, Marca__c, Product2.A_o_Modelo__c, Product2.Modelo__r.Name
            FROM PricebookEntry WHERE Id = :pricebookEntryId
        ];

        if (pricebookEntries.isEmpty()) return null;

        return pricebookEntries[0];
    }

    private static User queryUser(){
        List<User> currentUserList = [
            SELECT Id, name, Pais__c, Departamento__c, Municipio_Ciudad__c, Region__c 
            FROM User WHERE Id = :UserInfo.getUserId()
        ]; 

        if(currentUserList.isEmpty()) return null;

        return currentUserList[0];
    }
}