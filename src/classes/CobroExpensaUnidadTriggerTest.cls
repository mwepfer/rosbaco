@isTest
private class CobroExpensaUnidadTriggerTest {

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
        
        Expensa_unidad__c eu = new Expensa_unidad__c(obra__c = o.id, expensa__c = e.id, unidad__c = u.id, actualizacion_por_trigger__c= false, Saldo_inicial__c=0, Monto_pagado__c = 1, fecha_pago__c = Date.today());
        insert eu;

        eu.monto_pagado__c = 1;
        update eu;
        
        delete eu;

        Expensa__c e2 = new Expensa__c(name='test2', obra__c = o.id);
        insert e2;
        
        Expensa_gasto_general__c egg2 = new Expensa_gasto_general__c(name='test', importe__c=10, expensa__c = e2.id);
        insert egg2;
        
        Expensa_unidad__c eu2 = new Expensa_unidad__c(obra__c = o.id, expensa__c = e2.id, unidad__c = u.id, actualizacion_por_trigger__c= false, Saldo_inicial__c=0, Monto_pagado__c = 1, fecha_pago__c = Date.today());
        insert eu2;

        Expensa_unidad__c eu3 = new Expensa_unidad__c(obra__c = o.id, expensa__c = e2.id, unidad__c = u.id, actualizacion_por_trigger__c= false, Saldo_inicial__c=0);
        insert eu3;

		eu3.monto_pagado__c = 1;
		eu3.fecha_pago__c = date.today();
		update eu3;
	
    }
}