public class InsertLeads implements Queueable {
    private Map<String,Map<String,String>> csvMap;
    
    public InsertLeads(Map<String,Map<String,String>> csvMap) {
        this.csvMap = csvMap;
    }
    
    public void execute(QueueableContext context) {
        List<Lead> leads = new List<Lead>();
        for(Map<String,String> leadRow : this.csvMap.values()) {
            Lead lead = new Lead();
            lead.FirstName = leadRow.get('firstname');
            lead.LastName = leadRow.get('lastname');
            lead.Email = leadRow.get('email');
            leads.add(lead);
        }
        insert leads;
    }
}