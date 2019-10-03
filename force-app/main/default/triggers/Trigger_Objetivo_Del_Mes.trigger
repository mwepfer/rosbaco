trigger Trigger_Objetivo_Del_Mes on Objetivo_del_mes__c (after insert, after update, before delete) {
 if (Trigger.isDelete){
     for(Objetivo_del_mes__c o : trigger.old){
     if (o.Monto_actual_vendido__c > 0){
     o.addError('no se puede borrar el objetivo si ya se efectuo una venta.');
     }
   }
 }
}