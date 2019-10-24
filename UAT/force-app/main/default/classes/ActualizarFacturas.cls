public with sharing class ActualizarFacturas {

    //private ApexPages.StandardSetController standardSetController; 
    public String name{get;set;}   
    public String facturasPendientes{get;set;} 
      

    public ActualizarFacturas(ApexPages.StandardSetController controller)
    {
        //this.standardSetController = standardSetController;
    }
 
    public PageReference doSomething()    
    {
        Integer contador = updateIndicadores();
        //updateIndicadoresNoencontrados();
        this.name = String.valueOf(contador);
        return null;
    }
    public PageReference doSomethingMore()    
    {
        //updateIndicadores();
        this.name = '';
        updateIndicadoresNoencontrados();
        return null;
    }
    
    //@future
    public Integer updateIndicadores()
    {
        
        Set<Id> contratosId = new Set<Id>();
        Set<Id> indicadoresId = new Set<Id>();

        aggregateresult[] contratos = [SELECT Contrato__c FROM Factura__c WHERE Periodo_certificacion__c != NULL and importe_neto__c != NULL GROUP BY Contrato__c];
        for (AggregateResult contrato : contratos) {
            contratosId.add(String.valueOf(contrato.get('Contrato__c')));       
        }

        aggregateresult[] indicadores = [SELECT Indicador__c FROM Formula_mayor_costo__c WHERE Contrato__c IN :contratosId GROUP BY Indicador__c];
        for (AggregateResult indicador : indicadores) {
            indicadoresId.add(String.valueOf(indicador.get('Indicador__c')));       
        }
        
        
        
        List<Formula_mayor_costo__c> fmc = [SELECT Id, Name, Indicador__c,Porcentaje_incidencia__c, Fecha_base__c, Contrato__c FROM Formula_mayor_costo__c WHERE Contrato__c IN :contratosId ORDER BY Contrato__c];
        Map<Id, Formula_mayor_costo__c> mfmc = new Map<Id, Formula_mayor_costo__c>(fmc);

        List<Indicador_valor__c> iv = [SELECT Id, Name, Indicador__c, Valor__c, Periodo__c FROM Indicador_valor__c WHERE Indicador__c IN :indicadoresId ORDER BY Indicador__c];
        Map<Id, Indicador_valor__c> miv = new Map<Id, Indicador_valor__c>(iv);

        List<Indicador__c> ind = [SELECT Id, Name FROM Indicador__c WHERE Id IN :indicadoresId ORDER BY Id];
        Map<Id, Indicador__c> mi = new Map<Id, Indicador__c>(ind);
        
        //List<Factura__c> queryResults = [SELECT Id, Name, Contrato__c, Periodo_certificacion__c, Importe_neto__c FROM Factura__c WHERE Contrato__c = 'a025A00000lFO48QAG'  and Periodo_certificacion__c != NULL and importe_neto__c != NULL];
        List<Factura__c> queryResults = [SELECT Id, Name, Contrato__c, Periodo_certificacion__c, Importe_neto__c FROM Factura__c WHERE Periodo_certificacion__c != NULL and importe_neto__c != NULL and (coeficiente_provisorio__c = 'SI' or buscar_ultimo_valor_conocido__c = true) ORDER BY Fecha__c DESC];
        Factura__c fac;
        Decimal coe = 0;
        Decimal d;
        Integer i = 0;
        String nombre ;
        Integer encontre = 0;
        Boolean encontrePeriodo = false;

        String[] strDate;
        Integer myIntDate = 1;
        Integer myIntMonth;
        Integer myIntYear;
        Date dat;
        String mes ;
        String nuevoPeriodo;     
        Integer contador = 0;
        Integer contadorUpdates = 0;


        List<Factura__c> facturas = new List<Factura__c>();


        if (queryResults.size()>0) {
            for (Factura__c f : queryResults) {

                d = f.importe_neto__c;
                Num2Text nwcObj = new Num2Text();
                String numInWords = nwcObj.getNumberTOWordConvertion(d);            
                f.importe_letras__c = numInWords;
                f.buscar_ultimo_valor_conocido__c = false;
                            
                

// REFACTOR VER SI ES NECESARIO RECORRER INDICADORES SINO OBTENER DIRECTO EL NOMBRE

                for ( ID aID : mfmc.keySet() ){ //recorro las formulas
                    //System.debug('fmc:'+mfmc.get(aID).Contrato__c);           
                    if (mfmc.get(aID).Contrato__c == f.Contrato__c){ //encuentro la formula del contrato de la factura
                        for ( ID bID : miv.keySet() ){ //recorro los valores 
                            if (miv.get(bID).Periodo__c == f.Periodo_certificacion__c && miv.get(bID).Indicador__c == mfmc.get(aID).Indicador__c){ //encuentro el periodo
                                encontre = 1;
                                for ( ID cID : mi.keySet() ){ //recorro los indicadores 
                                    if (mi.get(cID).Id == mfmc.get(aID).Indicador__c){ //encuentro el indicador
                                        nombre = mi.get(cID).Name;
                                        break;                  
                                    } // if encuentro el nombre indicador
                                } // for recorro indicadores
                                //if (i==0){ f.Indicador1__c = miv.get(bID).Valor__c; f.Nombre_indicador1__c = nombre; }
                                //if (i==1){ f.Indicador2__c = miv.get(bID).Valor__c; f.Nombre_indicador2__c = nombre; }
                                //if (i==2){ f.Indicador3__c = miv.get(bID).Valor__c; f.Nombre_indicador3__c = nombre; }
                                //if (i==3){ f.Indicador4__c = miv.get(bID).Valor__c; f.Nombre_indicador4__c = nombre; }
                                //if (i==4){ f.Indicador5__c = miv.get(bID).Valor__c; f.Nombre_indicador5__c = nombre; }
                                //if (i==5){ f.Indicador6__c = miv.get(bID).Valor__c; f.Nombre_indicador6__c = nombre; }
                                //if (i==6){ f.Indicador7__c = miv.get(bID).Valor__c; f.Nombre_indicador7__c = nombre; }
                                //if (i==7){ f.Indicador8__c = miv.get(bID).Valor__c; f.Nombre_indicador8__c = nombre; }
                                //if (i==8){ f.Indicador9__c = miv.get(bID).Valor__c; f.Nombre_indicador9__c = nombre; }
                                //if (i==9){ f.Indicador10__c = miv.get(bID).Valor__c; f.Nombre_indicador10__c = nombre; }
    
                                for ( ID dID : miv.keySet() ){ //recorro los valores 
                                    if (miv.get(dID).Indicador__c == mfmc.get(aID).Indicador__c){ //encuentro el indicador
                                        if (miv.get(dID).Periodo__c == mfmc.get(aID).Fecha_base__c){ //encuentro el periodo base
                                            coe = coe + 
                                                  miv.get(bID).Valor__c/miv.get(dID).Valor__c *
                                                  mfmc.get(aID).Porcentaje_incidencia__c / 
                                                  100;
                                          break;
                                        }
                                    }
                                } // for recorro valores base
                                i = i+1;
                                break;          
                            } // if encuentro periodo indicador
                        } // for recorrer valores
                        
                        if (encontre == 0){ //no encontre valor para el periodo
                            f.buscar_ultimo_valor_conocido__c = true;
                            f.Indicador1__c = null;
                            f.Indicador2__c = null;
                            f.Indicador3__c = null;
                            f.Indicador4__c = null;
                            f.Indicador5__c = null;
                            f.Indicador6__c = null;
                            f.Indicador7__c = null;
                            f.Indicador8__c = null;
                            f.Indicador9__c = null;
                            f.Indicador10__c = null;
                            f.Nombre_indicador1__c = null;
                            f.Nombre_indicador2__c = null;
                            f.Nombre_indicador3__c = null;
                            f.Nombre_indicador4__c = null;
                            f.Nombre_indicador5__c = null;
                            f.Nombre_indicador6__c = null;
                            f.Nombre_indicador7__c = null;
                            f.Nombre_indicador8__c = null;
                            f.Nombre_indicador9__c = null;
                            f.Nombre_indicador10__c = null;
                            
                        } // if encuentro periodo original
                        encontre = 0;
                    } // if encuentro contrato formula
                } // for recorro formulas
                i = 0;
                f.actualizacion_batch__c = true;
                f.coeficiente__c = coe-1;            
                facturas.add(f);
                if (f.buscar_ultimo_valor_conocido__c == true){ 
                    contador++;
                }
                contadorUpdates ++;
                coe = 0;
                encontre = 0;
                encontrePeriodo = false;
            }
            
            //System.debug('facturas para actualizar:'+facturas.size());
            try {
                update facturas;
            } catch (DMLException e){         

            }
        }
        if (contador > 0 ){
            this.facturasPendientes = 'Quedaron '+String.valueOf(contador) + ' facturas por actualizar dado que no se encontraron indicadores conocidos';
        }
        return contadorUpdates;
    }



    //@future
    public void updateIndicadoresNoencontrados()    
    {

        Set<Id> contratosId = new Set<Id>();
        Set<Id> indicadoresId = new Set<Id>();

        aggregateresult[] contratos = [SELECT Contrato__c FROM Factura__c WHERE Periodo_certificacion__c != NULL and importe_neto__c != NULL and buscar_ultimo_valor_conocido__c = true GROUP BY Contrato__c];
        for (AggregateResult contrato : contratos) {
            contratosId.add(String.valueOf(contrato.get('Contrato__c')));       
        }

        aggregateresult[] indicadores = [SELECT Indicador__c FROM Formula_mayor_costo__c WHERE Contrato__c IN :contratosId GROUP BY Indicador__c];
        for (AggregateResult indicador : indicadores) {
            indicadoresId.add(String.valueOf(indicador.get('Indicador__c')));       
        }



        List<Formula_mayor_costo__c> fmc = [SELECT Id, Name, Indicador__c,Porcentaje_incidencia__c, Fecha_base__c, Contrato__c FROM Formula_mayor_costo__c WHERE Contrato__c IN :contratosId ORDER BY Contrato__c];
        Map<Id, Formula_mayor_costo__c> mfmc = new Map<Id, Formula_mayor_costo__c>(fmc);

        List<Indicador_valor__c> iv = [SELECT Id, Name, Indicador__c, Valor__c, Periodo__c FROM Indicador_valor__c WHERE Indicador__c IN :indicadoresId ORDER BY Indicador__c, Valor__c desc];
        Map<Id, Indicador_valor__c> miv = new Map<Id, Indicador_valor__c>(iv);

        List<Indicador__c> ind = [SELECT Id, Name FROM Indicador__c WHERE Id IN :indicadoresId ORDER BY Id];
        Map<Id, Indicador__c> mi = new Map<Id, Indicador__c>(ind);
        
        Integer facturasActualizar = 0 ;
        facturasActualizar = [SELECT count() FROM Factura__c WHERE Periodo_certificacion__c != NULL and importe_neto__c != NULL and buscar_ultimo_valor_conocido__c = true ];


        //List<Factura__c> queryResults = [SELECT Id, Name, Contrato__c, Periodo_certificacion__c, Importe_neto__c FROM Factura__c WHERE Contrato__c = 'a025A00000lFO48QAG'  and Periodo_certificacion__c != NULL and importe_neto__c != NULL];
        List<Factura__c> queryResults = [SELECT Id, Name, Contrato__c, Periodo_certificacion__c, Importe_neto__c FROM Factura__c WHERE Periodo_certificacion__c != NULL and importe_neto__c != NULL and buscar_ultimo_valor_conocido__c = true ORDER BY Contrato__c LIMIT 100];
        Factura__c fac;
        Decimal coe = 0;
        Decimal d;
        Integer i = 0;
        String nombre ;
        Integer encontre = 0;
        Boolean encontrePeriodo = false;
        Boolean periodoInexistente = false;
        this.facturasPendientes = '';

        String[] strDate;
        Integer myIntDate = 1;
        Integer myIntMonth;
        Integer myIntYear;
        Date dat;
        String mes ;
        String nuevoPeriodo;     
        Integer contador = 0;
        String periodoFactura = '';


        List<Factura__c> facturas = new List<Factura__c>();
        //System.debug('facturas con indicadnos no encontrados');


        if (queryResults.size()>0) {
            for (Factura__c f : queryResults) {

                d = f.importe_neto__c;
                Num2Text nwcObj = new Num2Text();
                String numInWords = nwcObj.getNumberTOWordConvertion(d);            
                f.importe_letras__c = numInWords;
                f.Indicador1__c = null;
                f.Indicador2__c = null;
                f.Indicador3__c = null;
                f.Indicador4__c = null;
                f.Indicador5__c = null;
                f.Indicador6__c = null;
                f.Indicador7__c = null;
                f.Indicador8__c = null;
                f.Indicador9__c = null;
                f.Indicador10__c = null;
                f.Nombre_indicador1__c = null;
                f.Nombre_indicador2__c = null;
                f.Nombre_indicador3__c = null;
                f.Nombre_indicador4__c = null;
                f.Nombre_indicador5__c = null;
                f.Nombre_indicador6__c = null;
                f.Nombre_indicador7__c = null;
                f.Nombre_indicador8__c = null;
                f.Nombre_indicador9__c = null;
                f.Nombre_indicador10__c = null;
                periodoFactura = f.Periodo_certificacion__c;
                periodoInexistente = false;

                //System.debug('factura:'+f.id);
                //System.debug('contrato:'+f.Contrato__c);
                //System.debug('periodo inicial: '+periodoFactura);
                
                for ( ID aID : mfmc.keySet() ){ //recorro las formulas
                    //System.debug('fmc:'+mfmc.get(aID).Contrato__c);           
                    if (mfmc.get(aID).Contrato__c == f.Contrato__c){ //encuentro la formula del contrato de la factura
                            //System.debug('Indicador: '+mfmc.get(aID).Indicador__c);
                            encontrePeriodo = false;
                            periodoFactura = f.Periodo_certificacion__c;
                            contador = 0;
                            
                            while (encontrePeriodo == false && contador < 84){
                                //System.debug('Contador: '+contador);
                                
                                strDate = periodoFactura.split('-');
                                myIntDate = 1;
                                myIntMonth = integer.valueOf(strDate[0]);
                                myIntYear = integer.valueOf(strDate[1]);
                                myIntMonth = myIntMonth - 1;
                                if (myIntMonth <= 0 ){
                                    myIntMonth = 12;
                                    myIntYear = myIntYear -1;
                                    if (myIntYear == 2014) {
                                        periodoInexistente = true;
                                    }
                                }
                                dat = Date.newInstance(myIntYear, myIntMonth, myIntDate);
                                mes = String.valueof(dat.month()).leftpad(2, '0');
                                nuevoPeriodo = mes+'-'+dat.year();   
                                //System.debug('Nuevo periodo: '+nuevoPeriodo);
                                periodoFactura = nuevoPeriodo;
                                f.coeficiente_provisorio__c = 'SI';         
                                
                                for ( ID bID : miv.keySet() ){ //recorro los valores 
                                    //if (miv.get(bID).Indicador__c == mfmc.get(aID).Indicador__c){ //encuentro el periodo
                                        //System.debug('Indicador iterado: '+miv.get(bID).Indicador__c);
                                        //System.debug('Indicador valor: '+miv.get(bID).Valor__c);
                                        //System.debug('Indicador periodo: '+miv.get(bID).Periodo__c);
                                    //}
                                    if (miv.get(bID).Periodo__c == nuevoPeriodo && miv.get(bID).Indicador__c == mfmc.get(aID).Indicador__c){ //encuentro el periodo
                                        //System.debug('Encontrado: SI');
                                        encontre = 1;
                                        encontrePeriodo = true;
                                        for ( ID cID : mi.keySet() ){ //recorro los indicadores 
                                            if (mi.get(cID).Id == mfmc.get(aID).Indicador__c){ //encuentro el indicador
                                                nombre = mi.get(cID).Name;
                                                break;                  
                                            } // if encuentro el nombre indicador
                                        } // for recorro indicadores
                                        if (i==0){ f.Indicador1__c = miv.get(bID).Valor__c; f.Nombre_indicador1__c = nombre; }
                                        if (i==1){ f.Indicador2__c = miv.get(bID).Valor__c; f.Nombre_indicador2__c = nombre; }
                                        if (i==2){ f.Indicador3__c = miv.get(bID).Valor__c; f.Nombre_indicador3__c = nombre; }
                                        if (i==3){ f.Indicador4__c = miv.get(bID).Valor__c; f.Nombre_indicador4__c = nombre; }
                                        if (i==4){ f.Indicador5__c = miv.get(bID).Valor__c; f.Nombre_indicador5__c = nombre; }
                                        if (i==5){ f.Indicador6__c = miv.get(bID).Valor__c; f.Nombre_indicador6__c = nombre; }
                                        if (i==6){ f.Indicador7__c = miv.get(bID).Valor__c; f.Nombre_indicador7__c = nombre; }
                                        if (i==7){ f.Indicador8__c = miv.get(bID).Valor__c; f.Nombre_indicador8__c = nombre; }
                                        if (i==8){ f.Indicador9__c = miv.get(bID).Valor__c; f.Nombre_indicador9__c = nombre; }
                                        if (i==9){ f.Indicador10__c = miv.get(bID).Valor__c; f.Nombre_indicador10__c = nombre; }
        
                                        for ( ID dID : miv.keySet() ){ //recorro los valores 
                                            if (miv.get(dID).Indicador__c == mfmc.get(aID).Indicador__c){ //encuentro el indicador
                                                if (miv.get(dID).Periodo__c == mfmc.get(aID).Fecha_base__c){ //encuentro el periodo base
                                                    coe = coe + miv.get(bID).Valor__c/miv.get(dID).Valor__c*mfmc.get(aID).Porcentaje_incidencia__c/100;
                                                    break;
                                                }
                                            }
                                        } // for recorro valores base
                                        i = i+1;
                                        break;          
                                    } // if encuentro periodo indicador
                                } // for recorrer valores
                                contador ++;
                            } // while encontre periodo
                    } // if encuentro contrato formula
                } // for recorro formulas
                i = 0;
                f.actualizacion_batch__c = true;
                f.coeficiente__c = coe-1;         
                if (periodoInexistente == false){
                    f.buscar_ultimo_valor_conocido__c = false;   
                }
                facturas.add(f);
                coe = 0;
                encontre = 0;
                encontrePeriodo = false;
            }
            
            //System.debug('facturas para actualizar:'+facturas.size());
            this.name = String.valueOf(facturas.size());

            facturasActualizar = facturasActualizar - facturas.size();
            if (facturasActualizar > 0) {
                this.facturasPendientes = 'Quedaron por actualizar '+facturasActualizar ;               
            }
            try {
                update facturas;
            } catch (DMLException e){         

            }
        }
    }
 

     
}