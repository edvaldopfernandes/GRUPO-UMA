public without sharing class QuotePDFController {
    
    public class Cliente{
        public String nombre{get;set;}
        public String terminos{get;set;}
        public String email{get;set;}
        public String cedula{get;set;}
        public String sloganPorPais{get;set;}
        public String beneficiosPorPais{get;set;}
        public Decimal impuestoPais{get;set;}

        Cliente(Account acc){
            this.nombre = acc.Name;
            this.terminos = (acc.Pais__r.T_rminos_y_Condiciones__c != null)? acc.Pais__r.T_rminos_y_Condiciones__c : null;
            this.impuestoPais = acc.Pais__r.Impuesto__c;
            this.sloganPorPais = acc.Pais__r.Slogan_de_Motocicleta__c;
            this.beneficiosPorPais = acc.Pais__r.Beneficios__c;
            this.email = acc.Email_personal__c;
            this.cedula = acc.Nro_de_Documento_de_Identificacion__c;
        }
    }
    
        public class Oportunidad{
        public Decimal cuotaInicial{get;set;}
        public Decimal valorCuotas{get;set;}
        public String financiera{get;set;}
        public String metodoPago{get;set;}
 		public String nroCuotas{get;set;}      
        public String enganche{get;set;}      
        Oportunidad(Opportunity opp){
            this.cuotaInicial = opp.Cuota_inicial_Enganche__c;
            this.enganche = opp.Enganche__c;
            this.financiera = opp.Financiera_Aliada__r.Name;
            this.valorCuotas = opp.Cuotas__c;
            this.metodoPago = opp.Forma_de_Pago__c;
            this.nroCuotas = opp.Plazos__c;
        }
    }
    
    
    public class Motocicleta{
        public String nombre{get;set;}
        public String cajaTipo{get;set;}
        public String cilindrada{get;set;}
        public String diametro{get;set;}
        public String carrera{get;set;}
        public String compresion{get;set;}
        public String suspensionTrasera{get;set;}
        public String potenciaMax{get;set;}
        public String parMax{get;set;}
        public String alimentacion{get;set;}
        public String escape{get;set;}
        public String transmision{get;set;}
        public String embrague{get;set;}
        public String caja{get;set;}
        public String marca{get;set;}
        public String slogan{get;set; }
        public String atributo1{get;set;}
        public String atributo2{get;set;}
        public String atributo3{get;set;}
        public String tituloAtributo1{get;set;}
        public String tituloAtributo2{get;set;}
        public String tituloAtributo3{get;set;}
        public String anyomodelo{get;set;}
        
        public String precio{get;set;}
        public Decimal precioTotal{get;set;}
        public String impuesto{get;set;}
        public Decimal cantidad{get;set;}
        public String precioSinIVA{get;set;}
        public String totalConIVA{get;set;}
        public String valorIVAProd{get;set;}
        public String descuentoProd{get;set;}
        
        public String frontalURL{get;set;}
        public String izquierdaURL{get;set;}
        public String derechaURL{get;set;}
        public String sloganCAM{get;set;}
        
        Motocicleta(QuoteLineItem qtli, PricebookEntry pbe){
            Product2 tempProd = qtli.Product2;
            this.nombre = tempProd.Name;
            this.cajaTipo = tempProd.Caja_de_Cambios_Tipo__c;
            this.cilindrada = tempProd.Cilindrada__c;
            this.diametro = tempProd.Diametro__c;
            this.carrera = tempProd.Carrera__c;
            this.compresion = tempProd.Relacion_de_Compresion__c;
            this.suspensionTrasera = tempProd.Suspension_Trasera__c;
            this.potenciaMax = tempProd.Potencia_Maxima_CE__c;
            this.parMax = tempProd.Par_Maximo_CE__c;
            this.alimentacion = tempProd.Alimentacion__c;
            this.escape = tempProd.Escape__c;
            this.transmision = tempProd.Transmision_Final__c;
            this.embrague = tempProd.Embrague__c;
            this.caja = tempProd.Caja_de_Cambios__c;
            this.marca = tempProd.Marca__c;
            String codigoImg = 'ImagenesMoto/'+ this.nombre.deleteWhitespace() + '/'+ tempProd.Color_primario_2__c + tempProd.Color_secundario_2__c;
            System.debug('URL :' + codigoImg);
            this.frontalURL = tempProd.Url_Foto_Frontal__c; //codigoImg + '/frontal.png';
            this.izquierdaURL = tempProd.Url_Foto_Frontal_Izquerda__c;//codigoImg + '/izfrontal.png';
            this.derechaURL = tempProd.Url_Foto_Frontal_Derecha__c;//codigoImg + '/derfrontal.png';
            this.anyomodelo = tempProd.A_o_Modelo__c;
            this.sloganCAM = tempProd.URL_Slogan_CAM__c;
            
            this.slogan = tempProd.Slogan_del_Modelo__c;
          	this.atributo1 = tempProd.Atributo_1__c;
            this.atributo2 = tempProd.Atributo_2__c;
            this.atributo3 = tempProd.Atributo_3__c;
            this.tituloAtributo1 = tempProd.Titulo_Atributo_1__c;
            this.tituloAtributo2 = tempProd.Titulo_Atributo_2__c;
            this.tituloAtributo3 = tempProd.Titulo_Atributo_3__c;
          
            this.precio = String.valueOf(pbe.UnitPrice.format());
            this.impuesto = (qtli.Impuesto_al_consumo__c != null) ?String.valueOf(qtli.Impuesto_al_consumo__c.format()) : null;
            if(tempProd.Region__c == 'Colombia'){
                this.precioSinIVA = String.valueOf(qtli.Precio_de_lista_unitario_sin_IVA__c.format());
                this.totalConIVA = String.valueOf(qtli.Total_de_productos_con_IVA__c.format());
                this.valorIVAProd = String.valueOf(qtli.Valor_IVA_Producto__c.format());
                this.descuentoProd = (qtli.Descuento__c != null) ?String.valueOf(qtli.Descuento__c.format()) : null;
            }
            else {
                this.precioSinIVA = String.valueOf(qtli.Precio_de_lista_unitario_sin_IVA__c.format().replace('.',','));
                this.totalConIVA = String.valueOf(qtli.Total_de_productos_con_IVA__c.format().replace('.',','));
                this.valorIVAProd = String.valueOf(qtli.Valor_IVA_Producto__c.format().replace('.',','));
                this.descuentoProd = (qtli.Descuento__c != null) ?String.valueOf(qtli.Descuento__c.format().replace('.',',')) : null;
            }
            
            this.cantidad = qtli.Quantity;
            if(tempProd.Impuesto_de_Consumo__c != null)
                this.precioTotal = (qtli.TotalPrice + qtli.Items_Adicionales__c) * tempProd.Impuesto_de_Consumo__c;
            else 
                  this.precioTotal = (qtli.TotalPrice + qtli.Items_Adicionales__c);
        }
    }
    
    
    public class Cotizacion{
        public Decimal subtotal{get;set;}
        public String total{get;set;}
        public String fechaCreacion{get;set;}
        public String fechaMod{get;set;}
        public String fechaVencimiento{get;set;}
        public String valorCuotaAprox{get;set;} 
        public String precioAccesorio{get;set;}
        public String impuestoCotizacion{get;set;}
        
        Cotizacion(Quote qt){
            this.subtotal = qt.Subtotal;
            this.total = (qt.Total_de_la_cotizacion__c != null)? String.valueOf(qt.Total_de_la_cotizacion__c.format().replace('.',',')) : null;
            this.fechaCreacion = qt.CreatedDate?.format();
            this.fechaMod = qt.LastModifiedDate?.format();
            this.fechaVencimiento = qt.ExpirationDate?.format();
            this.valorCuotaAprox = (qt.Valor_de_cuota_aproximado__c != null)? String.valueOf(qt.Valor_de_cuota_aproximado__c.format().replace('.',',')) : null;
            this.precioAccesorio = (qt.Precio_accesorio_adicional__c != null)? String.valueOf(qt.Precio_accesorio_adicional__c.format().replace('.',',')) : null;
            this.impuestoCotizacion = (qt.Tax != null)? String.valueOf(qt.Tax.format().replace('.',',')) : null;
        }
    }
    
    public class Asesor{
        public String nombre{get;set;}
        public String cargo{get;set;}
        public String email{get;set;}
        public String celular{get;set;}
        public String pdv{get;set;}
        public String pais{get;set;}
        public String ciudad{get;set;}
        public String direccion{get;set;}
        public String moneda{get;set;}
 
        Asesor(Id userId){
            User user = [SELECT Name, Email, Title, MobilePhone, sellerPoint__c, Pais__c, Municipio_Ciudad__c, Nombre_Punto_de_Venta__c, Street, DefaultCurrencyIsoCode FROM User WHERE Id = :userId ];
            this.cargo = user.Title;
            this.celular = user.MobilePhone;
            this.pdv = user.Nombre_Punto_de_Venta__c;
            this.nombre = user.Name; 
            this.email = user.Email;
            this.pais = user.Pais__c;
            this.ciudad = user.Municipio_Ciudad__c;
            this.direccion = user.Street;
            this.moneda = user.DefaultCurrencyIsoCode;
        }
    }
    
    
    public Asesor asesor {get;set;}
    public Cliente cliente {get;set;}
    public Motocicleta moto {get;set;}
    public Cotizacion cotizacion{get;set;}
    public Oportunidad opp{get;set;}
    public String promoName{get;set;}
    public String promoFinanciera{get;set;}
    
    public QuotePDFController(ApexPages.StandardController controller) {
        final Id quoteId = ApexPages.currentPage().getParameters().get('id');
        Quote quote = [SELECT Account.Name, Account.Pais__r.T_rminos_y_Condiciones__c,Account.Pais__r.Impuesto__c, Account.Pais__r.Slogan_de_Motocicleta__c, Account.Pais__r.Beneficios__c,
                        Account.Email_personal__c, Account.Nro_de_Documento_de_Identificacion__c , 
                       SubTotal, TotalPrice, CreatedDate, LastModifiedDate, ExpirationDate, Pricebook2Id, CurrencyIsoCode, Tax,
                       (SELECT Product2Id, Product2.Name, Product2.Marca__c, Product2.Caja_de_Cambios_Tipo__c, Product2.Cilindrada__c, Product2.Diametro__c,
                        Product2.Carrera__c, Product2.Relacion_de_Compresion__c, Product2.Potencia_Maxima_CE__c, Product2.Par_Maximo_CE__c, Product2.A_o_Modelo__c,
                        Product2.Impuesto_de_Consumo__c, Impuesto_al_consumo__c, Product2.Alimentacion__c, Product2.Escape__c, Product2.Embrague__c, Product2.Caja_de_Cambios__c, 
                        Product2.Transmision_Final__c, Product2.Color_Primario_2__c, Product2.Color_Secundario_2__c, Product2.StockKeepingUnit,
                        Product2.Modelo__r.Name, Product2.Slogan_del_Modelo__c, Product2.Url_Foto_Frontal_Derecha__c, Product2.Url_Foto_Frontal__c,
                        Product2.Url_Foto_Frontal_Izquerda__c, Quantity, Items_Adicionales__c, TotalPrice, Product2.Titulo_Atributo_1__c,
                        Product2.Titulo_Atributo_2__c, Product2.Titulo_Atributo_3__c, Product2.Suspension_Trasera__c, Product2.Region__c,
                        Product2.Atributo_1__c, Product2.Atributo_2__c, Product2.Atributo_3__c, Product2.URL_Slogan_CAM__c, Valor_IVA_Producto__c, Total_de_productos_con_IVA__c, Descuento__c,
                        Precio_de_lista_unitario_sin_IVA__c, ListPrice FROM QuoteLineItems), CreatedById, 
                        Opportunity.Cuotas__c, Opportunity.Financiera_Aliada__r.Name, Opportunity.Enganche__c, Opportunity.Cuota_inicial_Enganche__c, Opportunity.Forma_de_Pago__c, Opportunity.Plazos__c,
                        Valor_de_cuota_aproximado__c, Total_de_la_cotizacion__c, Precio_accesorio_adicional__c FROM Quote WHERE Id =:quoteId LIMIT 1];
        System.debug(quote.Pricebook2Id);
        PricebookEntry pbe = [SELECT UnitPrice FROM PricebookEntry WHERE Product2Id = :quote.QuoteLineItems[0].Product2Id 
                              AND Pricebook2Id = :quote.Pricebook2Id AND CurrencyIsoCode = :quote.CurrencyIsoCode];
        
        
        cotizacion = new Cotizacion(quote);
        cliente = new Cliente(quote.Account);
        system.debug('Quantity ' + quote.QuoteLineItems[0].Quantity);
        moto = new Motocicleta(quote.QuoteLineItems[0], pbe);
        asesor = new Asesor(quote.CreatedById);
        opp = new Oportunidad (quote.Opportunity);
        List<Promocion__c> promos = [SELECT Name, Observaciones__c  FROM Promocion__c WHERE Referencia__c = :quote.QuoteLineItems[0].Product2.Id];
        String promoName =  (!promos.isEmpty())? promos[0].Name : null;
        String promoFinanciera =  (!promos.isEmpty())? promos[0].Observaciones__c : null;
        //Static Resource
        
    }
}