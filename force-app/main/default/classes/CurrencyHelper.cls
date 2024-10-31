public class CurrencyHelper {
    private static Map<String,String> codesByCountry = new Map<String,String>{'Colombia' => 'COP', 'Costa Rica' => 'CRC', 'Guatemala' => 'GTQ', 'Honduras' => 'HNL', 'Nicaragua' => 'NIO', 'El Salvador' => 'USD'};
	private static Map<String,String> codesByCountryIsoCode = new Map<String,String>{'CO' => 'COP', 'CR' => 'CRC', 'GT' => 'GTQ', 'HN' => 'HNL', 'NI' => 'NIO', 'SV' => 'USD'};

    public static String getCurrencyISOCodeByCountryName(String countryName){
        if(countryName == null) return null;
        return CurrencyHelper.codesByCountry.get(countryName.toLowerCase().capitalize());
    }
    
    public static String getCurrencyISOCodeByCountryIsoCode(String countryIsoCode){
        if(countryIsoCode == null) return null;
        return CurrencyHelper.codesByCountryIsoCode.get(countryIsoCode.toUpperCase());
    }
}