trigger FacturaItemNew on Factura_item__c (after insert, after update) {

    if (Trigger.isInsert || Trigger.isUpdate) {
		Integer cuenta = 0 ;
		Decimal total = 0 ;
		Double porcentaje = 0.0;
    	
        for(Factura_item__c f : Trigger.New) {
        	cuenta = 0;
        	total = 0;
			List<Factura_item__c> queryResults = [SELECT Id, Entregado__c FROM Factura_item__c WHERE Factura__c =: f.Factura__c ];

			List<Factura_item__c> factura_items = new List<Factura_item__c>();
	
			total = queryResults.size();
		 	if (queryResults.size()>0) {
				for (Factura_item__c fi : queryResults) {
					if (fi.Entregado__c == true) {
						cuenta++;
						System.debug('Cuenta:'+cuenta);			
					}
				}// end for factura items
		 	}

	        if (cuenta > 0){
	        	porcentaje = cuenta/total*100;
	        } else {
	        	porcentaje = 0;
	        }
			Factura__c fact = [SELECT Id, Porcentaje_entregado__c FROM Factura__c WHERE id =: f.Factura__c  LIMIT 1];
			fact.Porcentaje_entregado__c =  porcentaje;
			fact.Actualizacion_batch__c = true;
			update fact;       	
	        
        } 
        
    }

}