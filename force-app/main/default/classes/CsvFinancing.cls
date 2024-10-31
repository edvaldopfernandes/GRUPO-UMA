public class CsvFinancing implements Queueable {
    private Map<String,Map<String,String>> csvMap;
    
    public CsvFinancing(Map<String,Map<String,String>> csvMap) {
        this.csvMap = csvMap;
    }
    
    //private static Map<String,String> countryCodes = new Map<String,String>{'AR' => 'Argentina', 'CO' => 'Colombia', 'CR' => 'Costa Rica', 'SV' => 'El Salvador', 'GT' => 'Guatemala', 'HN' => 'Honduras', 'MX' => 'México', 'NI' => 'Nicaragua'};
    
    //public static String getCountryNameByIsoCode(String isoCode){
    //    if(isoCode == null) return null;
    //    return CsvFinancing.countryCodes.get(isoCode);
    //}
    
    public void execute(QueueableContext context) {
        //List<Pais__c> paises = [SELECT Id,Codigo_ISO__c FROM Pais__c];
        //System.debug(paises);
        Map<String,Pais__c> mapPaises = new Map<String,Pais__c>();
        for(Pais__c pais : [SELECT Id,Name,Codigo_ISO__c FROM Pais__c]) {
            System.debug(pais);
            mapPaises.put(pais.Codigo_ISO__c, pais);
        }
        Id personRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        List<String> solicitudIds = new List<String>();
        for(Map<String,String> row : this.csvMap.values()) {
            String idSolicitud = row.get('IdSolicitud');
            solicitudIds.add(idSolicitud);
        }
        List<Account> accs = [SELECT Id,Tipo_de_Documento_Identificacion__c,Nro_de_Documento_de_Identificacion__c, (SELECT Id,idSolicitud__c FROM Opportunities),(SELECT Id,IdSolicitud__c,CurrencyIsoCode FROM Financiamientos__r WHERE IdSolicitud__c in :solicitudIds) FROM Account WHERE RecordTypeId = :personRT];
        Map<String,Account> mapAccs = new Map<String,Account>();
        List<Pago__c> pagos = [SELECT id,Cuota__c,Estado__c,Financiamiento__r.IdSolicitud__c,CurrencyIsoCode FROM Pago__c WHERE Financiamiento__r.IdSolicitud__c in :solicitudIds]; //Se hace otra query porque en la variable "accs" no permite traer los pagos ya que son 2 niveles de indireccion
        Map<String,Financiamiento__c> mapFinanciamientos = new Map<String,Financiamiento__c>();
        for(Account acc : accs) {
            String claveDoble = acc.Tipo_de_Documento_Identificacion__c + '-'+ acc.Nro_de_Documento_de_Identificacion__c;
            mapAccs.put(claveDoble, acc);
            for(Financiamiento__c financiamiento:acc.Financiamientos__r){
                mapFinanciamientos.put(financiamiento.IdSolicitud__c,financiamiento);
            }
        }

        Map<String,Pago__c> mapPagos = new Map<String,Pago__c>();
        for(Pago__c pago : pagos) {
            Financiamiento__c financiamiento = mapFinanciamientos.get(pago.Financiamiento__r.IdSolicitud__c);
            if(financiamiento != null){
                String claveDoble = financiamiento.id + '-'+ pago.Cuota__c;
            	mapPagos.put(claveDoble, pago);    
            }
        }

        List<Account> accsInsert = new List<Account>();
        List<Financiamiento__c> financiamientosInsert = new List<Financiamiento__c>();
        List<Pago__c> pagosUpsert = new List<Pago__c>();

        for(Map<String,String> row : this.csvMap.values()) {
            String tipoDoc = row.get('TipoDocumento');
            String numDoc = row.get('NumeroDocumento');
            String idSolicitud = row.get('IdSolicitud');
            String claveDobleFila = tipoDoc + '-'+ numDoc;
            Account acc = mapAccs.get(claveDobleFila);
            if(acc == null) {
                acc = new Account();
                acc.FirstName = row.get('Nombre');
                acc.LastName = row.get('Apellido');
                acc.Pais__c = mapPaises.get(row.get('Pais')).Id;
                acc.Tipo_de_Documento_Identificacion__c = tipoDoc;
                acc.Nro_de_Documento_de_Identificacion__c = numDoc;
                acc.Tipo_de_cuenta__c = 'Persona Natural';
                acc.PersonMobilePhone = row.get('Telefono');
                acc.Pais_picklist__c = mapPaises.get(row.get('Pais')).Name;
                acc.CurrencyIsoCode = CurrencyHelper.getCurrencyISOCodeByCountryName(acc.Pais_picklist__c);
                //accsInsert.add(acc);
                insert acc;
                mapAccs.put(claveDobleFila, acc);
            }
            
            Financiamiento__c financiamiento = mapFinanciamientos.get(idSolicitud);

            if(financiamiento == null) {
                financiamiento = new Financiamiento__c();
                financiamiento.Name = idSolicitud;
                financiamiento.Cuenta__c = acc.Id;
                financiamiento.IdSolicitud__c = idSolicitud;
                financiamiento.CurrencyIsoCode = CurrencyHelper.getCurrencyISOCodeByCountryIsoCode(row.get('Pais'));
                for(Opportunity opp : acc.Opportunities) {
                    if(opp.idSolicitud__c == idSolicitud) {
                        financiamiento.Oportunidad__c = opp.Id;
                        break;
                    }
                }
                financiamiento.ValorCredito__c = Decimal.valueOf(row.get('ValorCredito').replace(',',''));
                financiamiento.ValorCuota__c = Decimal.valueOf(row.get('ValorCuota').replace(',',''));
                financiamiento.CantidadPagos__c = Integer.valueOf(row.get('CantidadPagos'));
                financiamiento.DiaPago__c = Integer.valueOf(row.get('DiaPago'));
                financiamiento.NombreRef1__c = row.get('NombreRef1');
                financiamiento.TelefonoRef1__c = row.get('TelefonoRef1');
                financiamiento.NombreRef2__c = row.get('NombreRef2');
                financiamiento.TelefonoRef2__c = row.get('TelefonoRef2');
                financiamiento.NombreRef3__c = row.get('NombreRef3');
                financiamiento.TelefonoRef3__c = row.get('TelefonoRef3');
                financiamiento.NombreRef4__c = row.get('NombreRef4');
                financiamiento.TelefonoRef4__c = row.get('TelefonoRef4');
                System.debug(financiamiento);
                mapFinanciamientos.put(financiamiento.IdSolicitud__c,financiamiento);
                financiamientosInsert.add(financiamiento);
            }
        }

        //if(accsInsert.size() > 0){
         //   System.debug('accsInsert.size():'+accsInsert.size());
        //    insert accsInsert;
        //}
        if(financiamientosInsert.size() > 0){
            System.debug('financiamientosInsert.size():'+financiamientosInsert.size());
            insert financiamientosInsert;
        }
        
        for(Map<String,String> row : this.csvMap.values()) {
            String idSolicitud = row.get('IdSolicitud');

            //Integer numBoleta = Integer.valueOf(row.get('#Boleta'));
            Integer numCuota = Integer.valueOf(row.get('Cuota'));
            String estado = row.get('Estado');
            Financiamiento__c financiamiento = mapFinanciamientos.get(idSolicitud);
            String claveDoble = financiamiento.id + '-'+ numCuota;
            Pago__c pagoExistente = mapPagos.get(claveDoble);
            System.debug('financiamientoId:'+financiamiento.id);
            System.debug('pagoExistente:'+pagoExistente);

            if(pagoExistente == null || pagoExistente.Cuota__c != numCuota) { //Si no existe el pago o si la cuota es diferente se crea
                System.debug('pagoExistente.Cuota__c:'+pagoExistente?.Cuota__c);
                System.debug('numCuota:'+numCuota);

                Pago__c pago = new Pago__c();
                pago.Name = row.get('#Boleta');
                //pago.Boleta__c = numBoleta;
                pago.FechaPago__c = Date.parse(row.get('FechaPago'));
                pago.ValorPagado__c = Decimal.valueOf(row.get('ValoraPagar'));
                pago.AporteCapital__c = Decimal.valueOf(row.get('AporteCapital'));
                pago.Intereses__c = Decimal.valueOf(row.get('Intereses'));
                pago.Cuota__c = numCuota;
                pago.Estado__c = estado;
                pago.Financiamiento__c = financiamiento.Id;
                pago.CurrencyIsoCode = financiamiento.CurrencyIsoCode;
                pagosUpsert.add(pago);
                System.debug(pago);
            }else{
                if(pagoExistente.Estado__c != estado){ //Si el estado es diferente se actualiza
                    System.debug('pagoExistente.Estado__c:'+pagoExistente.Estado__c);
                    System.debug('estado:'+estado);

                    pagoExistente.FechaPago__c = Date.parse(row.get('FechaPago'));
                    pagoExistente.ValorPagado__c = Decimal.valueOf(row.get('ValoraPagar'));
                    pagoExistente.AporteCapital__c = Decimal.valueOf(row.get('AporteCapital'));
                    pagoExistente.Intereses__c = Decimal.valueOf(row.get('Intereses'));
                    pagoExistente.Estado__c = estado;
                    pagoExistente.Financiamiento__c = financiamiento.Id;
                    pagosUpsert.add(pagoExistente);
                    System.debug(pagoExistente);
                }
            }
        }

        if(pagosUpsert.size() > 0){
            System.debug('pagosUpsert.size():'+pagosUpsert.size());
            upsert pagosUpsert;
        }
    }
}