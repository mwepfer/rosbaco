public class Num2Text {  
   
    public String getNumberTOWordConvertion(Decimal num) {
        List<String> UNIDADES = new List<String> {'', ' Un', ' Dos', ' Tres', ' Cuatro', ' Cinco', ' Seis', ' Siete', ' Ocho', ' Nueve','Diez','Once','Doce','Trece','Catorce','Quince','Dieciseis','Diecisiete','Dieciocho','Diecinueve','Veinte'};
        List<String> DECENAS = new List<String> {'Veinti', 'Treinta', 'Cuarenta', 'Cincuenta', 'Sesenta', 'Setenta', 'Ochenta', 'Noventa', 'Cien'};
        List<String> CENTENAS = new List<String> {'Ciento', 'DOSCIENTOS', 'TRESCIENTOS', 'CUATROCIENTOS', 'QUINIENTOS', 'SEISCIENTOS', 'SETECIENTOS', 'OCHOCIENTOS', 'NOVECIENTOS'};

        String converted = '';
        String decimales = '';
        Integer forzarCentimos = 1;
        String moneda = '';
        String valor_convertido;
        String centimos = 'CENTAVOS';

        if ((num < 0) || (num > 999999999)) {
            return 'No es posible convertir el numero a letras';
        }

        String numb = String.valueOf(num);

        List<String> div_decimales = numb.split('\\.');
        if(div_decimales.size() > 1){
            num = Integer.valueOf(div_decimales[0]);
            String decNumberStr = div_decimales[1];
            if(decNumberStr.length() == 2){
                String decNumberStrFill = decNumberStr.leftpad(9, '0');
                String decCientos = decNumberStrFill.substring(6);
                decimales = convertGroup(decCientos);
            }
        }
        else if (div_decimales.size() == 1 && forzarCentimos == 1){
            decimales = 'CERO ';
        }

        String numberStr = String.valueOf(num);
        
        String numberStrFill = numberStr.leftpad(9, '0');
        String millones = numberStrFill.substring(0, 3);
        String miles = numberStrFill.substring(3).substring(0,3);
        String cientos = numberStrFill.substring(6);
        if (Integer.valueOf(millones) > 0) {
            if (millones == '001') {
                converted += 'UN MILLON ';
            } else if (Integer.valueOf(millones) > 0) {
                converted += convertGroup(millones)+ 'MILLONES ';
            }
        }
        if (Integer.valueOf(miles) > 0) {
            if (miles == '001') {
                converted += 'MIL ';
            } else if (Integer.valueOf(miles) > 0) {
                converted += convertGroup(miles) + 'MIL ';
            }
        }
        if (Integer.valueOf(cientos) > 0) {
            if (cientos == '001') {
                converted += 'UN ';
            } else if (Integer.valueOf(cientos) > 0) {
                converted += convertGroup(cientos) + ' ';
            }
        }
        if(String.isEmpty(decimales)){
            valor_convertido = converted + moneda.touppercase();
        } else {
            valor_convertido = converted + moneda.touppercase() + ' CON ' + decimales + ' ' + centimos.touppercase();
        }
        return valor_convertido.toUpperCase();

    }
        

    public String convertGroup(String n) {

        String output = '';
        List<String> UNIDADES = new List<String> {'', ' Un ', 'Dos ', 'Tres ', 'Cuatro ', 'Cinco ', 'Seis ', 'Siete ', 'Ocho ', 'Nueve ','Diez ','Once ','Doce ','Trece ','Catorce ','Quince ','Dieciseis ','Diecisiete ','Dieciocho ','Diecinueve ','Veinte '};
        List<String> DECENAS = new List<String> {'Veinti', 'Treinta ', 'Cuarenta ', 'Cincuenta ', 'Sesenta ', 'Setenta ', 'Ochenta ', 'Noventa ', 'Cien '};
        List<String> CENTENAS = new List<String> {'Ciento ', 'DOSCIENTOS ', 'TRESCIENTOS ', 'CUATROCIENTOS ', 'QUINIENTOS ', 'SEISCIENTOS ', 'SETECIENTOS ', 'OCHOCIENTOS ', 'NOVECIENTOS '};

        if (n == '100') {
            output = 'CIEN ';
        } else if (n.substring(0,1) != '0') {
            //output = CENTENAS[Integer.valueOf(n.substring(0,1)) - 1];
            output = CENTENAS[Integer.valueOf(n.substring(0,1)) - 1];
        }
        Integer k = Integer.valueOf(n.substring(1));
        if (k <= 20) {
            output += UNIDADES[k];
        } else {
            if((k > 30) && (n.substring(1).substring(1) != '0')) {
                output += DECENAS[Integer.valueOf(n.substring(0,2).substring(1)) - 2]+'Y '+ UNIDADES[Integer.valueOf(n.substring(1).substring(1))]; 
            } else {
                output += DECENAS[Integer.valueOf(n.substring(0,2).substring(1)) - 2]+''+ UNIDADES[Integer.valueOf(n.substring(1).substring(1))]; 
            }
        }
        return output;
    }
}