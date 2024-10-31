@isTest
public class InsertLeadsTest {
    @isTest static void testQueueable() {
        List<StaticResource> sr = [SELECT Body FROM StaticResource WHERE Name = 'mockupCsv' LIMIT 1];
        String csv = sr != null ? sr[0].Body.toString() : '';
        System.debug(CsvToMap.ConvertToMap(csv,';'));
        InsertLeads il = new InsertLeads(CsvToMap.ConvertToMap(csv,';'));
        Test.startTest();
        System.enqueueJob(il);
        Test.stopTest();
        System.debug(3+' '+ [SELECT count() FROM Lead]);
        System.debug(0+' '+ [SELECT count() FROM Lead WHERE Email = 'Shirlee.Morehouse@procontacto.com.mx']);
        System.assertEquals(3, [SELECT count() FROM Lead]);
        System.assertEquals(0, [SELECT count() FROM Lead WHERE Email = 'Shirlee.Morehouse@procontacto.com.mx']);
    }
}