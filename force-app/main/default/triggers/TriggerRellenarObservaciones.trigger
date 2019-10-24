trigger TriggerRellenarObservaciones on Movimiento_de_caja__c (after insert, before update, before delete) {
    if(Trigger.isinsert){
        for(Movimiento_de_caja__c mc : Trigger.new){
            mc.Observaciones__c ='Esta factura fue automaticamente cargada por el sistema';
        }
    }
}