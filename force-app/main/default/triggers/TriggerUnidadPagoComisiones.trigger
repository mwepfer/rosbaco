trigger TriggerUnidadPagoComisiones on Unidad__c (before insert, before update, before delete) {
    if (Trigger.isInsert ) {
        for(Unidad__c u : Trigger.New) {
            if (u.Importe_pagado_broker__c > 0) {
                Movimiento_de_caja__c mc = New Movimiento_de_caja__c(
                    caja__c = u.Caja_pago_broker__c,
                    fecha_movimiento__c = u.Fecha_pago_comision_broker__c,
                    importe__c = u.Importe_pagado_broker__c *-1,
                    medio_de_pago__c = 'Efectivo',
                    unidad__c = u.id,
                    estado__c = 'Impactado'
                    );
                insert mc;
                u.Movimiento_de_caja_comision_broker__c = mc.id;
            }                
            if (u.Importe_pagado_comision_comercial__c > 0) {
                Movimiento_de_caja__c mc = New Movimiento_de_caja__c(
                    caja__c = u.Caja_pago_broker__c,
                    fecha_movimiento__c = u.Fecha_pago_comision_comercial__c,
                    importe__c = u.Importe_pagado_comision_comercial__c *-1,
                    medio_de_pago__c = 'Efectivo',
                    unidad__c = u.id,
                    estado__c = 'Impactado'
                    );
                insert mc;
                u.Movimiento_de_caja_comision_comercial__c = mc.id;
            }                
        }
    }
    if (trigger.isUpdate ) {
        for(Unidad__c u : Trigger.New) {
            if (u.Importe_pagado_broker__c >= 0) {
                Movimiento_de_caja__c[] mcs = [SELECT caja__c, fecha_movimiento__c, importe__c, medio_de_pago__c,
                unidad__c, plan_de_pago__c FROM Movimiento_de_caja__c WHERE id =: u.Movimiento_de_caja_comision_broker__c LIMIT 1];
                if (mcs.size() > 0 ) {
                    Movimiento_de_caja__c mc = [SELECT caja__c, fecha_movimiento__c, importe__c, medio_de_pago__c,
                    unidad__c, plan_de_pago__c FROM Movimiento_de_caja__c WHERE id =: u.Movimiento_de_caja_comision_broker__c LIMIT 1];
    
                    mc.fecha_movimiento__c = u.Fecha_pago_comision_broker__c;
                    mc.importe__c = u.Importe_pagado_broker__c *-1;
                    mc.medio_de_pago__c = 'Efectivo';
                    mc.Unidad__c = u.id;
                    mc.estado__c = 'Impactado';
                    update mc;
                } else {
                    Movimiento_de_caja__c mc = New Movimiento_de_caja__c(
                        caja__c = u.Caja_pago_broker__c,
                        fecha_movimiento__c = u.Fecha_pago_comision_broker__c,
                        importe__c = u.Importe_pagado_broker__c*-1,
                        medio_de_pago__c = 'Efectivo',
                        unidad__c = u.id,
                        estado__c = 'Impactado'
                        );
                    insert mc;
                    u.Movimiento_de_caja_comision_broker__c = mc.id;
                }                
            }            
            if (u.Importe_pagado_comision_comercial__c >= 0) {
                Movimiento_de_caja__c[] mcs = [SELECT caja__c, fecha_movimiento__c, importe__c, medio_de_pago__c,
                unidad__c, plan_de_pago__c FROM Movimiento_de_caja__c WHERE id =: u.Movimiento_de_caja_comision_comercial__c LIMIT 1];
                if (mcs.size() > 0 ) {
                    Movimiento_de_caja__c mc = [SELECT caja__c, fecha_movimiento__c, importe__c, medio_de_pago__c,
                    unidad__c, plan_de_pago__c FROM Movimiento_de_caja__c WHERE id =: u.Movimiento_de_caja_comision_comercial__c LIMIT 1];
    
                    mc.fecha_movimiento__c = u.Fecha_pago_comision_comercial__c;
                    mc.importe__c = u.Importe_pagado_comision_comercial__c *-1;
                    mc.medio_de_pago__c = 'Efectivo';
                    mc.Unidad__c = u.id;
                    mc.estado__c = 'Impactado';
                    update mc;
                } else {
                    Movimiento_de_caja__c mc = New Movimiento_de_caja__c(
                        caja__c = u.Caja_pago_broker__c,
                        fecha_movimiento__c = u.Fecha_pago_comision_comercial__c,
                        importe__c = u.Importe_pagado_comision_comercial__c*-1,
                        medio_de_pago__c = 'Efectivo',
                        unidad__c = u.id,
                        estado__c = 'Impactado'
                        );
                    insert mc;
                    u.Movimiento_de_caja_comision_comercial__c = mc.id;
                }                
            }            

        }
    }
    if (trigger.isDelete) {
        for(Unidad__c u : Trigger.Old) {
            if (u.Movimiento_de_caja_comision_broker__c != null) {
                    Movimiento_de_caja__c mc = [SELECT caja__c, fecha_movimiento__c, importe__c, medio_de_pago__c,
                    unidad__c, plan_de_pago__c FROM Movimiento_de_caja__c WHERE id =: u.Movimiento_de_caja_comision_broker__c LIMIT 1];
                delete mc;
            }            
            if (u.Movimiento_de_caja_comision_comercial__c != null) {
                    Movimiento_de_caja__c mc = [SELECT caja__c, fecha_movimiento__c, importe__c, medio_de_pago__c,
                    unidad__c, plan_de_pago__c FROM Movimiento_de_caja__c WHERE id =: u.Movimiento_de_caja_comision_comercial__c LIMIT 1];
                delete mc;
            }            
        }
    }


}