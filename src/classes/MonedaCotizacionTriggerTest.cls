@isTest
private class MonedaCotizacionTriggerTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Moneda__c m = new Moneda__c(name='Pesos');
        insert m;
        
        
        Moneda_cotizacion__c mc = new Moneda_cotizacion__c (moneda__c = m.id, fecha__c = Date.newInstance(2016, 12, 9), cotizacion__c = 1);

        insert mc;
        
    }
    
}