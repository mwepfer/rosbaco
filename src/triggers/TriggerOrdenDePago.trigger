trigger TriggerOrdenDePago on Orden_de_pago__c (before insert, after update, after delete) {
//falla el delete, hay que cambiar la logica para procesarlo separado
    if (Trigger.isInsert || trigger.isUpdate ) {
        for(Orden_de_pago__c op : Trigger.New) {
            Orden_de_compra__c oc = [SELECT valor_total__c FROM Orden_de_compra__c where id =: op.orden_de_compra__c  LIMIT 1];
            Decimal d = 0;
            Decimal facturas = 0;
            Decimal facturas_pesos = 0;

            List<Orden_de_pago__c> queryResults = [SELECT moneda__c,moneda__r.name, moneda__r.ultima_cotizacion__c, cotizacion_dolar__c, monto__c FROM Orden_de_pago__c where Orden_de_compra__c =:op.id and Estado__c = 'Pagada'];
            for (Orden_de_pago__c opp : queryResults) {
                d = d+  opp.monto__c; 
            }

            if (oc.valor_total__c == 0 ) {
               op.addError('Falta cargar el detalle de la orden de compra');
            } else {
                if (d > oc.valor_total__c) {
                   op.addError('El importe de pagos supera el monto de la orden de compra: '+oc.valor_total__c);
                }
            }
        }
    }

    if (trigger.isDelete) {
        for(Orden_de_pago__c op : Trigger.Old) {
            Orden_de_compra__c oc = [SELECT valor_total__c FROM Orden_de_compra__c where id =: op.orden_de_compra__c  LIMIT 1];
            Decimal d = 0;

            List<Orden_de_pago__c> queryResults = [SELECT moneda__c,moneda__r.name, moneda__r.ultima_cotizacion__c, cotizacion_dolar__c, monto__c FROM Orden_de_pago__c where Orden_de_compra__c =:op.id and Estado__c = 'Pagada'];
            for (Orden_de_pago__c opp : queryResults) {
                d = d+  opp.monto__c; 
            }

            if (oc.valor_total__c == 0 ) {
               op.addError('Falta cargar el detalle de la orden de compra');
            } else {
                if (d > oc.valor_total__c) {
                   op.addError('El importe de pagos supera el monto de la orden de compra: '+oc.valor_total__c);
                }
            }
        }
    }
}