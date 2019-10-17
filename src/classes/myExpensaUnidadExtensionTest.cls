@isTest
private class myExpensaUnidadExtensionTest {

    static testMethod void myUnitTest() {


        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Proveedor').getRecordTypeId();
        Id RecordTypeIdAccountSociedad = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sociedad desarrolladora').getRecordTypeId();
        
        Account a = new Account(name = 'test123', recordtypeid = RecordTypeIdAccount );
        insert a;

        Account so = new Account(name = 'test123', recordtypeid = RecordTypeIdAccountSociedad );
        insert so;

        Moneda__c m = new Moneda__c(name = 'moneda test');
        insert m;

        caja__c c = new Caja__c(name='test', moneda__c = m.id);
        insert c;

        Obra__c o = new Obra__c(name='test', caja_cobro_expensas__c = c.id);
        insert o;

        Responsable__c r = new Responsable__c(name = 'test');
        insert r;

        Presupuesto_base__c p = new Presupuesto_base__c(name='test', monto__c = 1, obra__c = o.id, proveedor__c = a.id, moneda__c = m.id, responsable_carga__c = r.id);
        insert p;

        Orden_de_compra__c oc = new Orden_de_compra__c(name='oc', proveedor__c = a.id, obra__c = o.id, presupuesto__c = p.id, moneda__c = m.id, responsable_carga__c = r.id, sociedad__c = so.id);
        insert oc;
        
        Orden_de_compra_entrega__c ocd = new Orden_de_compra_entrega__c(orden_de_compra__c = oc.id, cantidad__c = 1, valor_unitario__c = 100);
        insert ocd;

        //Contrato__c c = new Contrato__c(name = 'test', moneda__c = m.id, orden_de_compra__c = oc.id, proveedor__c = a.id);
        //insert c;
        
        Indicador__c ind = new Indicador__c(name = 'indicador1');
        insert ind;
        
        Indicador_valor__c iv = new Indicador_valor__c(Indicador__c = ind.id, Valor__c = 100, Periodo__c = '12-2015');
        insert iv;
        iv = new Indicador_valor__c(Indicador__c = ind.id, Valor__c = 101, Periodo__c = '01-2016');
        insert iv;
        
        
        //Formula_mayor_costo__c fm = new Formula_mayor_costo__c(Contrato__c = c.id, Indicador__c = ind.id, Porcentaje_incidencia__c = 10, Fecha_base__c = '12-2015');
        //insert fm;

        Factura__c f = new Factura__c(name='0001', numero__c='0001-00000001', Importe_neto__c = 50);
        //f.contrato__c = c.id;
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
        //f.contrato__c = c.id;
        f.orden_de_compra__c = oc.id;
        f.Periodo_certificacion__c = '02-2016';
        f.Periodo_control_documentacion__c = '12-2015';
        f.certificado_verde_nuevo__c = 1;
        //f.proveedor__c = a.id;
        f.numero_de_certificado__c = 1;
        //f.sociedad_que_desarrolla__c = so.Id; 
        f.coeficiente_provisorio__c = 'SI';
        insert f;

        Factura_item__c fi = new Factura_item__c(Factura__c=f.Id,Name='item1',Entregado__c=true);
        insert fi;
        
        Factura_item__c fi2 = new Factura_item__c(Factura__c=f.Id,Name='item2',Entregado__c=false);
        insert fi2;
    
        Unidad__c u = new Unidad__c(name='u', obra__c = o.id, Porcentaje_expensas__c = 5);
        insert u;

        Expensa__c e = new Expensa__c(name='e', obra__c = o.id);
        insert e;
        
        Expensa_gasto_general__c eg = new Expensa_gasto_general__c(name = 'luz',expensa__c = e.id, importe__c = 10);
        insert eg;
        
        Expensa_unidad__c eu = new Expensa_unidad__c(Expensa__c = e.id, Unidad__c = u.id, Obra__c = o.id, Monto_pagado__c = 1, fecha_pago__c = date.today());
        insert eu;
        
        PageReference pageRef = Page.vf_expensa_unidad  ;
        Test.setCurrentPage(pageRef); 

        pageRef.getParameters().put('id',eu.id);
        
        List <Expensa_Unidad__c> inds = new List<Expensa_Unidad__c>();
        inds.add(eu);

        
        Apexpages.StandardController sc = new Apexpages.StandardController(eu);
        myExpensaUnidadExtension ext = new myExpensaUnidadExtension(sc);


        ext.doSomething();
        ext.doSomethingMore();
        List<Expensa_gasto_general__c> egg = ext.getCuotas();
        //System.assertEquals('/apex/success', nextPage);
 
}

}