@isTest
public with sharing class OTPGeneratorTest {
    @TestSetup
    static void makeData(){
        insert new Lead(FirstName = 'TestLead', LastName = 'TestLead');    
    }

    @isTest
    static void testOTPGenerator(){
        List<Lead> leads = [SELECT Id FROM Lead];
        OTPGenerator.generateOtp(leads);
    }

}