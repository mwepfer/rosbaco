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
private class ExpensaUnidadTriggerTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Proveedor').getRecordTypeId();
        Id RecordTypeIdAccountSociedad = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sociedad desarrolladora').getRecordTypeId();
        
        Account a = new Account(name = 'test123', recordtypeid = RecordTypeIdAccount );
        insert a;

        Account so = new Account(name = 'test123', recordtypeid = RecordTypeIdAccountSociedad );
        insert so;

        Moneda__c m = new Moneda__c(name='test');
        insert m;

        caja__c c = new Caja__c(name='test', moneda__c = m.id);
        insert c;

        Obra__c o = new Obra__c(name='test', caja_cobro_expensas__c = c.id);
        insert o;
        
        Expensa__c e = new Expensa__c(name='test', obra__c = o.id);
        insert e;
        
        Expensa_gasto_general__c egg = new Expensa_gasto_general__c(name='test', importe__c=10, expensa__c = e.id);
        insert egg;
        
        Unidad__c u = new Unidad__c(name='1', obra__c = o.id, Porcentaje_expensas__c = 1);
        insert u;
        
        Expensa_unidad__c eu = new Expensa_unidad__c(obra__c = o.id, expensa__c = e.id, unidad__c = u.id, actualizacion_por_trigger__c= false, Saldo_inicial__c=0, Monto_pagado__c = 1, fecha_pago__c = date.today());
        insert eu;


        Expensa__c e2 = new Expensa__c(name='test2', obra__c = o.id);
        insert e2;
        
        Expensa_gasto_general__c egg2 = new Expensa_gasto_general__c(name='test', importe__c=10, expensa__c = e2.id);
        insert egg2;
        
        Expensa_unidad__c eu2 = new Expensa_unidad__c(obra__c = o.id, expensa__c = e2.id, unidad__c = u.id, actualizacion_por_trigger__c= false, Saldo_inicial__c=0, Monto_pagado__c = 1, fecha_pago__c = date.today());
        insert eu2;

    }
}