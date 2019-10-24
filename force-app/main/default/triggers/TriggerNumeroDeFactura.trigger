trigger TriggerNumeroDeFactura on Factura__c (before insert,before update) {
    if(trigger.isInsert){
        for(Factura__c f : Trigger.New) {

            List<Factura__c> query = [SELECT Numero__c,Proveedor_de_la_Factura__c,Comprobante__c,Tipo_de_factura__c
                                    FROM Factura__c
                                    where proveedor_de_la_factura__c =:f.Proveedor_de_la_Factura__c
                                    and Numero__c =:f.Numero__c
                                    and Comprobante__c =: f.Comprobante__c
                                    and Tipo_de_factura__c =: f.Tipo_de_factura__c];
            if(query.size()>0){
                f.addError('La factura ya fue cargada');
            }
        }        
    }
}