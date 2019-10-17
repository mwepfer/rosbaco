@isTest
private class CobroUnidadTriggerTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Proveedor').getRecordTypeId();
        Id RecordTypeIdAccountSociedad = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sociedad desarrolladora').getRecordTypeId();
        
        Account a = new Account(name = 'test123', recordtypeid = RecordTypeIdAccount , cbu__c = '1234567890123456789012');
        insert a;

        Account so = new Account(name = 'test123', recordtypeid = RecordTypeIdAccountSociedad , cbu__c = '1234567890123456789012');
        insert so;

        Moneda__c m = new Moneda__c(name='test');
        insert m;
        
        caja__c c = new Caja__c(name='test', moneda__c = m.id);
        insert c;

        Obra__c o = new Obra__c(name='test', caja_cobro_expensas__c = c.id);
        insert o;
                
        Unidad__c u = new Unidad__c(name='1', obra__c = o.id, Porcentaje_expensas__c = 1);
        insert u;
        
        Cobro_unidad__c cu = new Cobro_unidad__c(unidad__c = u.id, importe_cobrado__c = 1, caja__c = c.id, fecha_cobro__c = Date.Today(), vencimiento__c = date.today(), moneda__c = m.id);
        insert cu;

        cu.importe_cobrado__c = 1;
        update cu;
        
        delete cu;

        Cobro_unidad__c cu2 = new Cobro_unidad__c(unidad__c = u.id, vencimiento__c = date.today(), moneda__c = m.id);
        insert cu2;

		cu2.importe_cobrado__c = 1;
		cu2.caja__c = c.id;
		cu2.fecha_cobro__c = date.today();
		update cu2;
    }
}