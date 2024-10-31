@RestResource(urlMapping='/avanta-opportunities/*')
global without sharing class UpdateOpportunityStage {
    
    global class Response{
        public Boolean success;
        public Map<String, String> responseBody;
        
        public Response(Boolean success, List<Opportunity> listOpps, List<Account> accsList){
            responseBody = new Map<String, String>();
            if(listOpps.size() == 0) {
                this.success = false;
                responseBody.put('updateFailure','Couldn\'t find opportunities to update.');
            }
            this.success = success;
            Integer i = 1;
            for(Opportunity opp : listOpps) {
            	responseBody.put('opportunityId' + i, opp.Id);
                responseBody.put('opportunityName' + i, opp.Name);
                System.debug('opportunityId' + i + ':' + opp.Id);
                System.debug('opportunityName' + i + ':' + opp.Name);
                ++i;
            }
            i = 1;
            for(Account acc : accsList) {
                responseBody.put('clientId' + i, acc.Id);
                responseBody.put('clientName' + i, acc.FirstName + ' ' + acc.LastName);
                System.debug('clientId' + i + ':' + acc.Id);
                System.debug('clientName' + i + ':' + acc.FirstName + ' ' + acc.LastName);
                ++i;
            }
        }
    }

    @HttpPatch
    global static void processOpportunities(){
        RestRequest request = RestContext.request;
        Map<String,Object> mapaTemp = (Map<String,Object>)JSON.deserializeUntyped(request.requestBody.toString());
        List<Object> itemList = (List<Object>)mapaTemp.get('data');
        System.debug(JSON.serializePretty(mapaTemp.get('data')));
        BatchUpdateOpportunityStage processOppsJob = new BatchUpdateOpportunityStage(itemList);
        Database.executeBatch(processOppsJob, 15);
    }
    
    //@HttpPatch
    public static Response processOpportunity(List<Object> itemList) {
        List<Opportunity> listOpps = new List<Opportunity>();
        Id avantaRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AVANTA').getRecordTypeId();
        List<Id> oppIds = new List<Id>();
        List<Account> accsList = new List<Account>();
        for(Object item : itemList) {
            Map<String,Object> itemMap = (Map<String, Object>)item;
            String idSolicitud = itemMap.get('IdSolicitud').toString();
            String tipoIdentificacion = itemMap.get('TipoIdentificacion').toString();
            String numeroIdentificacion = itemMap.get('NumeroIdentificacion').toString();
            String tipoDocumentoFiscal = itemMap.get('TipoDocuemntoFiscal').toString(); // es aqui
            String documentoFiscal = itemMap.get('DocumentoFiscal').toString();
            String cellphone = itemMap.get('Celular').toString();
            Account accresp = GetContactHelper.getContactOpportunityStage(numeroIdentificacion,tipoIdentificacion,documentoFiscal,tipoDocumentoFiscal,cellphone);
            String department = null;
            if(!String.valueOf(itemMap.get('Departamento')).equals('')) {
                department = String.valueOf(itemMap.get('Departamento'));            
            }
            String municipio = null;
            if(!String.valueOf(itemMap.get('Municipio')).equals('')) {
                municipio = String.valueOf(itemMap.get('Municipio'));
            }
            
            String paisValor = String.valueOf(itemMap.get('Pais'));
            List<Pais__c> countriesId = [SELECT Id,Name,Codigo_ISO__c FROM Pais__c WHERE Codigo_ISO__c = :paisValor OR Name = :paisValor LIMIT 1];
            Map<String,String> mapPaisByIso = new Map<String,String>();
            if(!countriesId.isEmpty()) {
                mapPaisByIso.put(countriesId[0].Codigo_ISO__c,countriesId[0].Name);
            }
            String paisId = countriesId.isEmpty()? null : countriesId[0].Id;
            List<Departamento__c> departmentsId = [SELECT Id,Name FROM Departamento__c WHERE Name = :department AND Pais_lookup__c = :paisId LIMIT 1];
            String departamentoId = departmentsId.isEmpty()? null : departmentsId[0].Id;
            List<Municipio__c> citiesId = [SELECT Id,Name FROM Municipio__c WHERE Name = :municipio AND Departamento_lookup__c = :departamentoId LIMIT 1];
            
            String paisname = countriesId.isEmpty()? null : countriesId[0].Name;
            String departamentoname = departmentsId.isEmpty()? null : departmentsId[0].Name;
            String municipioname = citiesId.isEmpty()? null : citiesId[0].Name;
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
                accsList.add(accresp);
                clientId = accresp.Id;
                System.debug(accresp);
                System.debug('Persona natural');
                accresp.FirstName = String.valueOf(itemMap.get('Nombre'));
                accresp.LastName =  String.valueOf(itemMap.get('Apellido'));
                accresp.Pais__pc = paisId;//String.valueOf(customMap.get('country'));
                accresp.Pais_picklist__c = mapPaisByIso.get(String.valueOf(itemMap.get('Pais')));
                //if(!String.valueOf(customMap.get('documentNumber')).equals('')) {
                //  accresp.Nro_de_Documento_de_Identificacion__c = String.valueOf(customMap.get('documentNumber'));
                //   accresp.Tipo_de_Documento_Identificacion__c = String.valueOf(customMap.get('documentType'));   
                //}
                //accresp.Nro_de_Documento_de_Tributario__c = String.valueOf(customMap.get('fiscalDocumentNumber'));
                //accresp.Tipo_de_Documento_Tributario__c = String.valueOf(customMap.get('fiscalDocumentType'));
                accresp.PersonMobilePhone = cellphone;
                accresp.PersonEmail = String.valueOf(itemMap.get('Correo'));
                accresp.Departamento__c = departamentoId;//String.valueOf(customMap.get('department'));
                //accresp.PersonMailingAddress = String.valueOf(customMap.get('address'));
                accresp.ShippingStreet = String.valueOf(itemMap.get('Direccion'));
            	accresp.BillingStreet = String.valueOf(itemMap.get('Direccion'));
                accresp.Municipio__c = municipioId;//String.valueOf(customMap.get('city'));
                accresp.Genero__c = String.valueOf(itemMap.get('Genero'));
                accresp.Nivel_de_ingresos__c = Decimal.valueOf(String.valueOf(itemMap.get('Ingresos')));
                //accresp.Autorizacion_Tratamiento_datos_personale__pc = Boolean.valueOf(customMap.get('personalDataProcessing'));
                accresp.CurrencyIsoCode = CurrencyHelper.getCurrencyISOCodeByCountryName(paisName);
            	update accresp;
            } else {
                Account newacc = new Account();
                System.debug('Crea PA');
                newacc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
                newacc.FirstName = String.valueOf(itemMap.get('Nombre'));
                newacc.LastName = String.valueOf(itemMap.get('Apellido'));
                //newacc.LastName = String.valueOf(customMap.get('surname'));
                newacc.Pais__c = paisId;//String.valueOf(customMap.get('country'));
                newacc.Pais_picklist__c = mapPaisByIso.get(String.valueOf(itemMap.get('Pais')));
                if(!numeroIdentificacion.equals('')) {
                    newacc.Nro_de_Documento_de_Identificacion__c = numeroIdentificacion;
                    newacc.Tipo_de_Documento_Identificacion__c = tipoIdentificacion;
                }
                newacc.Nro_de_Documento_de_Tributario__c = documentoFiscal;
                newacc.Tipo_de_Documento_Tributario__c = tipoDocumentoFiscal;
                newacc.PersonMobilePhone = cellphone;
                newacc.PersonEmail = String.valueOf(itemMap.get('Correo'));
                newacc.Departamento__c = departamentoId;//String.valueOf(customMap.get('department'));
                //newacc.PersonMailingAddress = String.valueOf(customMap.get('address'));
                newacc.ShippingStreet = String.valueOf(itemMap.get('Direccion'));
            	newacc.BillingStreet = String.valueOf(itemMap.get('Direccion'));
                newacc.Municipio__c = municipioId;//String.valueOf(customMap.get('city'));
                newacc.Genero__c = String.valueOf(itemMap.get('Genero'));
                newacc.Nivel_de_ingresos__c = Decimal.valueOf(String.valueOf(itemMap.get('Ingresos')));
                //newacc.Autorizacion_Tratamiento_datos_personale__pc = Boolean.valueOf(customMap.get('personalDataProcessing'));
                newacc.Tipo_de_cuenta__c = 'Persona Natural';
                newacc.CurrencyIsoCode = CurrencyHelper.getCurrencyISOCodeByCountryName(paisName);
                insert newacc;
                clientId = newacc.Id;
                accsList.add(newacc);
            }
            List<Opportunity> opps = [SELECT Id,StageName,Name FROM Opportunity WHERE IdSolicitud__c = :idSolicitud LIMIT 1];
            if(opps.size() > 0 && !opps[0].StageName.toLowerCase().equals(itemMap.get('Estado').toString().toLowerCase())) {
                opps[0].StageName = String.valueOf(itemMap.get('Estado'));
                listOpps.add(opps[0]);
            } else {
                String tipoId = tipoIdentificacion;
                String numId = numeroIdentificacion;
                String cellId = cellphone;
                List<Account> accts = [SELECT Id,Name,(SELECT Id,StageName,IdSolicitud__c,Name FROM Opportunities WHERE RecordTypeId = :avantaRT AND (StageName = 'Inicio' OR StageName = 'Estudio de Credito') LIMIT 1) FROM Account WHERE PersonMobilePhone = :cellId LIMIT 1];
                if(accts.isEmpty()) {
                    accts = [SELECT Id,Name,(SELECT Id,StageName,IdSolicitud__c,Name FROM Opportunities WHERE RecordTypeId = :avantaRT AND (StageName = 'Inicio' OR StageName = 'Estudio de Credito') LIMIT 1) FROM Account WHERE Tipo_de_Documento_Identificacion__c = :tipoId AND Nro_de_Documento_de_Identificacion__c = :numId LIMIT 1];
                }
                if(accts.size() > 0 && accts[0].Opportunities.size() != 0) {
                    Opportunity opp = accts[0].Opportunities.get(0);
                    opp.StageName = String.valueOf(itemMap.get('Estado'));
                    opp.IdSolicitud__c = idSolicitud;
                    listOpps.add(opp);
                }
            }
        }
        System.debug(listOpps);
        update listOpps;
        return new UpdateOpportunityStage.Response(true, listOpps, accsList);
    }
}