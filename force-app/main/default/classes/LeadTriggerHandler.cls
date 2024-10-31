public with sharing class LeadTriggerHandler {
    final List<Lead> newLeads;

    public LeadTriggerHandler(List<Lead> newLeads) {
        this.newLeads = newLeads;
    }

    public void beforeInsert(){
        for (Lead Lead : newLeads) {
            if(lead.Municipio_lead__c != null)
                lead.Municipio_lead__c = lead.Municipio_lead__c.replace(' - ', '-');
        }
    }
}