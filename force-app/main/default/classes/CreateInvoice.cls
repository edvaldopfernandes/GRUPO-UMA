@RestResource(urlMapping='/invoice/*')
global without sharing class CreateInvoice {
    public CreateInvoice() {
    }
    
    public class Invoice{
        Map<String, Object> customer;
        Map<String, Object> vehicle;
        Map<String, Object> invoice;  
    }
    
    /*public class customer1
{
"name":"",
"surname":"",
"documentNumber":"",
"documentType":"",
"fiscalDocumentNumber":"",
"fiscalDocumentType":"",
"cellphone":"",
"email":"",
"city":"",
"personalDataProcessing":boolean

}*/
    
    global class Response{
        public Boolean success;
        public Map<String, String> responseBody;
        
        public Response(Boolean success, String accId, String prospectClientId, String oppId, String assetId, String invoiceId){
            this.success = success;
            
            if(accId!=null)
            {
                responseBody = new Map<String, String>();
                responseBody.put('clientId', accId);
                responseBody.put('assetId', assetId);
                responseBody.put('invoiceId', invoiceId);
                responseBody.put('opportunityId', oppId);
                responseBody.put('prospectClientId',prospectClientId);
            }
        }
    }
    
    @HttpPost
    global static CreateInvoice.Response processInvoice() {
        RestRequest request = RestContext.request;
        System.debug(request.requestBody.toString());
        List<Pricebook2> upsertPricebookList = new List<Pricebook2>();
        List<Response> responseList = new List<Response>();
        
        Map<String, Object> invMap = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        
        System.debug(JSON.serializePretty(invMap.get('customer')));
        System.debug(JSON.serializePretty(invMap.get('vehicle')));
        System.debug(JSON.serializePretty(invMap.get('invoice')));
        
        Map<String, Object> customMap = (Map<String, Object>)invMap.get('customer');
        System.debug(customMap.get('name'));
        System.debug(customMap.get('country'));
        
        /*CreateInvoice.Response newresp = new CreateInvoice.Response(false, null);
return newresp;
Invoice inv = (Invoice) JSON.deserialize(request.requestbody.tostring(), Invoice.class);
System.debug('Invoice: '+inv);*/
        
        String documentNumber = String.valueOf(customMap.get('documentNumber'));//String.valueOf(inv.customer.get('documentNumber'));
        String documentType = String.valueOf(customMap.get('documentType'));//String.valueOf(inv.customer.get('documentType'));
        String fiscalDocumentNumber = String.valueOf(customMap.get('fiscalDocumentNumber'));
        String fiscalDocumentType = String.valueOf(customMap.get('fiscalDocumentType'));
        String cellphone = String.valueOf(customMap.get('cellphone'));
        String clientType = String.valueOf(customMap.get('clientType'));
        
        System.debug('Numero de documento: ' + documentNumber + ' Tipo de documento: '+documentType);
        
        Account accresp = GetContactHelper.getContactByCellphone(cellphone,clientType);
        if(accresp == null) {
            accresp = GetContactHelper.getContactInvoice(documentNumber, documentType, fiscalDocumentNumber, fiscalDocumentType, String.valueOf(customMap.get('clientType')));
        }
        String department = null;
        if(!String.valueOf(customMap.get('department')).equals('')) {
            department =String.valueOf(customMap.get('department'));            
        }
        String municipio = null;
        if(!String.valueOf(customMap.get('city')).equals('')) {
            municipio =String.valueOf(customMap.get('city'));
        }
        
        String paisValor = String.valueOf(customMap.get('country'));
        List<Pais__c> countriesId = [SELECT Id,Name FROM Pais__c WHERE Name =:paisValor OR Codigo_ISO__c = :paisValor LIMIT 1];
        String paisId = countriesId.isEmpty()? null : countriesId[0].Id;
        List<Departamento__c> departmentsId = [SELECT Id,Name FROM Departamento__c WHERE Name = :department AND Pais_lookup__c = :paisId LIMIT 1];
        String departamentoId = departmentsId.isEmpty()? null : departmentsId[0].Id;
        List<Municipio__c> citiesId = [SELECT Id,Name FROM Municipio__c WHERE Name = :municipio AND Departamento_lookup__c = :departamentoId LIMIT 1];
        
        String paisName = countriesId.isEmpty()? null : countriesId[0].Name;
        String departamentoname = departmentsId.isEmpty()? null : departmentsId[0].Name;
        String municipioname = citiesId.isEmpty()? null : citiesId[0].Name;
        String municipioId = citiesId.isEmpty()? null : citiesId[0].Id;
        String clientId = '-1';
        Boolean crear = true; 
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
                //if(!String.valueOf(customMap.get('documentNumber')).equals('')) {
                //  accresp.Nro_de_Documento_de_Identificacion__c = String.valueOf(customMap.get('documentNumber'));
                //   accresp.Tipo_de_Documento_Identificacion__c = String.valueOf(customMap.get('documentType'));   
                //}
                //accresp.Nro_de_Documento_de_Tributario__c = String.valueOf(customMap.get('fiscalDocumentNumber'));
                //accresp.Tipo_de_Documento_Tributario__c = String.valueOf(customMap.get('fiscalDocumentType'));
                accresp.PersonMobilePhone = cellphone;
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
                //accresp.Nro_de_Documento_de_Identificacion__c = '';//String.valueOf(customMap.get('documentNumber'));
                //accresp.Tipo_de_Documento_Identificacion__c = '';//String.valueOf(customMap.get('documentType'));
                //accresp.Nro_de_Documento_de_Tributario__c = String.valueOf(customMap.get('fiscalDocumentNumber'));//String.valueOf(customMap.get('fiscalDocumentNumber'));
                //accresp.Tipo_de_Documento_Tributario__c = String.valueOf(customMap.get('fiscalDocumentType'));//String.valueOf(customMap.get('fiscalDocumentType'));
                accresp.Phone = cellphone;
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
            if(clientType.equals('P')){
                System.debug('Crea PA');
                Object numeroDocumento = String.valueOf(customMap.get('documentNumber'));
                Object tipoDocumento = String.valueOf(customMap.get('documentType'));
                crear = numeroDocumento != null && !numeroDocumento.equals('') && tipoDocumento != null && !tipoDocumento.equals('');
                if(crear) {
                    newacc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
                    newacc.FirstName = String.valueOf(customMap.get('name'));
                    newacc.LastName = String.valueOf(customMap.get('lastName'));
                    //newacc.LastName = String.valueOf(customMap.get('surname'));
                    newacc.Pais__c = paisId;//String.valueOf(customMap.get('country'));
                    newacc.Pais_picklist__c = paisName;
                    newacc.Nro_de_Documento_de_Identificacion__c = String.valueOf(customMap.get('documentNumber'));
                    newacc.Tipo_de_Documento_Identificacion__c = String.valueOf(customMap.get('documentType'));
                    newacc.Nro_de_Documento_de_Tributario__c = String.valueOf(customMap.get('fiscalDocumentNumber'));
                    newacc.Tipo_de_Documento_Tributario__c = String.valueOf(customMap.get('fiscalDocumentType'));
                    newacc.PersonMobilePhone = cellphone;
                    newacc.PersonEmail = String.valueOf(customMap.get('email'));
                    newacc.Departamento__c = departamentoId;//String.valueOf(customMap.get('department'));
                    //newacc.PersonMailingAddress = String.valueOf(customMap.get('address'));
                    newacc.ShippingStreet = String.valueOf(customMap.get('address'));
                    newacc.BillingStreet = String.valueOf(customMap.get('address'));
                    newacc.Municipio__c = municipioId;//String.valueOf(customMap.get('city'));
                    newacc.Autorizacion_Tratamiento_datos_personale__pc = Boolean.valueOf(customMap.get('personalDataProcessing'));
                    newacc.Tipo_de_cuenta__c = 'Persona Natural';
                    newacc.CurrencyIsoCode = CurrencyHelper.getCurrencyISOCodeByCountryName(paisName);
                }
            }
            else {
                System.debug('Crea E');
                Object documentoTributario = String.valueOf(customMap.get('fiscalDocumentNumber'));
                Object tipoTributario = String.valueOf(customMap.get('fiscalDocumentType'));
                crear = documentoTributario != null && !documentoTributario.equals('') && tipoTributario != null && !tipoTributario.equals('');
                if(crear) {
                    newacc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Company_Account').getRecordTypeId();
                    newacc.Name = String.valueOf(customMap.get('name'))+' '+String.valueOf(customMap.get('lastName'));
                    newacc.Pais__c = paisId;//String.valueOf(customMap.get('country'));
                    newacc.Pais_picklist__c = paisName;
                    newacc.Nro_de_Documento_de_Tributario__c = String.valueOf(customMap.get('fiscalDocumentNumber'));//String.valueOf(customMap.get('fiscalDocumentNumber'));
                    newacc.Tipo_de_Documento_Tributario__c = String.valueOf(customMap.get('fiscalDocumentType'));//String.valueOf(customMap.get('fiscalDocumentType'));
                    newacc.Phone = cellphone;
                    newacc.Correo_empresarial__c = String.valueOf(customMap.get('email'));
                    newacc.Departamento__c = departamentoId;//String.valueOf(customMap.get('department'));
                    //newacc.PersonMailingAddress = String.valueOf(customMap.get('address'));
                    newacc.ShippingStreet = String.valueOf(customMap.get('address'));
                    newacc.BillingStreet = String.valueOf(customMap.get('address'));
                    newacc.Municipio__c = municipioId;//String.valueOf(customMap.get('city'));
                    newacc.Autirzo_tratamiento_de_datos_personales__c = Boolean.valueOf(customMap.get('personalDataProcessing'));
                    newacc.Tipo_de_cuenta__c = 'Empresa';
                    newacc.CurrencyIsoCode = CurrencyHelper.getCurrencyISOCodeByCountryName(paisName);
                }
            }
            System.debug(newacc);
            if(crear) {
                insert newacc;
                clientId = newacc.Id;
            } else {
                clientId = null;
            }
        }
        
        Map<String, Object> invoiceMap = (Map<String, Object>)invMap.get('invoice');
        Map<String, Object> vehicleMap = (Map<String, Object>)invMap.get('vehicle');
        String sellerPoint = String.valueOf(invoiceMap.get('sellerPoint'));
        String prospectId = String.valueOf(invoiceMap.get('prospectId'));
        String prospectCell = String.valueOf(invoiceMap.get('prospectCell'));
        Id umaRt = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('UMA').getRecordTypeId();
        List<Opportunity> listOpps = [SELECT Id,StageName FROM Opportunity WHERE RecordTypeId = :umaRt AND sellerPoint__c = :sellerPoint AND StageName != 'Venta ganada' AND StageName != 'Venta perdida' AND AccountId = :clientId ORDER BY CreatedDate DESC LIMIT 1];
        System.debug('umaRt: ' + umaRt);
        System.debug('sellerPoint: ' + sellerPoint);
        System.debug('clientId: ' + clientId);
        System.debug('Oportunidades: ' + listOpps);
        List<Account> listClients = new List<Account>();
        String clientIdProspect = null;
        if(listOpps.isEmpty()) {
            if(prospectCell != '' && prospectCell != null) {
                listClients = [SELECT Id,Pais__c FROM Account WHERE PersonMobilePhone = :prospectCell OR Phone = :prospectCell LIMIT 1];
            } 
            if(listClients.isEmpty() && prospectId != '') {
                listClients = [SELECT Id,Pais__c FROM Account WHERE Nro_de_Documento_de_Identificacion__c = :prospectId OR Nro_de_Documento_de_Tributario__c = :prospectId LIMIT 1];
            }
            if(!listClients.isEmpty()) {
                clientIdProspect = listClients[0].Id;
                listOpps = [SELECT Id,StageName FROM Opportunity WHERE RecordTypeId = :umaRt AND sellerPoint__c = :sellerPoint AND StageName != 'Venta ganada' AND StageName != 'Venta perdida' AND AccountId = :clientIdProspect ORDER BY CreatedDate DESC];
            }
            System.debug('Oportunidades: ');
            System.debug(listOpps);
        }
        System.debug('Oportunidades: ');
        System.debug(listOpps);
        Opportunity opp = !listOpps.isEmpty() ? listOpps[0] : null;
        String oppId = null;
        if(opp != null) {
            opp.StageName = 'Venta ganada';
            oppId = opp.Id;
            update opp;
        }
        String facturaId = null;
        String activoId = null;
        if(clientId != null || clientIdProspect != null) {
            String documentNumberInvoice = String.valueOf(invoiceMap.get('documentNumberInvoice'));
            String codModel = String.valueOf(vehicleMap.get('model'));
            String fechaVenta = String.valueOf(invoiceMap.get('soldAt'));
            String foundClientId = listClients == null || listClients.isEmpty() ? clientId : clientIdProspect;
            Factura__c factura = new Factura__c();
            factura.Name = documentNumberInvoice;
            factura.Identificador_Factura__c = documentNumberInvoice;
            factura.Cliente__c = foundClientId;
            if(opp != null) {
                factura.Oportunidad__c = oppId;
            }
            factura.Precio__c = Decimal.valueOf(String.valueOf(invoiceMap.get('price')).replace(' ','').replace(',','.'));
            //factura.Vendido_en__c = Decimal.valueOf(String.valueOf(invoiceMap.get('soldAt')).replace(' ','').replace(',','.'));
            //factura.Fecha_de_venta__c = String.valueOf(invoiceMap.get('soldAt'));
            if(fechaVenta.length() == 8) {
                fechaVenta = fechaVenta.substring(0,4) + '-' + fechaVenta.substring(4,6) + '-' + fechaVenta.substring(6);
                factura.Fecha_de_venta_date__c = Date.valueOf(fechaVenta);
            }
            factura.Pais__c = listClients == null || listClients.isEmpty() ? paisId : listClients[0].Pais__c;
            //factura.Pais__c = String.valueOf(invoiceMap.get('country'));
            String currencyIsoCode = CurrencyHelper.getCurrencyISOCodeByCountryName(String.valueOf(invoiceMap.get('country')));
            factura.CurrencyIsoCode = currencyIsoCode;
            factura.Sellerpoint__c = sellerPoint;
            factura.Referencia__c = codModel;
            insert factura;
            facturaId = factura.Id;
            
            String vin = String.valueOf(vehicleMap.get('VIN'));
            List<Activo__c> listAssets = [SELECT Nro_VIN_Chasis__c,Marca__c,Placa_de_la_motocicleta__c,Cliente__c,Modelo__c,Ano_del_modelo__c,SellerPoint__c,Identificador_Factura__c,CurrencyIsoCode FROM Activo__c WHERE Nro_VIN_Chasis__c = :vin AND Cliente__c = :foundClientId LIMIT 1];
            String countryId = listClients == null || listClients.isEmpty() ? paisId : listClients[0].Pais__c;
            String countryName = [SELECT Name FROM Pais__c WHERE Id = :countryId][0].Name;
            if(!listAssets.isEmpty()) {
                Activo__c activo = listAssets[0];
                activoId = activo.Id;
                activo.Marca__c = String.valueOf(vehicleMap.get('brand'));
                activo.Placa_de_la_motocicleta__c = String.valueOf(vehicleMap.get('plate'));
                activo.Cliente__c = foundClientId;
                activo.Modelo__c = codModel;
                activo.Ano_del_modelo__c = String.valueOf(vehicleMap.get('modelyear'));
                activo.SellerPoint__c = sellerPoint;
                activo.Identificador_Factura__c = documentNumberInvoice;
                activo.CurrencyIsoCode = currencyIsoCode;
                update activo;
            } else {
                Activo__c activo = new Activo__c();
                activo.Name = vin;
                activo.Nro_VIN_Chasis__c = vin;
                activo.Marca__c = String.valueOf(vehicleMap.get('brand'));
                activo.Placa_de_la_motocicleta__c = String.valueOf(vehicleMap.get('plate'));
                activo.Cliente__c = foundClientId;
                activo.Modelo__c = codModel;
                activo.Ano_del_modelo__c = String.valueOf(vehicleMap.get('modelyear'));
                activo.SellerPoint__c = sellerPoint;
                activo.Identificador_Factura__c = documentNumberInvoice;
                activo.CurrencyIsoCode = currencyIsoCode;
                insert activo;
                activoId = activo.Id;
            }
        }        
        CreateInvoice.Response newresp = new CreateInvoice.Response(true, clientId, clientIdProspect, oppId, activoId, facturaId);
        return newresp;
    }
}