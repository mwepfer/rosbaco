trigger TriggerPagoExpensaUnidad on Expensa_unidad__c (before insert, before update, before delete) {
    if (Trigger.isInsert ) {
        for(Expensa_unidad__c eu : Trigger.New) {
            if (eu.Monto_pagado__c > 0) {

                Unidad__c u = [SELECT name, obra__r.caja_cobro_expensas__c FROM unidad__c WHERE id =: eu.unidad__c LIMIT 1];

                Movimiento_de_caja__c mc = New Movimiento_de_caja__c(
                    caja__c = u.obra__r.Caja_cobro_expensas__c,
                    fecha_movimiento__c = eu.fecha_pago__c,
                    importe__c = eu.Monto_pagado__c,
                    medio_de_pago__c = eu.medio_de_pago__c,
                    unidad__c = eu.unidad__c,
                    estado__c = 'Impactado',
                    expensa_unidad__c = eu.id
                    );
                insert mc;
                eu.movimiento_de_caja__c = mc.id;
            }                
        }
    }
    if (trigger.isUpdate ) {
        for(Expensa_unidad__c eu : Trigger.New) {
            if (eu.Monto_pagado__c >= 0) {
                Movimiento_de_caja__c[] mcs = [SELECT caja__c, fecha_movimiento__c, importe__c, medio_de_pago__c,
                unidad__c, plan_de_pago__c FROM Movimiento_de_caja__c WHERE id =: eu.movimiento_de_caja__c LIMIT 1];
            
                if (mcs.size() > 0 ) {

                    Movimiento_de_caja__c mc = [SELECT caja__c, fecha_movimiento__c, importe__c, medio_de_pago__c,
                    unidad__c, plan_de_pago__c FROM Movimiento_de_caja__c WHERE id =: eu.movimiento_de_caja__c LIMIT 1];
    
                    mc.fecha_movimiento__c = eu.fecha_pago__c;
                    mc.importe__c = eu.Monto_pagado__c;
                    mc.medio_de_pago__c = eu.medio_de_pago__c;
                    mc.unidad__c = eu.unidad__c;
                    mc.estado__c = 'Impactado';
                    mc.expensa_unidad__c = eu.id;
                     
                    update mc;
                } else {
                    Unidad__c u = [SELECT name, obra__r.caja_cobro_expensas__c FROM unidad__c WHERE id =: eu.unidad__c LIMIT 1];

                    Movimiento_de_caja__c mc = New Movimiento_de_caja__c(
                        caja__c = u.obra__r.Caja_cobro_expensas__c,
                        fecha_movimiento__c = eu.fecha_pago__c,
                        importe__c = eu.Monto_pagado__c,
                        medio_de_pago__c = eu.medio_de_pago__c,
                        unidad__c = eu.unidad__c,
                        estado__c = 'Impactado',
                        expensa_unidad__c = eu.id
                        );
                    insert mc;
                    eu.movimiento_de_caja__c = mc.id;
                }         
            }                
            
        }
    }
    if (trigger.isDelete) {
        for(Expensa_unidad__c eu : Trigger.Old) {
            if (eu.movimiento_de_caja__c != null) {
                    Movimiento_de_caja__c mc = [SELECT caja__c, fecha_movimiento__c, importe__c, medio_de_pago__c,
                    unidad__c, plan_de_pago__c FROM Movimiento_de_caja__c WHERE id =: eu.movimiento_de_caja__c LIMIT 1];
                delete mc;
            }            
        }
    }


}