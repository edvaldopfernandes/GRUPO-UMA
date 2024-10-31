trigger ActivoTrigger on Activo__c (before insert, before update) {
    if(Trigger.IsInsert) {
        for(Activo__c activo : Trigger.new) {
            activo.Nro_VIN_Chasis__c = activo.Name;
        }
    } else if (Trigger.IsUpdate) {
        for(Id activoId : Trigger.newMap.keySet()) {
            Activo__c activo = Trigger.newMap.get(activoId);
            String newName = activo.Name;
            String oldName = Trigger.oldMap.get(activoId).Name;
            if(!newName.equals(oldName)) {
                System.debug('Cambió el Nro Vin del activo');
                activo.Nro_VIN_Chasis__c = activo.Name;
            }
        }
    }
}