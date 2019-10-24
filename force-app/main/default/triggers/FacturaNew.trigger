trigger FacturaNew on Factura__c (before insert, before update) {
    if (Trigger.isInsert) {
        for(Factura__c f : Trigger.New) {

            if (f.Actualizacion_batch__c == false || f.Actualizacion_batch__c == null){
                Decimal d = f.importe_total__c;
                Num2Text nwcObj = new Num2Text();
                if (d != NULL) {
                    String numInWords = nwcObj.getNumberTOWordConvertion(d);            
                    
                    f.importe_letras__c = numInWords;
                }    
                           
            } else {
                f.Actualizacion_batch__c = false;
            }
            
            
            
        }   
    }
    else if (Trigger.isUpdate) {
        for(Factura__c f : Trigger.New) {
        
            if (f.Actualizacion_batch__c == false || f.Actualizacion_batch__c == null){
                Decimal d = f.importe_total__c;
                Num2Text nwcObj = new Num2Text();
                if (d != NULL) {
                    String numInWords = nwcObj.getNumberTOWordConvertion(d);           
                    f.importe_letras__c = numInWords;
                } 
                            
            } else {
                f.Actualizacion_batch__c = false;
            }
        }
    }
}