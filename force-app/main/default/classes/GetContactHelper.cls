public class GetContactHelper {
    public GetContactHelper() {
        
    }
    
    public static Account getTypeOfContact(String documentNumber, String documentType){
        system.debug('docNumber -->' + documentNumber);
        System.debug('documentType --> ' + documentType);
        List<Account> prsonaccs1 = [SELECT Id,FirstName,MiddleName,LastName,Pais__c,Pais_picklist__c,Nro_de_Documento_de_Identificacion__c,Tipo_de_Documento_Identificacion__c,Nro_de_Documento_de_Tributario__c,Tipo_de_Documento_Tributario__c,PersonMobilePhone,PersonEmail,Departamento__pc,Departamento__pr.Name,Departamento__c,Departamento__r.Name,Municipio__pc,Municipio__pr.Name,Municipio__c,Municipio__r.Name,Autorizacion_Tratamiento_datos_personale__pc,Tipo_de_cuenta__c,CreatedDate,Fecha_nacimiento__c,Genero__c,BillingStreet,ShippingStreet,CurrencyIsoCode FROM Account WHERE Nro_de_Documento_de_Identificacion__c = :documentNumber AND Tipo_de_Documento_Identificacion__c = :documentType AND Tipo_de_cuenta__c='Persona Natural' LIMIT 1];
        
        if(!prsonaccs1.isEmpty())
        {
            System.debug(prsonaccs1);
            return prsonaccs1[0];
        }
        else{
            List<Account> prsonaccs2 = [SELECT Id,FirstName,MiddleName,LastName,Pais__c,Pais_picklist__c,Nro_de_Documento_de_Identificacion__c,Tipo_de_Documento_Identificacion__c,Nro_de_Documento_de_Tributario__c,Tipo_de_Documento_Tributario__c,PersonMobilePhone,PersonEmail,Departamento__pc,Departamento__pr.Name,Departamento__c,Departamento__r.Name,Municipio__pc,Municipio__pr.Name,Municipio__c,Municipio__r.Name,Autorizacion_Tratamiento_datos_personale__pc,Tipo_de_cuenta__c,CreatedDate,Fecha_nacimiento__c,Genero__c,BillingStreet,ShippingStreet,CurrencyIsoCode FROM Account WHERE Nro_de_Documento_de_Tributario__c = :documentNumber AND Tipo_de_Documento_Tributario__c= :documentType AND Tipo_de_cuenta__c='Persona Natural' LIMIT 1];
            
            if(!prsonaccs2.isEmpty())
            {
                System.debug(prsonaccs2);
                return prsonaccs2[0];
            }
            else
            {
                List<Account> bsnessaccs = [SELECT Id,Name,LastName,Pais__c,Pais_picklist__c,Nro_de_Documento_de_Identificacion__c,Tipo_de_Documento_Identificacion__c,Nro_de_Documento_de_Tributario__c,Tipo_de_Documento_Tributario__c,Phone,Correo_empresarial__c,Departamento__c,Departamento__r.Name,Municipio__c,Municipio__r.Name,Autorizacion_Tratamiento_datos_personale__c,Tipo_de_cuenta__c,CreatedDate,Fecha_nacimiento__c,Numero_de_celular__c,BillingStreet,ShippingStreet,CurrencyIsoCode FROM Account WHERE Nro_de_Documento_de_Tributario__c = :documentNumber AND Tipo_de_Documento_Tributario__c= :documentType AND Tipo_de_cuenta__c='Empresa' LIMIT 1];
                
                if(!bsnessaccs.isEmpty())
                {
                    System.debug(bsnessaccs);
                    return bsnessaccs[0];
                }
                else
                {
                    return null;
                }
            }
        }
    }
    
    public static Account getContactInvoice(String documentNumber, String documentType, String fiscalDocumentNumber, String fiscalDocumentType, String clientType){
        if(clientType.equals('P') && documentNumber != null && documentNumber != '' && documentType != null && documentType != '') {
            List<Account> prsonaccs1 = [SELECT Id,FirstName,MiddleName,LastName,Pais__c,Pais_picklist__c,Nro_de_Documento_de_Identificacion__c,Tipo_de_Documento_Identificacion__c,Nro_de_Documento_de_Tributario__c,Tipo_de_Documento_Tributario__c,PersonMobilePhone,PersonEmail,Departamento__c,Departamento__r.Name,Departamento__pc,Departamento__pr.Name,Municipio__pc,Municipio__pr.Name,Municipio__c,Municipio__r.Name,Autorizacion_Tratamiento_datos_personale__pc,Tipo_de_cuenta__c,CreatedDate,Fecha_nacimiento__c,Genero__c,BillingStreet,ShippingStreet,CurrencyIsoCode FROM Account WHERE Nro_de_Documento_de_Identificacion__c = :documentNumber AND Tipo_de_Documento_Identificacion__c = :documentType AND Tipo_de_cuenta__c='Persona Natural' LIMIT 1];
            if(!prsonaccs1.isEmpty()) {
                System.debug(prsonaccs1);
                return prsonaccs1[0];
            }
        }
        if(fiscalDocumentNumber != null && fiscalDocumentNumber != '' && fiscalDocumentType != null && fiscalDocumentType != ''){
            if(clientType.equals('P')) {
                List<Account> prsonaccs2 = [SELECT Id,FirstName,MiddleName,LastName,Pais__c,Pais_picklist__c,Nro_de_Documento_de_Identificacion__c,Tipo_de_Documento_Identificacion__c,Nro_de_Documento_de_Tributario__c,Tipo_de_Documento_Tributario__c,PersonMobilePhone,PersonEmail,Departamento__c,Departamento__r.Name,Departamento__pc,Departamento__pr.Name,Municipio__pc,Municipio__pr.Name,Municipio__c,Municipio__r.Name,Autorizacion_Tratamiento_datos_personale__pc,Tipo_de_cuenta__c,CreatedDate,Fecha_nacimiento__c,Genero__c,BillingStreet,ShippingStreet,CurrencyIsoCode FROM Account WHERE Nro_de_Documento_de_Tributario__c = :fiscalDocumentNumber AND Tipo_de_Documento_Tributario__c= :fiscalDocumentType AND Tipo_de_cuenta__c='Persona Natural' LIMIT 1];
                if(!prsonaccs2.isEmpty()) {
                    System.debug(prsonaccs2);
                    return prsonaccs2[0];
                }
            } else if(clientType.equals('E')) {
                System.debug('E');
                List<Account> bsnessaccs = [SELECT Id,Name,Pais__c,Pais_picklist__c,Nro_de_Documento_de_Tributario__c,Tipo_de_Documento_Tributario__c,Phone,Correo_empresarial__c,Departamento__c,Municipio__c,Autirzo_tratamiento_de_datos_personales__c,Tipo_de_cuenta__c,CreatedDate,Fecha_nacimiento__c,Numero_de_celular__c,BillingStreet,ShippingStreet,CurrencyIsoCode FROM Account WHERE Nro_de_Documento_de_Tributario__c = :fiscalDocumentNumber AND Tipo_de_Documento_Tributario__c= :fiscalDocumentType AND Tipo_de_cuenta__c='Empresa' LIMIT 1];
                if(!bsnessaccs.isEmpty()) {
                    System.debug(bsnessaccs);
                    return bsnessaccs[0];
                }
            }
        }
        return null;
    }
    
    public static Account getContactByCellphone(String cellphone, String clientType){
        if(clientType.equals('P') && cellphone != null && !cellphone.equals('')) {
            List<Account> prsonaccs = [SELECT Id,FirstName,MiddleName,LastName,Pais__c,Pais_picklist__c,Nro_de_Documento_de_Identificacion__c,Tipo_de_Documento_Identificacion__c,Nro_de_Documento_de_Tributario__c,Tipo_de_Documento_Tributario__c,PersonMobilePhone,PersonEmail,Departamento__c,Departamento__r.Name,Departamento__pc,Departamento__pr.Name,Municipio__pc,Municipio__pr.Name,Municipio__c,Municipio__r.Name,Autorizacion_Tratamiento_datos_personale__pc,Tipo_de_cuenta__c,CreatedDate,Fecha_nacimiento__c,Genero__c,BillingStreet,ShippingStreet,CurrencyIsoCode FROM Account WHERE PersonMobilePhone = :cellphone AND Tipo_de_cuenta__c='Persona Natural' ORDER BY CreatedDate DESC LIMIT 1];
            if(!prsonaccs.isEmpty()) {
                System.debug(prsonaccs);
                return prsonaccs[0];
            }
        } else if(clientType.equals('E') && cellphone != null && !cellphone.equals('')) {
            List<Account> bsnessaccs = [SELECT Id,Name,Pais__c,Pais_picklist__c,Nro_de_Documento_de_Tributario__c,Tipo_de_Documento_Tributario__c,Phone,Correo_empresarial__c,Departamento__c,Municipio__c,Autirzo_tratamiento_de_datos_personales__c,Tipo_de_cuenta__c,CreatedDate,Fecha_nacimiento__c,Numero_de_celular__c,BillingStreet,ShippingStreet,CurrencyIsoCode FROM Account WHERE Phone = :cellphone AND Tipo_de_cuenta__c='Empresa' ORDER BY CreatedDate DESC LIMIT 1];
            if(!bsnessaccs.isEmpty()) {
                System.debug(bsnessaccs);
                return bsnessaccs[0];
            }
        }
        return null;
    }
    
    public static Account getContactOpportunityStage(String documentNumber, String documentType, String fiscalDocumentNumber, String fiscalDocumentType, String cellphone) {
        if(cellphone != null && !cellphone.equals('')) {
            List<Account> accsFoundByPhone = [SELECT Id,FirstName,MiddleName,LastName,Pais__c,Pais_picklist__c,Nro_de_Documento_de_Identificacion__c,Tipo_de_Documento_Identificacion__c,Nro_de_Documento_de_Tributario__c,Tipo_de_Documento_Tributario__c,PersonMobilePhone,PersonEmail,Departamento__c,Departamento__r.Name,Departamento__pc,Departamento__pr.Name,Municipio__pc,Municipio__pr.Name,Municipio__c,Municipio__r.Name,Autorizacion_Tratamiento_datos_personale__pc,Tipo_de_cuenta__c,CreatedDate,Fecha_nacimiento__c,Genero__c,BillingStreet,ShippingStreet,Nivel_de_ingresos__c,CurrencyIsoCode FROM Account WHERE PersonMobilePhone = :cellphone AND Tipo_de_cuenta__c='Persona Natural' LIMIT 1];
            if(!accsFoundByPhone.isEmpty()) {
                System.debug(accsFoundByPhone);
                return accsFoundByPhone[0];
            }
        }

        if(documentNumber != null && documentNumber != '' && documentType != null && documentType != '') {
            List<Account> accsFoundById = [SELECT Id,FirstName,MiddleName,LastName,Pais__c,Pais_picklist__c,Nro_de_Documento_de_Identificacion__c,Tipo_de_Documento_Identificacion__c,Nro_de_Documento_de_Tributario__c,Tipo_de_Documento_Tributario__c,PersonMobilePhone,PersonEmail,Departamento__c,Departamento__r.Name,Departamento__pc,Departamento__pr.Name,Municipio__pc,Municipio__pr.Name,Municipio__c,Municipio__r.Name,Autorizacion_Tratamiento_datos_personale__pc,Tipo_de_cuenta__c,CreatedDate,Fecha_nacimiento__c,Genero__c,BillingStreet,ShippingStreet,Nivel_de_ingresos__c,CurrencyIsoCode FROM Account WHERE Nro_de_Documento_de_Identificacion__c = :documentNumber AND Tipo_de_Documento_Identificacion__c = :documentType AND Tipo_de_cuenta__c='Persona Natural' LIMIT 1];
            if(!accsFoundById.isEmpty()) {
                System.debug(accsFoundById);
                return accsFoundById[0];
            }
        }
        
        /*if (fiscalDocumentNumber != null && fiscalDocumentNumber != '' && fiscalDocumentType != null && fiscalDocumentType != '') {
            List<Account> accsFoundByTributario = [SELECT Id,FirstName,MiddleName,LastName,Pais__c,Pais_picklist__c,Nro_de_Documento_de_Identificacion__c,Tipo_de_Documento_Identificacion__c,Nro_de_Documento_de_Tributario__c,Tipo_de_Documento_Tributario__c,PersonMobilePhone,PersonEmail,Departamento__c,Departamento__r.Name,Departamento__pc,Departamento__pr.Name,Municipio__pc,Municipio__pr.Name,Municipio__c,Municipio__r.Name,Autorizacion_Tratamiento_datos_personale__pc,Tipo_de_cuenta__c,CreatedDate,Fecha_nacimiento__c,Genero__c,BillingStreet,ShippingStreet,Nivel_de_ingresos__c,CurrencyIsoCode FROM Account WHERE Nro_de_Documento_de_Tributario__c = :fiscalDocumentNumber AND Tipo_de_Documento_Tributario__c= :fiscalDocumentType AND Tipo_de_cuenta__c='Persona Natural' LIMIT 1];
            if(!accsFoundByTributario.isEmpty()) {
                System.debug(accsFoundByTributario);
                return accsFoundByTributario[0];
            }
        }*/
        return null;
    }
}