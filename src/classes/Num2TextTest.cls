/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Num2TextTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test


        Decimal num = 10;
        
        Num2Text nwcObj = new Num2Text();
   		System.debug('devolucion en letras');
            
        System.assertEquals('DIEZ   CON CERO  CENTAVOS', nwcObj.getNumberTOWordConvertion(num) );
        
        num = 1;
        System.assertEquals('UN  CON CERO  CENTAVOS', nwcObj.getNumberTOWordConvertion(num) );

        num = 9;
        System.assertEquals('NUEVE   CON CERO  CENTAVOS', nwcObj.getNumberTOWordConvertion(num) );
        
        num = 428900201;
        System.assertEquals('CUATROCIENTOS VEINTIOCHO MILLONES NOVECIENTOS MIL DOSCIENTOS  UN   CON CERO  CENTAVOS', nwcObj.getNumberTOWordConvertion(num) );

        num = 100.10;
        System.assertEquals('CIEN   CON DIEZ  CENTAVOS', nwcObj.getNumberTOWordConvertion(num) );

        num = 1000;
        System.assertEquals('MIL  CON CERO  CENTAVOS', nwcObj.getNumberTOWordConvertion(num) );

        num = 1000000;
        System.assertEquals('UN MILLON  CON CERO  CENTAVOS', nwcObj.getNumberTOWordConvertion(num) );

        num = -10;
        System.assertEquals('No es posible convertir el numero a letras', nwcObj.getNumberTOWordConvertion(num) );
                
    }
}