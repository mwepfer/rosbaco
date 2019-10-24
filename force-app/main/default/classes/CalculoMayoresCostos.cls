public with sharing class CalculoMayoresCostos {
    public List<Indicador_valor__c> setIndicadores(String periodo, String contrato) {
		List<Formula_mayor_costo__c> queryResults = [SELECT Indicador__c,Porcentaje_incidencia__c, Fecha_base__c FROM Formula_mayor_costo__c where Contrato__c =:contrato ];
		List<Indicador_valor__c> indicadores = new List<Indicador_valor__c>();
	 	if (queryResults.size()>0) {
			for (Formula_mayor_costo__c o : queryResults) {
				try {
					Indicador_valor__c val = [SELECT Indicador__c, Valor__c FROM Indicador_valor__c WHERE Indicador__c =: o.Indicador__c and Periodo__c =:periodo LIMIT 1];
					Indicador__c nom = [SELECT Name FROM Indicador__c WHERE id =: val.Indicador__c  LIMIT 1];
					val.Nombre__c = nom.name;				
					Indicador_valor__c valBase = [SELECT Indicador__c, Valor__c FROM Indicador_valor__c WHERE Indicador__c =: o.Indicador__c and Periodo__c =:o.Fecha_base__c LIMIT 1];
					val.valor_base__c = valBase.Valor__c;
					val.Porcentaje_incidencia__c = o.Porcentaje_incidencia__c;
					val.coeficiente_provisorio__c = null;
					indicadores.add(val);
			 	} catch(Exception ex) {
			 		Boolean encontre = false;
			 		while (encontre == false){
						String[] strDate = periodo.split('-');
						Integer myIntDate = 1;
						Integer myIntMonth = integer.valueOf(strDate[0]);
						Integer myIntYear = integer.valueOf(strDate[1]);
						myIntMonth = myIntMonth - 1;
						if (myIntMonth <= 0 ){
							myIntMonth = 12;
							myIntYear = myIntYear -1;
						}
						Date dat = Date.newInstance(myIntYear, myIntMonth, myIntDate);
						String mes = String.valueof(dat.month()).leftpad(2, '0');
						String nuevoPeriodo = mes+'-'+dat.year();
						periodo = nuevoPeriodo;	 
				        System.debug('Nuevo periodo: '+nuevoPeriodo);
						try {
							Indicador_valor__c val = [SELECT Indicador__c, Valor__c FROM Indicador_valor__c WHERE Indicador__c =: o.Indicador__c and Periodo__c =:nuevoPeriodo LIMIT 1];
							Indicador__c nom = [SELECT Name FROM Indicador__c WHERE id =: val.Indicador__c  LIMIT 1];
							encontre = true;
							val.Nombre__c = nom.name;	
							val.coeficiente_provisorio__c = 'SI';			
							Indicador_valor__c valBase = [SELECT Indicador__c, Valor__c FROM Indicador_valor__c WHERE Indicador__c =: o.Indicador__c and Periodo__c =:o.Fecha_base__c LIMIT 1];
							val.valor_base__c = valBase.Valor__c;
							val.Porcentaje_incidencia__c = o.Porcentaje_incidencia__c;
							indicadores.add(val);
					 	} catch(Exception ex2) {				 	}
			 		}
			 	}
			}
	 	}
	 	return indicadores;
    }

}