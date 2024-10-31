@RestResource(urlMapping='/maintenances/*')
global without sharing class CreateMaintenance {
    global class Response{
        public Boolean success;
        public Map<String, String> responseBody;
        
        public Response(Boolean success, String accId, String assetId, String maintenanceId){
            this.success = success;
            
            if(accId!=null)
            {
                responseBody = new Map<String, String>();
                responseBody.put('clientId', accId);
                responseBody.put('assetId', assetId);
                responseBody.put('maintenanceId', maintenanceId);
            }
        }
    }
    
    //private static Map<String,String> countryCodes = new Map<String,String>{'AR' => 'Argentina', 'CO' => 'Colombia', 'CR' => 'Costa Rica', 'SV' => 'El Salvador', 'GT' => 'Guatemala', 'HN' => 'Honduras', 'MX' => 'México', 'NI' => 'Nicaragua'};

    @HttpPost
    global static CreateMaintenance.Response processInvoice() {
        RestRequest request = RestContext.request;
        System.debug(request.requestBody.toString());
        Map<String, Object> payloadMap = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring()); 
        System.debug(JSON.serializePretty(payloadMap.get('customer')));
        System.debug(JSON.serializePretty(payloadMap.get('maintenances')));
        System.debug(JSON.serializePretty(payloadMap.get('vehicle')));
        //System.debug(payloadMap.get('customer'));
        Map<String, Object> customMap = (Map<String, Object>)payloadMap.get('customer');
        System.debug(customMap.get('name'));
        System.debug(customMap.get('country'));
        Map<String, Object> maintenanceMap = (Map<String, Object>)payloadMap.get('maintenances');
        String tipoOperacion = String.valueOf(maintenanceMap.get('type'));
        Map<String, Object> vehicleMap = (Map<String, Object>)payloadMap.get('vehicle');
        String documentNumber = String.valueOf(customMap.get('documentNumber'));//String.valueOf(inv.customer.get('documentNumber'));
        String documentType = String.valueOf(customMap.get('documentType'));//String.valueOf(inv.customer.get('documentType'));
        String fiscalDocumentNumber = String.valueOf(customMap.get('fiscalDocumentNumber'));
        String fiscalDocumentType = String.valueOf(customMap.get('fiscalDocumentType'));
        
        System.debug('Numero de documento: ' + documentNumber + ' Tipo de documento: '+ documentType);
        
        Account accresp = GetContactHelper.getTypeOfContact(documentNumber, documentType); 
        
        String department =+String.valueOf(customMap.get('department'));
        String municipio =String.valueOf(customMap.get('city'));
        String paisCodigoIso = String.valueOf(customMap.get('country'));
        List<Pais__c> countriesId = [SELECT Id,Name FROM Pais__c WHERE Codigo_ISO__c=:paisCodigoIso OR Name=:paisCodigoIso LIMIT 1];
        String paisId = countriesId.isEmpty()? null : countriesId[0].Id;
        List<Departamento__c> departmentsId = [SELECT Id,Name FROM Departamento__c WHERE Name = :department AND Pais_lookup__c = :paisId LIMIT 1];
        String departamentoId = departmentsId.isEmpty()? null : departmentsId[0].Id;
        List<Municipio__c> citiesId = [SELECT Id,Name FROM Municipio__c WHERE Name = :municipio AND Departamento_lookup__c = :departamentoId LIMIT 1];
        
        String paisName = countriesId.isEmpty()? null : countriesId[0].Name;
        String departamentoName = departmentsId.isEmpty()? null : departmentsId[0].Name;
        String municipioName = citiesId.isEmpty()? null : citiesId[0].Name;
        String municipioId = citiesId.isEmpty()? null : citiesId[0].Id;
        String clientId = '-1';
        System.debug('pais: ' + paisname);
        System.debug('paisId: ' + paisId);
        System.debug('departamento: ' + departamentoname);
        System.debug('departamentoId: ' + departamentoId);
        System.debug('municipio: ' + municipioname);
        System.debug('municipioId: ' + municipioId);
        
        if(accresp!=null)
        {
            clientId = accresp.Id;
            System.debug(accresp);
            
            if(accresp.Tipo_de_cuenta__c=='Persona Natural')
            {
                System.debug('Persona natural');
                accresp.FirstName = String.valueOf(customMap.get('name'));
                accresp.LastName = String.valueOf(customMap.get('lastName'));
                accresp.Pais__pc = paisId;//String.valueOf(customMap.get('country'));
                accresp.Pais_picklist__c = paisName;
                accresp.PersonMobilePhone = String.valueOf(customMap.get('cellphone'));
                accresp.PersonEmail = String.valueOf(customMap.get('email'));
                accresp.Departamento__c = departamentoId;//String.valueOf(customMap.get('department'));
                //accresp.PersonMailingAddress = String.valueOf(customMap.get('address'));
                accresp.ShippingStreet = String.valueOf(customMap.get('address'));
            	accresp.BillingStreet = String.valueOf(customMap.get('address'));
                accresp.Municipio__c = municipioId;//String.valueOf(customMap.get('city'));
                accresp.Autorizacion_Tratamiento_datos_personale__pc = Boolean.valueOf(customMap.get('personalDataProcessing'));
                accresp.CurrencyIsoCode = CurrencyHelper.getCurrencyISOCodeByCountryName(paisName);
            }
            else {
                System.debug('Empresa');
                accresp.Name = String.valueOf(customMap.get('name'))+' '+String.valueOf(customMap.get('lastName'));
                //accresp.LastName = String.valueOf(customMap.get('surname'));
                accresp.Pais__c = paisId;//String.valueOf(customMap.get('country'));
                accresp.Pais_picklist__c = paisName;
                accresp.Phone = String.valueOf(customMap.get('cellphone'));
                accresp.Correo_empresarial__c = String.valueOf(customMap.get('email'));
                accresp.Departamento__c = departamentoId;//String.valueOf(customMap.get('department'));
                //accresp.BillingAddress = String.valueOf(customMap.get('address'));
                accresp.ShippingStreet = String.valueOf(customMap.get('address'));
            	accresp.BillingStreet = String.valueOf(customMap.get('address'));
                accresp.Municipio__c = municipioId;//String.valueOf(customMap.get('city'));
                accresp.Autirzo_tratamiento_de_datos_personales__c = Boolean.valueOf(customMap.get('personalDataProcessing'));
                accresp.CurrencyIsoCode = CurrencyHelper.getCurrencyISOCodeByCountryName(paisName);
            }
            
            //Database.update(accresp, false);
            update accresp;
        }
        else{
            Account newacc = new Account();
            System.debug('Crea PA');
            newacc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
            newacc.FirstName = String.valueOf(customMap.get('name'));
            newacc.LastName = String.valueOf(customMap.get('lastName'));
            //newacc.LastName = String.valueOf(customMap.get('surname'));
            newacc.Pais__c = paisId;//String.valueOf(customMap.get('country'));
            newacc.Pais_picklist__c = paisName;
            newacc.Nro_de_Documento_de_Identificacion__c = String.valueOf(customMap.get('documentNumber'));
            newacc.Tipo_de_Documento_Identificacion__c = String.valueOf(customMap.get('documentType'));
            newacc.PersonMobilePhone = String.valueOf(customMap.get('cellphone'));
            newacc.PersonEmail = String.valueOf(customMap.get('email'));
            newacc.Departamento__c = departamentoId;//String.valueOf(customMap.get('department'));
            newacc.ShippingStreet = String.valueOf(customMap.get('address'));
            newacc.BillingStreet = String.valueOf(customMap.get('address'));
            //newacc.PersonMailingAddress = String.valueOf(customMap.get('address'));
            newacc.Municipio__c = municipioId;//String.valueOf(customMap.get('city'));
            newacc.Autorizacion_Tratamiento_datos_personale__pc = Boolean.valueOf(customMap.get('personalDataProcessing'));
            newacc.Tipo_de_cuenta__c = 'Persona Natural';
            newacc.CurrencyIsoCode = CurrencyHelper.getCurrencyISOCodeByCountryName(paisName);
            insert newacc;
            clientId = newacc.Id;
        }
        String vinNumber = String.valueOf(vehicleMap.get('VIN'));
        Decimal kilometraje = Decimal.valueOf(String.valueOf(maintenanceMap.get('mileage')));
        String anioModelo = String.valueOf(vehicleMap.get('modelYear'));
        String modelo = String.valueOf(vehicleMap.get('model'));
        String placa = String.valueOf(vehicleMap.get('plate'));
        String marca = String.valueOf(vehicleMap.get('brand'));
        
        String tipoServicio = String.valueOf(maintenanceMap.get('typeOfService'));
        Date fechaAperturaOrden = Date.valueOf(String.valueOf(maintenanceMap.get('orderOpeningDate')).split(' ').get(0));
        Date fechaCierreOrden = Date.valueOf(String.valueOf(maintenanceMap.get('orderCloseDate')).split(' ').get(0));
        String numeroOrden = String.valueOf(maintenanceMap.get('orderNumber'));
        String codigoTaller = String.valueOf(maintenanceMap.get('workshopCode'));
        String estadoFinal = String.valueOf(maintenanceMap.get('finalStatus'));
        
        String assetId = null;
        String mantenimientoId = null;
        if(tipoOperacion.equals('O')) {
            List<Activo__c> assets = [SELECT Id,KM_del_vehiculo__c FROM Activo__c WHERE Nro_VIN_Chasis__c = :vinNumber LIMIT 1];
            if(!assets.isEmpty()) {
                Activo__c asset = assets.get(0);
                asset.KM_del_vehiculo__c = kilometraje;
                asset.Placa_de_la_motocicleta__c = placa;
                assetId = asset.Id;
                update asset;
            } else {
                Activo__c asset = new Activo__c(Name=vinNumber,Nro_VIN_Chasis__c=vinNumber,KM_del_vehiculo__c=kilometraje,Modelo__c=modelo,Ano_del_modelo__c=anioModelo,Marca__c=marca,Placa_de_la_motocicleta__c=placa,Cliente__c=clientId);
                insert asset;
                assetId = asset.Id;
            }
            System.debug(assetId);
            List<Servicio__c> mantenimientos = [SELECT Id FROM Servicio__c WHERE Numero_de_orden__c = :numeroOrden LIMIT 1];
            if(mantenimientos.isEmpty()){
                Servicio__c mantenimiento = new Servicio__c(Name=numeroOrden,Tipo_de_servicio__c=tipoServicio,Fecha_de_apertura_orden__c=fechaAperturaOrden,Fecha_de_cierre_orden__c=fechaCierreOrden,Numero_de_orden__c=numeroOrden,Codigo_del_taller__c=codigoTaller,Estado_final__c=estadoFinal,Kilometraje__c=kilometraje,Cliente__c=clientId,Activo2__c=assetId,Referencia__c=modelo);
                insert mantenimiento;
                mantenimientoId = mantenimiento.Id;
            }
            //mantenimiento.Tipo_de_servicio__c = tipoServicio;
            //mantenimiento.Fecha_de_apertura_orden__c = fechaAperturaOrden;
            //mantenimiento.Fecha_de_cierre_orden__c = fechaCierreOrden;
            //mantenimiento.Numero_de_orden__c = numeroOrden;
            //mantenimiento.Codigo_del_taller__c = codigoTaller;
            //mantenimiento.Estado_final__c = estadoFinal;
        } else if(tipoOperacion.equals('A')){
            List<Servicio__c> mantenimientos = [SELECT Id FROM Servicio__c WHERE Numero_de_orden__c = :numeroOrden LIMIT 1];
            if(!mantenimientos.isEmpty()) {
                delete mantenimientos;
                return new CreateMaintenance.Response(true, clientId, assetId, 'Eliminado');
            }
        }
        return new CreateMaintenance.Response(true, clientId, assetId, mantenimientoId);
    }
    
}