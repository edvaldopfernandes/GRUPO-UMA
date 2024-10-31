public class CsvToMap {
    
    public static Map<String,Map<String,String>> ConvertToMap(String file) {
        return CsvToMap.ConvertToMap(file, ',');
    }
    
    public static Map<String,Map<String,String>> ConvertToMap(String file, String separator){
        //System.debug('---ConvertToMap');
        String[] archivo = file.split('\n');        
        if(archivo == null || archivo.size() == 0){
            return null;
        }
        
        String columnas = archivo[0];
        String[] headers = columnas.split(separator);
        
        Integer cols = (headers != null ? headers.size() : 0);
        Integer i = 1;
        Map<String,Map<String,String>> res = new Map<String,Map<String,String>>();
        for(String linea : archivo){
            if(linea.equalsIgnoreCase(columnas)){
                continue;
            }
            Map<String,String> l = new Map<String,String>();
            String[] datos = linea.split(separator, cols); //para que obligatoriamente tenga la misma cantidad de campos que el header, aunque no los llene
            for(Integer j=0; j<cols; j++){
                //System.debug(headers[j].normalizeSpace().length());
                //System.debug(datos[j]?.normalizeSpace());
                //System.debug('----');
                //System.debug(datos[j]?.normalizeSpace());
                String bom = headers[j].normalizeSpace().remove('\uFEFF').remove('\uefbbbf');
                //System.debug(bom);
                //system.debug(bom.length());
                l.put(bom, datos[j]?.normalizeSpace());
            }
            res.put(i+'', l);
            i++;
        }
        return res;
    }
    
}