trigger ValidacionUnidad on Unidad__c (Before insert, Before update, Before delete ) {
    if (Trigger.isInsert){
        for(Unidad__c u : Trigger.new){
            //si se inserta una unidad nueva en estado vendida           
            if(trigger.oldMap.get(u.Id).estado__c != u.estado__c && u.estado__c == 'Vendida'){
                // si alguno de estos campos es nulo
            //    if(u.Comercializadora__c = null || u.Fecha_boleto__c = null || u.Valor_real_operacion__c = null){
                   u.addError('no se puede cargar la unidad sin fecha de boleto, comercializadora o valor real.');
                }
            }
        }
    }