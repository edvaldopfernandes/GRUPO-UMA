trigger OpportunityTrigger on Opportunity (after insert) {
    Map<String,Financiamiento__c> mapFncs = new Map<String,Financiamiento__c>();
    for(Financiamiento__c fnc : [SELECT IdSolicitud__c,Cuenta__c,Oportunidad__c FROM Financiamiento__c WHERE Oportunidad__c = '']) {
        mapFncs.put(fnc.IdSolicitud__c, fnc);
    }
    List<Financiamiento__c> fncs = new List<Financiamiento__c>();
    for(Opportunity opp : Trigger.New) {
        if(mapFncs.containsKey(opp.IdSolicitud__c)) {
            Financiamiento__c fnc = mapFncs.get(opp.IdSolicitud__c);
            if(opp.AccountId == fnc.Cuenta__c) {
                fnc.Oportunidad__c = opp.Id;
            	fncs.add(fnc);
            }
        }
    }
    update fncs;
}