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
private class ActualizarFacturasTest {

    static testMethod void myUnitTest() {


        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Proveedor').getRecordTypeId();
        Id RecordTypeIdAccountSociedad = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sociedad desarrolladora').getRecordTypeId();
        
        Account a = new Account(name = 'test123', recordtypeid = RecordTypeIdAccount , cbu__c = '1234567890123456789012');
        insert a;

        Account so = new Account(name = 'test123', recordtypeid = RecordTypeIdAccountSociedad , cbu__c = '1234567890123456789012');
        insert so;

        Moneda__c m = new Moneda__c(name = 'moneda test');
        insert m;

        Obra__c o = new Obra__c(name='test');
        insert o;
        
        Responsable__c r = new Responsable__c(name = 'test');
        insert r;

        Presupuesto_base__c p = new Presupuesto_base__c(name='test', monto__c = 1, obra__c = o.id, proveedor__c = a.id, moneda__c = m.id, responsable_carga__c = r.id);
        insert p;
        
        Orden_de_compra__c oc = new Orden_de_compra__c(name='oc', proveedor__c = a.id, obra__c = o.id, presupuesto__c = p.id, moneda__c = m.id, responsable_carga__c = r.id, sociedad__c = so.id);
        insert oc;

        Orden_de_compra_entrega__c ocd = new Orden_de_compra_entrega__c(orden_de_compra__c = oc.id, cantidad__c = 1, valor_unitario__c = 100);
        insert ocd;

        Contrato__c c = new Contrato__c(name = 'test', moneda__c = m.id, orden_de_compra__c = oc.id, proveedor__c = a.id);
        insert c;
        
        Indicador__c ind = new Indicador__c(name = 'indicador1');
        insert ind;
        Indicador__c ind2 = new Indicador__c(name = 'indicador2');
        insert ind2;
        
        Indicador_valor__c iv = new Indicador_valor__c(Indicador__c = ind.id, Valor__c = 100, Periodo__c = '12-2015');
        insert iv;
        Indicador_valor__c iv2 = new Indicador_valor__c(Indicador__c = ind.id, Valor__c = 101, Periodo__c = '01-2016');
        insert iv2;
        
        Indicador_valor__c iv3 = new Indicador_valor__c(Indicador__c = ind2.id, Valor__c = 100, Periodo__c = '12-2015');
        insert iv3;
        Indicador_valor__c iv4 = new Indicador_valor__c(Indicador__c = ind2.id, Valor__c = 101, Periodo__c = '01-2016');
        insert iv4;
        
        Formula_mayor_costo__c fm = new Formula_mayor_costo__c(Contrato__c = c.id, Indicador__c = ind.id, Porcentaje_incidencia__c = 10, Fecha_base__c = '12-2015');
        insert fm;

        Factura__c f = new Factura__c(name='0001', numero__c='0001-00000001', Importe_neto__c = 50);
        f.contrato__c = c.id;
        f.orden_de_compra__c = oc.id;
        f.Periodo_certificacion__c = '12-2015';
        f.Periodo_control_documentacion__c = '12-2015';
        f.certificado_verde_nuevo__c = 1;
        //f.proveedor__c = a.id;
        f.numero_de_certificado__c = 1;
        //f.sociedad_que_desarrolla__c = so.Id; 
        f.coeficiente_provisorio__c = 'SI';
        insert f;


        f = new Factura__c(name='0002', numero__c='0001-00000002', Importe_neto__c = 50);
        f.contrato__c = c.id;
        f.orden_de_compra__c = oc.id;
        f.Periodo_certificacion__c = '02-2016';
        f.Periodo_control_documentacion__c = '12-2015';
        f.certificado_verde_nuevo__c = 1;
        //f.proveedor__c = a.id;
        f.numero_de_certificado__c = 1;
        //f.sociedad_que_desarrolla__c = so.Id; 
        f.coeficiente_provisorio__c = 'SI';
        insert f;

        PageReference pageRef = Page.Actualizar_facturas;
        Test.setCurrentPage(pageRef); 
        
        List <Indicador__c> inds = new List<Indicador__c>();
        inds.add(ind);
        Apexpages.StandardSetController sc = new Apexpages.StandardSetController(inds);
        ActualizarFacturas ext = new ActualizarFacturas(sc);

        pageRef.getParameters().put('name', 'Test Value');

        ext.doSomething();
        ext.doSomethingMore();
        ext.updateIndicadores();
        ext.updateIndicadoresNoencontrados();
        //System.assertEquals('/apex/success', nextPage);
        
    }
}