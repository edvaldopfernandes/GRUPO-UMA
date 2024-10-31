public class ConvertVFToPDF {
    @InvocableMethod(label='Convert to PDF')
    public static List<String> convertToPdf(List<Quote> request){
        System.debug('Here');
        PageReference reportPage = 
            (PageReference)Page.CotizacionPDF;
        reportPage.getParameters().put('id', request[0].Id);
        Blob reportPdf;
        try {
            reportPdf = reportPage.getContentAsPDF();
        }
        catch (Exception e) {
            reportPdf = Blob.valueOf(e.getMessage());
        }
        //createStatic('Quote'+Id.valueOf(request[0].Id),reportPdf);
        List<String> urlList = new List<String>();
        urlList.add(createQuotePublicDocument('Cotizacion: ' + Id.valueOf(request[0].Id), request[0].Id, reportPdf));
        return urlList;
        //return request;
    }
    
        // Form fields


     
    /***** Form Helpers *****/
  

   /* public static void createStatic(string fullName, blob content){
        System.debug('Creando PDF');
        MetadataService.MetadataPort service = createService();     
        MetadataService.StaticResource staticResource = new MetadataService.StaticResource();
        staticResource.fullName = fullName;
        staticResource.contentType = 'application/pdf';
        staticResource.cacheControl = 'public';
        staticResource.content = EncodingUtil.base64Encode(content);
        MetadataService.SaveResult[] results = service.createMetadata(new List<MetadataService.Metadata> { staticResource });
        System.debug('PDF Creado');
	}

    private static MetadataService.MetadataPort createService(){ 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;     
    }*/

    private static String createQuotePublicDocument(String title, Id quoteId, Blob content){
        ContentVersion cv = new ContentVersion();
        cv.VersionData = content;
        cv.Title = title;
        cv.PathOnClient = 'Cotización: ' + quoteId + '.pdf';
        insert cv;

        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        
        ContentDocumentLink cLink = new ContentDocumentLink();
        cLink.ContentDocumentId = cv.ContentDocumentId;
        cLink.LinkedEntityId = quoteId;
        insert cLink;

        ContentDistribution cDistribution = new ContentDistribution();
        cDistribution.ContentVersionId= cv.Id;
        cDistribution.Name = 'Cotización: ' + quoteId;
        insert cDistribution;

        cDistribution = [SELECT ContentDownloadURL, DistributionPublicUrl FROM ContentDistribution WHERE Id = :cDistribution.Id];
        return cDistribution.DistributionPublicUrl;//cDistribution.ContentDownloadUrl;
    }
}