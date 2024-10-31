public class OTPGenerator {
    
    @InvocableMethod(description='This method will be generating the OTP for users to Login' 
                     label='Generate OTP' 
                     category='OTP')
    public static List<String> generateOtp(List<Lead> leads){   
        List<String> responseList = new List<String>();
        for(Lead lead : leads){
            String randomIntegerString = string.valueof(Math.abs(Crypto.getRandomInteger()));
            String otp = randomIntegerString.substring(0,4);
            responseList.add(otp);
       }
        return responseList;
    }
}