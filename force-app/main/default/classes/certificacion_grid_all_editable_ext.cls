// prueba dev1
public class certificacion_grid_all_editable_ext {
  
    public certificacion_grid_all_editable_ext(ApexPages.StandardController controller) {
        this.certificacion = [SELECT Id, Name, Orden_de_compra__c, observaciones__c , valor_actual__c, acumulado_anterior__c, acumulado_total__c  FROM certificacion__c WHERE id =: ApexPages.CurrentPage().getparameters().get('id')  LIMIT 1];

        this.certificacion.valor_actual__c = 0;
        this.certificacion.acumulado_total__c = 0;
        this.certificacion.acumulado_anterior__c = 0;
  
        this.certificaciones = [ SELECT 
          d.Name, 
          d.Orden_de_compra__c,
          d.observaciones__c 
          FROM 
          Certificacion__c d 
          where id =: this.certificacion.id ];
    
        this.orden_de_compra_detalles = [ SELECT 
          d.detalle__c, 
          d.subtotal__c,
          d.Id,
          d.cantidad__c,
          d.valor_unitario__c,
          d.concepto__c,
          d.rubro__c,
          d.valor_total__c
          FROM 
          Orden_de_compra_entrega__c     d
          WHERE orden_de_compra__c =:  this.certificacion.Orden_de_compra__c        
          order by d.detalle__c, d.concepto__c, d.rubro__c,  d.id ];
    
        this.certificacion_detalles = [ SELECT 
          d.name, 
          d.concepto__c,
          d.rubro__c,
          d.certificacion__r.name,
          d.Orden_de_compra_detalle__c,
          d.valor_actual__c,
          d.subtotal__c,
          d.porcentaje_avance__c,
          d.porcentaje_avance_total__c,
          d.Porcentaje_avance_acumulado_anterior__c,
          d.Valor_acumulado_anterior__c,
          d.Valor_acumulado_total__c
          FROM 
          certificacion_detalle__c     d
          WHERE certificacion__c =:  this.certificacion.id
          order by id];
    
        if (this.certificacion_detalles.size() > 0) {
            actualizacion = true;
        } else{
            actualizacion = false;

            this.certificaciones_anteriores = [ SELECT 
              d.Name, 
              d.Orden_de_compra__c,
              d.observaciones__c 
              FROM 
              Certificacion__c d 
              where name <: this.certificacion.name and orden_de_compra__c =: this.certificacion.orden_de_compra__c order by createddate desc LIMIT 1 ];

            if (this.certificaciones_anteriores.size() > 0 ) {
    
            this.certificaciones_anterior = [ SELECT 
              d.Name, 
              d.Orden_de_compra__c,
              d.observaciones__c 
              FROM 
              Certificacion__c d 
              where name <: this.certificacion.name and orden_de_compra__c =: this.certificacion.orden_de_compra__c order by createddate desc LIMIT 1 ];
              
                       
            this.certificacion_detalles_anteriores = [ SELECT 
              d.name, 
              d.Porcentaje_avance_acumulado_anterior__c,
              d.Valor_acumulado_anterior__c,
              d.Orden_de_compra_detalle__c ,
              d.Porcentaje_avance_total__c,
              d.concepto__c,
              d.rubro__c,
              d.Valor_acumulado_total__c
              FROM 
              certificacion_detalle__c     d
              WHERE certificacion__c =:  this.certificaciones_anterior.id];

            System.debug('matu2: '+this.certificacion_detalles_anteriores);
            }    
            this.certificacion_detalles = new List<certificacion_detalle__c>();
            for (orden_de_compra_entrega__c oe : this.orden_de_compra_detalles) {
        
                certificacion_detalle__c cert = New certificacion_detalle__c(
                name = oe.detalle__c, 
                certificacion__c = this.certificacion.id, 
                subtotal__c = oe.subtotal__c,
                cantidad__c = oe.cantidad__c,
                valor_unitario__c = oe.valor_unitario__c,
                concepto__c = oe.concepto__c,
                rubro__c = oe.rubro__c,
                orden_de_compra_detalle__c = oe.id);

                if (this.certificaciones_anteriores.size() > 0 ) {
                    for (certificacion_detalle__c cda : this.certificacion_detalles_anteriores) {
                        if (cda.Orden_de_compra_detalle__c == oe.id) {
                            cert.Porcentaje_avance_acumulado_anterior__c = cda.Porcentaje_avance_total__c;
                            cert.Valor_acumulado_anterior__c = cda.Valor_acumulado_total__c;
                        }
                    }
                }
    
                this.certificacion_detalles.add(cert);
            System.debug('matu3: '+this.certificacion_detalles);
                
             }
         }

         for (certificacion_detalle__c cd : this.certificacion_detalles) {
           

            //List<AggregateResult> res=[SELECT sum(porcentaje_avance__c)acum FROM certificacion_detalle__c WHERE Certificacion__r.name <: cd.certificacion__r.name AND name =: cd.name and orden_de_compra_detalle__c =: cd.orden_de_compra_detalle__c ];
            //cd.Porcentaje_avance_acumulado_anterior__c =(Decimal)res[0].get('acum'); 
            if (cd.Porcentaje_avance_acumulado_anterior__c >= 0){
            }else{
                cd.Porcentaje_avance_acumulado_anterior__c = 0;
            }
            if (cd.Porcentaje_avance__c >= 0){
            }else{
                cd.Porcentaje_avance__c = 0;
            }
            cd.Porcentaje_avance_total__c = cd.Porcentaje_avance_acumulado_anterior__c + cd.Porcentaje_avance__c;

            //List<AggregateResult> res2=[SELECT sum(valor_actual__c)acum FROM certificacion_detalle__c WHERE Certificacion__r.name <: cd.certificacion__r.name AND name =: cd.name and orden_de_compra_detalle__c =: cd.orden_de_compra_detalle__c ];
            //cd.Valor_acumulado_anterior__c =(Decimal)res2[0].get('acum'); 
            if (cd.Valor_acumulado_anterior__c >= 0){
            }else{
                cd.Valor_acumulado_anterior__c = 0;
            }
            if (cd.Valor_actual__c >= 0){
            }else{
                cd.Valor_actual__c = 0;
            }
            cd.Valor_acumulado_total__c = cd.Valor_acumulado_anterior__c + cd.Valor_actual__c;
            
            this.certificacion.Acumulado_anterior__c = this.certificacion.Acumulado_anterior__c + cd.Valor_acumulado_anterior__c;
            this.certificacion.Acumulado_total__c = this.certificacion.Acumulado_total__c + cd.Valor_acumulado_anterior__c + cd.valor_actual__c;
            this.certificacion.valor_actual__c = this.certificacion.valor_actual__c + cd.valor_actual__c;
        }
    }
 
 // Action Method called from page button
 public pagereference saveChanges() { 

        this.certificacion.valor_actual__c = 0;
        this.certificacion.acumulado_total__c = 0;
        this.certificacion.acumulado_anterior__c = 0;
     for (certificacion_detalle__c cd : this.certificacion_detalles) {
                       
            this.certificacion.Acumulado_anterior__c = this.certificacion.Acumulado_anterior__c + cd.Valor_acumulado_anterior__c;
            this.certificacion.Acumulado_total__c = this.certificacion.Acumulado_total__c+cd.Valor_acumulado_anterior__c + cd.valor_actual__c;
            this.certificacion.valor_actual__c = this.certificacion.valor_actual__c + cd.valor_actual__c;

     }





  update this.certificacion;
  if (this.actualizacion == true) {
      //List<certificacion_detalle__c> cert_d = [Select Id from certificacion_detalle__c where certificacion__c =:this.certificacion.id];
      //delete cert_d;
      //  for (certificacion_detalle__c c : this.certificacion_detalles) {
      //     System.debug('matu:'+c.valor_actual__c);
      //  }

            System.debug('matu1: '+this.certificacion_detalles);

      upsert this.certificacion_detalles;
  } else {
      insert this.certificacion_detalles;
      this.actualizacion = true;
  }
  return null;
 }
 
 // Action Method called from page link
 public pagereference newCertificacion() { 
  certificacion__c d = new certificacion__c();
  //d.orden_de_compra__c =this.orden_de_compra.id; 
  certificaciones.add( d );
  return null;
 }
 
 // public Getter to provide table headers 
 public string[] getheaders() { return new string [] 
  {'Name','Orden de compra' } ; }
 
 // public Getter to provide table headers2 
 public string[] getheaders2() { return new string [] 
  { 'Name','Porcentaje avance' } ; }
 
 // public Getter to list project deliverables
 public certificacion__c[] getCertificaciones() { 
  return this.certificaciones; 
 } 

 // public Getter to list project deliverables
 public certificacion_detalle__c[] getCertificacion_detalles() { 
  return this.certificacion_detalles; 
 } 


 
 // class variables
 //Orden_de_compra__c orden_de_compra;
 public certificacion__c certificacion {get; set;}
 certificacion__c[] certificaciones; 
 certificacion__c certificaciones_anterior; 
 certificacion__c[] certificaciones_anteriores; 
 certificacion_detalle__c[] certificacion_detalles; 
 certificacion_detalle__c[] certificacion_detalles_anteriores; 
 Orden_de_compra_entrega__c [] orden_de_compra_detalles;
 Boolean actualizacion;

}