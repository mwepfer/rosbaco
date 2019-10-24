@isTest
private class UnidadPagoComisionTriggerTest {
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Proveedor').getRecordTypeId();
        Id RecordTypeIdAccountSociedad = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sociedad desarrolladora').getRecordTypeId();
        
        Account a = new Account(name = 'test123', recordtypeid = RecordTypeIdAccount, cbu__c = '1234567890123456789012' );
        insert a;

        Account so = new Account(name = 'test123', recordtypeid = RecordTypeIdAccountSociedad , cbu__c = '1234567890123456789012');
        insert so;

        Moneda__c m = new Moneda__c(name='test');
        insert m;
        
        caja__c c = new Caja__c(name='test', moneda__c = m.id);
        insert c;

        Obra__c o = new Obra__c(name='test', caja_cobro_expensas__c = c.id);
        insert o;
        
        Unidad__c u = new Unidad__c(name='1', Moneda_comision__c = m.id,  obra__c = o.id, Porcentaje_expensas__c = 1, Fecha_pago_comision_broker__c = date.today(), Fecha_pago_comision_comercial__c = date.today(), Importe_pagado_broker__c = 1, Importe_pagado_comision_comercial__c = 1, Caja_pago_broker__c = c.id);
        insert u;

        Unidad__c u2 = new Unidad__c(name='1',Moneda_comision__c = m.id, obra__c = o.id, Porcentaje_expensas__c = 1, Caja_pago_broker__c = c.id);
        insert u2;
                
        u2.Importe_pagado_broker__c = 1;
        u2.Fecha_pago_comision_broker__c = date.today();
        u2.Importe_pagado_comision_comercial__c = 1;
        u2.Fecha_pago_comision_comercial__c = date.today();
        update u2;
    
    }
}