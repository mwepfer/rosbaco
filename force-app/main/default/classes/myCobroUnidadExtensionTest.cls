@isTest
private class myCobroUnidadExtensionTest {

    static testMethod void myUnitTest() {


        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Propietario').getRecordTypeId();
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
    
        Unidad__c u = new Unidad__c(name='u', obra__c = o.id, Porcentaje_expensas__c = 5, propietario_principal__c = a.id);
        insert u;

        Expensa__c e = new Expensa__c(name='e', obra__c = o.id);
        insert e;
        
        Expensa_gasto_general__c eg = new Expensa_gasto_general__c(name = 'luz',expensa__c = e.id, importe__c = 10);
        insert eg;
        
        Expensa_unidad__c eu = new Expensa_unidad__c(Expensa__c = e.id, Unidad__c = u.id, Obra__c = o.id, Monto_pagado__c = 1, fecha_pago__c = date.today());
        insert eu;

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

        
        PageReference pageRef = Page.vf_recibo_pago_unidad  ;
        Test.setCurrentPage(pageRef); 

        pageRef.getParameters().put('id',cu.id);
        
        List <Cobro_Unidad__c> inds = new List<Cobro_Unidad__c>();
        inds.add(cu);

        
        Apexpages.StandardController sc = new Apexpages.StandardController(cu);
        myCobroUnidadExtension ext = new myCobroUnidadExtension(sc);


        //System.assertEquals('/apex/success', nextPage);
 
}

}