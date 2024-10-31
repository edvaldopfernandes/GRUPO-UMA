trigger LeadTrigger on Lead (before insert) {
    LeadTriggerHandler handler = new LeadTriggerHandler(Trigger.new);
    handler.beforeInsert();
}