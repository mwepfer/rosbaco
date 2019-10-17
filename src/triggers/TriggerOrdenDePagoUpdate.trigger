trigger TriggerOrdenDePagoUpdate on Orden_de_pago__c (before insert, before update) {
    if (Trigger.isInsert || trigger.isUpdate) {
        for(Orden_de_pago__c op : Trigger.New) {
                    if (op.cotizacion_dolar__c == null){
		                Moneda__c m = [SELECT ultima_cotizacion__c FROM Moneda__c where id =: op.moneda__c  LIMIT 1];

                        op.cotizacion_dolar__c = m.ultima_cotizacion__c;
                    }
        }
    }
    
}