trigger ExpensaUnidadNew on Expensa_unidad__c (before insert, before update) {
    Decimal total = 0 ;
  	Integer i = 0;

    if (Trigger.isInsert || Trigger.isUpdate) {
        for(Expensa_unidad__c eu : Trigger.New) {

			if (eu.actualizacion_por_trigger__c == false) {
	            total = 0;
				i = 0;
				List<Expensa_unidad__c> eul = new List<Expensa_unidad__c>();
	            List<Expensa_unidad__c> queryResults = [SELECT Id, monto_a_pagar__c, saldo_inicial__c, monto_pagado__c, saldo_a_pagar__c FROM Expensa_unidad__c WHERE Unidad__c =: eu.Unidad__c ORDER by CreatedDate];
	            for (Expensa_unidad__c eui : queryResults) {
	            	i++;
	            	if (queryResults.size() == 1) {
	            	}  else {
	            		if (i == 1) {
	            			
	            		}
	                	if (eu.id != eui.id) {
		                	if (i > 1){
			                	//eui.saldo_inicial__c = 0;
	                		//} else {
			                	eui.saldo_inicial__c = total;
		                		eui.actualizacion_por_trigger__c  = true;
			                	eul.add(eui);
	                		}
		            		if (eui.monto_pagado__c == null) {
			                	total = eui.saldo_inicial__c + eui.monto_a_pagar__c;
		            		} else {
			                	total = eui.saldo_inicial__c + eui.monto_a_pagar__c - eui.monto_pagado__c;
		            		}
	
	                	} else {
	                		eui.monto_pagado__c = eu.monto_pagado__c;
	                		if (i == queryResults.size()) {
			                	eu.saldo_inicial__c = total;	                			
			                	eui.saldo_inicial__c = total;
	                		} else {
	                			if (i == 1){
				                	eui.saldo_inicial__c = eu.saldo_inicial__c;    		
	                			}else {
				                	eu.saldo_inicial__c = total;	                			
				                	eui.saldo_inicial__c = total;
	                				
	                			}	
	                		}
		                	if (i == 1){
			            		if (eu.monto_pagado__c == null) {
				                	total = eu.saldo_inicial__c + eu.monto_a_pagar__c;
			            		} else {
				                	total = eu.saldo_inicial__c + eu.monto_a_pagar__c - eu.monto_pagado__c;
			            		}
		                	} else {
			            		if (eui.monto_pagado__c == null) {
				                	total = eui.saldo_inicial__c + eui.monto_a_pagar__c;
			            		} else {
				                	total = eui.saldo_inicial__c + eui.monto_a_pagar__c - eui.monto_pagado__c;
			            		}
		                	}
	                	}
	            	}
	            }
	            
				if (i > 1 ){	
		            
		            update eul;
				}
			} else {
				eu.actualizacion_por_trigger__c = false;
			}
        }
    }
}