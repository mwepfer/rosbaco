trigger TriggerOrdenPagoCaja on Orden_de_pago__c (before insert, before update, before delete) {
    String estado = '';
    if (Trigger.isInsert ) {
        for(Orden_de_pago__c op : Trigger.New) {
            if (op.monto__c > 0 && op.estado__c == 'Pagada') {
                if (op.cheque__c == null) {
                    estado = 'Impactado';
                } else {
                    estado = 'Pendiente';
                }
                Movimiento_de_caja__c mc = New Movimiento_de_caja__c(
                    caja__c = op.caja__c,
                    fecha_movimiento__c = op.fecha_de_pago__c,
                    importe__c = op.monto__c *-1,
                    medio_de_pago__c = op.Tipo_instrumento__c,
                    orden_de_pago__c = op.id,
                    estado__c = estado,
                    cheque__c = op.cheque__c
                    );
                insert mc;
                op.movimiento_de_caja__c = mc.id;

            }                

        }
    }
    if (trigger.isUpdate ) {
        for(Orden_de_pago__c op : Trigger.New) {
            if (op.monto__c >= 0 && op.estado__c == 'Pagada') {
                Movimiento_de_caja__c[] mcs = [SELECT caja__c, fecha_movimiento__c, importe__c, medio_de_pago__c,
                unidad__c, plan_de_pago__c FROM Movimiento_de_caja__c WHERE id =: op.movimiento_de_caja__c LIMIT 1];

                if (op.cheque__c == null) {
                    estado = 'Impactado';
                } else {
                    estado = 'Pendiente';
                }
            
                if (mcs.size() > 0 ) {

                    Movimiento_de_caja__c mc = [SELECT caja__c, fecha_movimiento__c, importe__c, medio_de_pago__c,
                    unidad__c, plan_de_pago__c FROM Movimiento_de_caja__c WHERE id =: op.movimiento_de_caja__c LIMIT 1];
    
                    mc.fecha_movimiento__c = op.fecha_de_pago__c;
                    mc.importe__c = op.monto__c *-1;
                    mc.medio_de_pago__c = op.Tipo_instrumento__c;
                    mc.orden_de_pago__c = op.id;
                    mc.estado__c = estado;
                    mc.cheque__c = op.cheque__c;
                     
                    update mc;
                } else {
                    Movimiento_de_caja__c mc = New Movimiento_de_caja__c(
                        caja__c = op.caja__c,
                        fecha_movimiento__c = op.fecha_de_pago__c,
                        importe__c = op.monto__c*-1,
                        medio_de_pago__c = op.tipo_instrumento__c,
                        orden_de_pago__c = op.id,
                        estado__c = estado,
                        cheque__c = op.cheque__c
                        );
                    insert mc;
                    op.movimiento_de_caja__c = mc.id;
                }                
            }
            if (op.estado__c != 'Pagada' && op.movimiento_de_caja__c != null) {
                Movimiento_de_caja__c mc = [SELECT caja__c, fecha_movimiento__c, importe__c, medio_de_pago__c,
                unidad__c, plan_de_pago__c FROM Movimiento_de_caja__c WHERE id =: op.movimiento_de_caja__c LIMIT 1];
                delete mc;
                op.movimiento_de_caja__c = null;
            }                        
        }
    }
    if (trigger.isDelete) {
        for(Orden_de_pago__c op : Trigger.Old) {
            if (op.movimiento_de_caja__c != null) {
                    Movimiento_de_caja__c mc = [SELECT caja__c, fecha_movimiento__c, importe__c, medio_de_pago__c,
                    unidad__c, plan_de_pago__c FROM Movimiento_de_caja__c WHERE id =: op.movimiento_de_caja__c LIMIT 1];
                delete mc;
            }            
        }
    }


}