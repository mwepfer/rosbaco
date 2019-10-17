@isTest
private class OrdenPagoCajaTriggerTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Proveedor').getRecordTypeId();
        Id RecordTypeIdAccountSociedad = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sociedad desarrolladora').getRecordTypeId();
        
        Account a = new Account(name = 'test123', recordtypeid = RecordTypeIdAccount , cbu__c = '1234567890123456789012');
        insert a;

        Account so = new Account(name = 'test123', recordtypeid = RecordTypeIdAccountSociedad, cbu__c = '1234567890123456789012' );
        insert so;

        Moneda__c m = new Moneda__c(name='Dolares');
        insert m;

        moneda_cotizacion__c mc = new moneda_cotizacion__c (moneda__c = m.id, cotizacion__c = 1, fecha__c = date.today());
        insert mc;

        Obra__c o = new Obra__c(name='test');
        insert o;

        Responsable__c r = new Responsable__c(name = 'test');
        insert r;

        Presupuesto_base__c p = new Presupuesto_base__c(name='test', monto__c = 1, obra__c = o.id, proveedor__c = a.id, moneda__c = m.id, responsable_carga__c = r.id);
        insert p;

        Orden_de_compra__c oc = new Orden_de_compra__c(name='oc', proveedor__c = a.id, obra__c = o.id, presupuesto__c = p.id, moneda__c = m.id, responsable_carga__c = r.id, sociedad__c = so.id, Requiere_certificacion__c = false);
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
        iv = new Indicador_valor__c(Indicador__c = ind.id, Valor__c = 102, Periodo__c = '02-2016');
        insert iv;
        
        
        //Formula_mayor_costo__c fm = new Formula_mayor_costo__c(Contrato__c = c.id, Indicador__c = ind.id, Porcentaje_incidencia__c = 1, Fecha_base__c = '12-2015');
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
        insert f;
        
        //f.contrato__c = c.id;
        f.importe_neto__c = 50;
        f.actualizacion_batch__c = false;
        f.Periodo_certificacion__c = '12-2015';
        f.Periodo_control_documentacion__c = '12-2015';
        update f;

        caja__c c = new caja__c(name ='test', moneda__c = m.id);
        insert c;
                
        orden_de_pago__c op = new Orden_de_pago__c(orden_de_compra__c = oc.id, factura__c = f.id, monto__c = 10, estado__c = 'Pagada', moneda__c = m.id, caja__c = c.id, fecha_de_pago__c = date.today());
        insert op;

        op.monto__c = 1;
        op.caja__c = c.id;
        op.fecha_de_pago__c = date.today();
        update op;
        
        cheque__c ch = new cheque__c(name='test');
        insert ch;

        orden_de_pago__c op2 = new Orden_de_pago__c(orden_de_compra__c = oc.id, factura__c = f.id, monto__c = 10, estado__c = 'Pagada', moneda__c = m.id, caja__c = c.id, cheque__c = ch.id, fecha_de_pago__c = date.today());
        insert op2;

        op2.monto__c = 1;
        op2.caja__c = c.id;
        op2.fecha_de_pago__c = date.today();
        update op2;

        
    }
}