trigger TriggerMonedaCotizacion on Moneda_cotizacion__c (after insert, after update, after delete) {
    if (Trigger.isInsert || trigger.isUpdate || trigger.isDelete) {
        for(Moneda_cotizacion__c mc : Trigger.New) {
                Moneda__c m = [SELECT fecha_ultima_cotizacion__c, ultima_cotizacion__c FROM Moneda__c where id =:mc.moneda__c LIMIT 1];

                Moneda_cotizacion__c mcmax = [SELECT cotizacion__c,fecha__c FROM Moneda_cotizacion__c where Moneda__c =:mc.moneda__c ORDER BY fecha__c DESC LIMIT 1];
                
                m.ultima_cotizacion__c = mcmax.cotizacion__c;
                //m.fecha_ultima_cotizacion__c = mcmax.fecha__c;
                
                update m;            
        }
    }
}