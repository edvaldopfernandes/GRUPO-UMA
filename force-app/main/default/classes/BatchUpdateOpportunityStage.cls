public with sharing class BatchUpdateOpportunityStage implements Database.Batchable<Object>, Database.Stateful {

    List<Object> jsonItems;

    public BatchUpdateOpportunityStage(List<Object> jsonItems) {
        this.jsonItems = jsonItems;
    }

    public Iterable<Object> start(Database.BatchableContext bc){
        return jsonItems;
    }

    public void execute(Database.BatchableContext bc, List<Object> jsonItems){
        UpdateOpportunityStage.processOpportunity(jsonItems);
    }

    public void finish(Database.BatchableContext bc){}

}