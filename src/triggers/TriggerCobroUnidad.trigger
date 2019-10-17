trigger TriggerCobroUnidad on Cobro_unidad__c (before insert, before update, before delete) {
    if (Trigger.isInsert ) {
        for(Cobro_unidad__c cu : Trigger.New) {
            if (cu.importe_cobrado__c > 0) {
                if (cu.Estado_del_cobro__c == null) {
                    cu.addError('Debe indicar el estado del pago');
                } else {
                    Movimiento_de_caja__c mc = New Movimiento_de_caja__c(
                        caja__c = cu.caja__c,
                        fecha_movimiento__c = cu.fecha_cobro__c,
                        importe__c = cu.importe_cobrado__c,
                        medio_de_pago__c = cu.medio_de_pago__c,
                        unidad__c = cu.unidad__c,
                        estado__c = cu.Estado_del_cobro__c,
                        plan_de_pago__c = cu.id
                        );
                    insert mc;
                    cu.movimiento_de_caja__c = mc.id;
                }                
            }
        }
    }
    if (trigger.isUpdate ) {
        for(Cobro_unidad__c cu : Trigger.New) {
            if (cu.importe_cobrado__c >= 0) {
                Movimiento_de_caja__c[] mcs = [SELECT caja__c, fecha_movimiento__c, importe__c, medio_de_pago__c,
                unidad__c, plan_de_pago__c FROM Movimiento_de_caja__c WHERE id =: cu.movimiento_de_caja__c LIMIT 1];

                if (cu.Estado_del_cobro__c == null) {
                    cu.addError('Debe indicar el estado del pago');
                } else {
            
                    if (mcs.size() > 0 ) {
    
                        Movimiento_de_caja__c mc = [SELECT caja__c, fecha_movimiento__c, importe__c, medio_de_pago__c,
                        unidad__c, plan_de_pago__c FROM Movimiento_de_caja__c WHERE id =: cu.movimiento_de_caja__c LIMIT 1];
        
                        mc.fecha_movimiento__c = cu.fecha_cobro__c;
                        mc.importe__c = cu.importe_cobrado__c;
                        mc.medio_de_pago__c = cu.medio_de_pago__c;
                        mc.unidad__c = cu.unidad__c;
                        mc.estado__c = cu.estado_del_cobro__c ;
                        mc.plan_de_pago__c = cu.id;
                         
                        update mc;
                    } else {
                        Movimiento_de_caja__c mc = New Movimiento_de_caja__c(
                            caja__c = cu.caja__c,
                            fecha_movimiento__c = cu.fecha_cobro__c,
                            importe__c = cu.importe_cobrado__c,
                            medio_de_pago__c = cu.medio_de_pago__c,
                            unidad__c = cu.unidad__c,
                            estado__c = cu.estado_del_cobro__c,
                            plan_de_pago__c = cu.id
                            );
                        insert mc;
                        cu.movimiento_de_caja__c = mc.id;
                    }         
                }
            }                
            
        }
    }
    if (trigger.isDelete) {
        for(Cobro_unidad__c cu : Trigger.Old) {
            if (cu.movimiento_de_caja__c != null) {
                    Movimiento_de_caja__c mc = [SELECT caja__c, fecha_movimiento__c, importe__c, medio_de_pago__c,
                    unidad__c, plan_de_pago__c FROM Movimiento_de_caja__c WHERE id =: cu.movimiento_de_caja__c LIMIT 1];
                delete mc;
            }            
        }
    }


}