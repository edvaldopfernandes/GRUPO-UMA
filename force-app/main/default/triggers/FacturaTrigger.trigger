trigger FacturaTrigger on Factura__c (before insert, before update) {
    if(Trigger.IsInsert) {
        for(Factura__c factura : Trigger.new) {
            factura.Identificador_Factura__c = factura.Name;
        }
    } else if (Trigger.IsUpdate) {
        for(Id facturaId : Trigger.newMap.keySet()) {
            Factura__c factura = Trigger.newMap.get(facturaId);
            String newName = factura.Name;
            String oldName = Trigger.oldMap.get(facturaId).Name;
            if(!newName.equals(oldName)) {
                System.debug('Cambió el Identificador de factura');
                factura.Identificador_Factura__c = factura.Name;
            }
        }
    }
}