@isTest
    private class TestTriggerMovimientoDeCaja {
        static testMethod void TestTriggerMovimientoDeCaja(){
            Caja__c c = new Caja__c ();
            c.name = 'test';
            insert c;
            movimiento_de_caja__c mc = new movimiento_de_caja__c ( Fecha_movimiento__c = date.today(),Importe__c = 20000,Estado__c = 'Impactado', Caja__c = c.id);
            
            insert mc;
        }
    }