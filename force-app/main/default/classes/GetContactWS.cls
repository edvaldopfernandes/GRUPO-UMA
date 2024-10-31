@RestResource(urlMapping='/contacts-accounts/*')
global with sharing class GetContactWS {
    public GetContactWS() {
    }

    global class Response{
        public Map<String, String> responseBody;
        //String status;
        public Boolean success;

        public Response(Boolean success, Account accContact){
            this.success = success;
            //this.status = status;
            if(accContact!=null)
            {
                if(accContact.Tipo_de_cuenta__c == 'Persona Natural')
                {
                    responseBody = new Map<String, String>();
                    responseBody.put('id', accContact.Id);
                    responseBody.put('name', accContact.FirstName + (accContact.MiddleName != null ? ' ' + accContact.MiddleName : ''));
                    responseBody.put('surname', accContact.LastName);
                    responseBody.put('accountType', accContact.Tipo_de_cuenta__c);
                    responseBody.put('email', accContact.PersonEmail);
                    responseBody.put('telephone', accContact.PersonMobilePhone);
                    responseBody.put('country', accContact.Pais_picklist__c);
                    responseBody.put('department', accContact.Departamento__r.Name);
                    responseBody.put('city', accContact.Municipio__r.Name);
                    responseBody.put('createdAt', String.valueOf(accContact.CreatedDate));
                    responseBody.put('personalDataProcessing', String.valueOf(accContact.Autorizacion_Tratamiento_datos_personale__pc));
                    responseBody.put('documentType', accContact.Tipo_de_Documento_Identificacion__c);
                    responseBody.put('documentNumber', accContact.Nro_de_Documento_de_Identificacion__c);
                    responseBody.put('fiscalDocumentType', accContact.Tipo_de_Documento_Tributario__c);
                    responseBody.put('fiscalDocumentNumber', accContact.Nro_de_Documento_de_Tributario__c);
                    responseBody.put('birthdate', String.valueOf(accContact.Fecha_nacimiento__c));
                    responseBody.put('gender', accContact.Genero__c);
                }
                else 
                {
                    responseBody = new Map<String, String>();
                    responseBody.put('id', accContact.Id);
                    responseBody.put('name', accContact.Name);
                    //responseBody.put('surname', accContact.LastName);
                    responseBody.put('accountType', accContact.Tipo_de_cuenta__c);
                    responseBody.put('email', accContact.Correo_empresarial__c);
                    responseBody.put('telephone', accContact.Numero_de_celular__c);
                    responseBody.put('country', accContact.Pais_picklist__c);
                    responseBody.put('department', accContact.Departamento__r.Name);
                    responseBody.put('city', accContact.Municipio__r.Name);
                    responseBody.put('createdAt', String.valueOf(accContact.CreatedDate));
                    responseBody.put('personalDataProcessing', String.valueOf(accContact.Autorizacion_Tratamiento_datos_personale__c));
                    responseBody.put('documentType', accContact.Tipo_de_Documento_Identificacion__c);
                    responseBody.put('documentNumber', accContact.Nro_de_Documento_de_Identificacion__c);
                    responseBody.put('fiscalDocumentType', accContact.Tipo_de_Documento_Tributario__c);
                    responseBody.put('fiscalDocumentNumber', accContact.Nro_de_Documento_de_Tributario__c);
                    responseBody.put('birthdate', String.valueOf(accContact.Fecha_nacimiento__c));
                    
                }
            }
        }
    }

    @HttpGet
    global static GetContactWS.Response getContact() {
        String documentNumber=RestContext.request.params.get('documentNumber');
        String documentType=RestContext.request.params.get('documentType');
        System.debug('Numero de documento: ' + documentNumber + ' Tipo de documento: '+documentType);
		System.debug(RestContext.request);
        System.debug(RestContext.request.params);
        System.debug(RestContext.request.params.get('documentNumber'));
        System.debug(RestContext.request.params.get('documentType'));
        Account accresp = GetContactHelper.getTypeOfContact(documentNumber, documentType); 

        if(accresp!=null)
        {
            System.debug(accresp);
            GetContactWS.Response newresp = new GetContactWS.Response(true, accresp);
            return newresp;
        }
        else{
            GetContactWS.Response newresp = new GetContactWS.Response(false, null);
            return newresp;
        }
     
        //List<Account> prsonaccs1 = [SELECT Id,Name,LastName,RecordType.Name,PersonEmail,PersonMobilePhone,Pais__pc,Departamento__pc,Municipio__pc,CreatedDate,Tipo_de_cuenta__c,Nro_de_Documento_de_Identificacion__c,Tipo_de_Documento_Tributario__c,Nro_de_Documento_de_Tributario__c,PersonBirthdate,PersonGenderIdentity FROM Account WHERE Nro_de_Documento_de_Identificacion__c = :documentNumber AND Tipo_de_Documento_Identificacion__c = :documentType AND RecordType.Name='Personal Account' LIMIT 1];
        /*List<Account> prsonaccs1 = [SELECT Id,Name,LastName,Tipo_de_cuenta__c,PersonEmail,PersonMobilePhone,Pais__pc,Departamento__pc,Municipio__pc,CreatedDate,Tipo_de_Documento_Identificacion__c,Nro_de_Documento_de_Identificacion__c,Tipo_de_Documento_Tributario__c,Nro_de_Documento_de_Tributario__c,PersonBirthdate,PersonGenderIdentity FROM Account WHERE Nro_de_Documento_de_Identificacion__c = :documentNumber AND Tipo_de_Documento_Identificacion__c = :documentType AND Tipo_de_cuenta__c='Persona Natural' LIMIT 1];

        if(!prsonaccs1.isEmpty())
        {
            //GetContactWS.Response newresp = new GetClientWS.Response(prsonaccs[0].Id, prsonaccs1[0].FirstName, prsonaccs1[0].LastName, prsonaccs1[0].RecordType.Name, prsonaccs1[0].PersonEmail, prsonaccs1[0].PersonMobilePhone, prsonaccs1[0].Pais__pc, prsonaccs1[0].Departamento__pc, prsonaccs1[0].Municipio__pc, prsonaccs1[0].CreatedDate, prsonaccs1[0].Tipo_de_cuenta__c, prsonaccs1[0].Nro_de_Documento_de_Identificacion__c, prsonaccs1[0].Tipo_de_Documento_Tributario__c, prsonaccs1[0].Nro_de_Documento_de_Tributario__c, prsonaccs1[0].PersonBirthdate, prsonaccs1[0].PersonGenderIdentity);
            System.debug(prsonaccs1);
            GetContactWS.Response newresp = new GetContactWS.Response(true, prsonaccs1[0]);
            return newresp;
        }
        else{
            //List<Account> prsonaccs2 = [SELECT Id,Name,LastName,RecordType.Name,PersonEmail,Numero_de_celular__c,Pais__c,Departamento__c,Municipio__c,CreatedDate,Tipo_de_cuenta__c,Nro_de_Documento_de_Identificacion__c,Tipo_de_Documento_Tributario__c,Nro_de_Documento_de_Tributario__c,Fecha_nacimiento__c FROM Account WHERE Nro_de_Documento_de_Tributario__c = :documentNumber AND Tipo_de_Documento_Tributario__c= :documentType AND RecordType.Name='Personal Account' LIMIT 1];
            List<Account> prsonaccs2 = [SELECT Id,Name,LastName,Tipo_de_cuenta__c,PersonEmail,PersonMobilePhone,Pais__pc,Departamento__pc,Municipio__pc,CreatedDate,Tipo_de_Documento_Identificacion__c,Nro_de_Documento_de_Identificacion__c,Tipo_de_Documento_Tributario__c,Nro_de_Documento_de_Tributario__c,PersonBirthdate,PersonGenderIdentity FROM Account WHERE Nro_de_Documento_de_Tributario__c = :documentNumber AND Tipo_de_Documento_Tributario__c= :documentType AND Tipo_de_cuenta__c='Persona Natural' LIMIT 1];

            if(!prsonaccs2.isEmpty())
            {
                //GetContactWS.Response newresp = new GetClientWS.Response(prsonaccs2[0].Id, prsonaccs2[0].FirstName, prsonaccs2[0].LastName, prsonaccs2[0].RecordType.Name, prsonaccs2[0].PersonEmail, prsonaccs2[0].Numero_de_celular__c, prsonaccs2[0].Pais__c, prsonaccs2[0].Departamento__c, prsonaccs2[0].Municipio__c, prsonaccs2[0].CreatedDate, prsonaccs2[0].Tipo_de_cuenta__c, prsonaccs2[0].Nro_de_Documento_de_Identificacion__c, prsonaccs2[0].Tipo_de_Documento_Tributario__c, prsonaccs2[0].Nro_de_Documento_de_Tributario__c, prsonaccs2[0].Fecha_nacimiento__c, '');
                GetContactWS.Response newresp = new GetContactWS.Response(true, prsonaccs2[0]);
                return newresp;
            }
            else
            {
                List<Account> bsnessaccs = [SELECT Id,Name,LastName,Tipo_de_cuenta__c,PersonEmail,Numero_de_celular__c,Pais__c,Departamento__c,Municipio__c,CreatedDate,Tipo_de_Documento_Identificacion__c,Nro_de_Documento_de_Identificacion__c,Tipo_de_Documento_Tributario__c,Nro_de_Documento_de_Tributario__c,Fecha_nacimiento__c FROM Account WHERE Nro_de_Documento_de_Tributario__c = :documentNumber AND Tipo_de_Documento_Tributario__c= :documentType AND Tipo_de_cuenta__c='Empresa' LIMIT 1];
                
                if(!bsnessaccs.isEmpty())
                {
                    GetContactWS.Response newresp = new GetContactWS.Response(true, bsnessaccs[0]);
                    return newresp;
                }
                else
                {
                    GetContactWS.Response newresp = new GetContactWS.Response(false, null);
                    return newresp;
                }
            }
        }*/
    }
}