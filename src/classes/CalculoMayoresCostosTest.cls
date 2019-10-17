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
private class CalculoMayoresCostosTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Decimal num = 10;
        
        Account a = new Account(name = 'test');
        insert a;

        Moneda__c m = new Moneda__c(name = 'moneda test');
        insert m;

        Contrato__c c = new Contrato__c(name = 'test', moneda__c = m.id);
        insert c;
        
        Indicador__c ind = new Indicador__c(name = 'indicador1');
        insert ind;
        
        Indicador_valor__c iv = new Indicador_valor__c(Indicador__c = ind.id, Valor__c = 100, Periodo__c = '12-2015');
		insert iv;
        iv = new Indicador_valor__c(Indicador__c = ind.id, Valor__c = 101, Periodo__c = '01-2016');
		insert iv;
        
        
        Formula_mayor_costo__c fm = new Formula_mayor_costo__c(Contrato__c = c.id, Indicador__c = ind.id, Porcentaje_incidencia__c = 10, Fecha_base__c = '12-2015');
        insert fm;
        
        CalculoMayoresCostos mayorCosto = new CalculoMayoresCostos();
        List<Indicador_valor__c> resultado = mayorCosto.setIndicadores('01-2016', c.Id);
            
		for (Integer i=0; i < resultado.size(); i++) {
			if (i==0){ 
				System.debug('indicador1:'+resultado[i].Valor__c);
				System.assertEquals(101, resultado[i].Valor__c );
				System.assertEquals('indicador1', resultado[i].Nombre__c );
			}
			if (i==1){ 
				System.debug('indicador2:'+resultado[i].Valor__c);
			}
			if (i==2){ 
				System.debug('indicador3:'+resultado[i].Valor__c);
			}
			if (i==3){ 
				System.debug('indicador4:'+resultado[i].Valor__c);
			}
			System.debug('base:'+resultado[i].Valor_base__c);
		}

        CalculoMayoresCostos mayorCosto2 = new CalculoMayoresCostos();
        List<Indicador_valor__c> resultado2 = mayorCosto.setIndicadores('02-2016', c.Id);
            
		for (Integer ii=0; ii < resultado2.size(); ii++) {
			if (ii==0){ 
				System.debug('indicador1:'+resultado2[ii].Valor__c);
				System.assertEquals(101, resultado2[ii].Valor__c );
				System.assertEquals('indicador1', resultado2[ii].Nombre__c );
			}
			if (ii==1){ 
				System.debug('indicador2:'+resultado2[ii].Valor__c);
			}
			if (ii==2){ 
				System.debug('indicador3:'+resultado2[ii].Valor__c);
			}
			if (ii==3){ 
				System.debug('indicador4:'+resultado2[ii].Valor__c);
			}
			System.debug('base:'+resultado2[ii].Valor_base__c);
		}


        
    }
}