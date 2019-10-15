//hacer prueba
trigger TriggerUnidadVenta on Unidad__c (after insert, after update, before delete) {
    if (Trigger.isInsert ) {
        for(Unidad__c u : Trigger.New) {
            if (u.estado__c == 'Vendida'){
                // copiar el objetivo de venta en un array para despues chequear su tamaño
                objetivo_de_venta__c[] odvs = [SELECT id,name FROM objetivo_de_venta__c 
                                            where comercializadora__c =: u.comercializadora__c 
                                            and proyecto__c =: u.obra__c ];
                
                // si el objetivo no existe, se tiene que crear uno 
                if (odvs.size() > 0){
                    objetivo_de_venta__c odv = [SELECT id,name FROM objetivo_de_venta__c 
                                                where comercializadora__c =: u.comercializadora__c 
                                                and proyecto__c =: u.obra__c  LIMIT 1];
                    
                    objetivo_del_mes__c[] odms = [SELECT id,name, Monto_actual_vendido__c 
                                                        FROM objetivo_del_mes__c 
                                                        where objetivo_de_venta__c =: odv.id 
                                                        and calendar_month(mes__c) =: u.fecha_boleto__c.month() 
                                                        and calendar_year(mes__c) =: u.fecha_boleto__c.year()];
                
                    if (odms.size() >0){ //Attempt to de-reference a null object.
                        //selecciona las diferentes variables necesarias para crear el objetivo del mes.
                        objetivo_del_mes__c odm = [SELECT id,name, Monto_actual_vendido__c 
                                                        FROM objetivo_del_mes__c 
                                                        where objetivo_de_venta__c =: odv.id 
                                                        and calendar_month(mes__c) =: u.fecha_boleto__c.month() 
                                                        and calendar_year(mes__c) =: u.fecha_boleto__c.year() LIMIT 1];
                        //con esto soluciono el error de de-reference.
                        if (odm.id !=null){
                                //soluciona el molestisimo error.
                                if(odm.monto_actual_vendido__c >0 ){ 
                                    //attempt to de-reference a null object.
                                    odm.monto_actual_vendido__c += u.valor_real_operacion__c; //se acumula el monto actual.
                                    update odm;
                                }
                        }   
                    //si el array odms es nulo se debe crear un nuevo objetivo del mes        
                    }else{
                            Objetivo_del_mes__c odm2 = new Objetivo_del_mes__c (
                                                        objetivo_de_venta__c = odv.id,
                                                        Meta_en_dolares__c = 0,
                                                        mes__c= u.fecha_boleto__c); 
                            insert odm2;   
                    }
                //si el odvs es nulo
                }else {
                        //se inserta nuevo objeto de venta y objeto de mes
                        objetivo_de_venta__c odv2 = new  objetivo_de_venta__c (
                                                    comercializadora__c = u.comercializadora__c,
                                                    proyecto__c = u.obra__c );
                                    insert odv2;
                    
                        Objetivo_del_mes__c odm2 = new Objetivo_del_mes__c (
                                                objetivo_de_venta__c = odv2.id,
                                                Meta_en_dolares__c = 0,
                                                mes__c= u.fecha_boleto__c); 
                                    insert odm2;   
                }
            }
        }     
    }

    // si el trigger es update
    if (trigger.isUpdate ) {
        //nuevo trigger por cada unidad iterada
        for(Unidad__c u : Trigger.New) {
            //si pasa de cualquier estado a estado vendida           
            if(trigger.oldMap.get(u.Id).estado__c != u.estado__c && u.estado__c == 'Vendida'){ 
                // copiar el objetivo de venta en un array para despues chequear su tamaño
                objetivo_de_venta__c[] odvs = [SELECT id,name FROM objetivo_de_venta__c 
                                              where comercializadora__c =: u.comercializadora__c 
                                              and proyecto__c =: u.obra__c ];
                // si el objetivo no existe, se tiene que crear uno 
                if (odvs.size() > 0){
                    objetivo_de_venta__c odv = [SELECT id,name FROM objetivo_de_venta__c 
                                                where comercializadora__c =: u.comercializadora__c 
                                                and proyecto__c =: u.obra__c  LIMIT 1];
                    
                    objetivo_del_mes__c[] odms = [SELECT id,name, Monto_actual_vendido__c 
                                                        FROM objetivo_del_mes__c 
                                                        where objetivo_de_venta__c =: odv.id 
                                                        and calendar_month(mes__c) =: u.fecha_boleto__c.month() 
                                                        and calendar_year(mes__c) =: u.fecha_boleto__c.year()];
                    if (odms.size() >0){ //Attempt to de-reference a null object.
                        //selecciona las diferentes variables necesarias para crear el objetivo del mes.
                        objetivo_del_mes__c odm = [SELECT id,name, Monto_actual_vendido__c 
                                                            FROM objetivo_del_mes__c 
                                                            where objetivo_de_venta__c =: odv.id 
                                                            and calendar_month(mes__c) =: u.fecha_boleto__c.month() 
                                                            and calendar_year(mes__c) =: u.fecha_boleto__c.year() LIMIT 1];
                        //con esto soluciono el error de de-reference.
                        if (odm.id !=null){
                            //soluciona el molestisimo error.
                            if(odm.monto_actual_vendido__c >0 ){ 
                                //attempt to de-reference a null object.
                                odm.monto_actual_vendido__c += u.valor_real_operacion__c; //se acumula el monto actual.
                                update odm;
                            }
                        }
                 //   si el array odms es nulo se debe crear un nuevo objetivo del mes        
                    }else{
                        Objetivo_del_mes__c odm2 = new Objetivo_del_mes__c (
                                                        objetivo_de_venta__c = odv.id,
                                                        Meta_en_dolares__c = 0,
                                                        mes__c= u.fecha_boleto__c); 
                      insert odm2;   
                   }    
               // si el odvs es nulo
                }else {
                    //se inserta nuevo objeto de venta y objeto de mes
                   objetivo_de_venta__c odv2 = new  objetivo_de_venta__c (
                                                    comercializadora__c = u.comercializadora__c,
                                                     proyecto__c = u.obra__c );
                    insert odv2;
                    
                    Objetivo_del_mes__c odm2 = new Objetivo_del_mes__c (
                                                objetivo_de_venta__c = odv2.id,
                                                Meta_en_dolares__c = 0,
                                                mes__c= u.fecha_boleto__c); 
                    insert odm2;   
                
                    }
                }
            
            if(trigger.oldMap.get(u.Id).estado__c == 'Vendida' && u.estado__c == 'Disponible'){ 
                // copiar el objetivo de venta en un array para despues chequear su tamaño
                objetivo_de_venta__c[] odvs2 = [SELECT id,name FROM objetivo_de_venta__c 
                                              where comercializadora__c =: u.comercializadora__c 
                                              and proyecto__c =: u.obra__c ];
                // si el objetivo no existe, se tiene que crear uno 
                if (odvs2.size() > 0){
                    objetivo_de_venta__c odv = [SELECT id,name FROM objetivo_de_venta__c 
                                                where comercializadora__c =: u.comercializadora__c 
                                                and proyecto__c =: u.obra__c  LIMIT 1];
                    
                    objetivo_del_mes__c[] odms = [SELECT id,name, Monto_actual_vendido__c 
                                                        FROM objetivo_del_mes__c 
                                                        where objetivo_de_venta__c =: odv.id 
                                                        and calendar_month(mes__c) =: u.fecha_boleto__c.month() 
                                                        and calendar_year(mes__c) =: u.fecha_boleto__c.year()];
                    if (odms.size() >0){ //Attempt to de-reference a null object.
                        //selecciona las diferentes variables necesarias para crear el objetivo del mes.
                        objetivo_del_mes__c odm = [SELECT id,name, Monto_actual_vendido__c 
                                                            FROM objetivo_del_mes__c 
                                                            where objetivo_de_venta__c =: odv.id 
                                                            and calendar_month(mes__c) =: u.fecha_boleto__c.month() 
                                                            and calendar_year(mes__c) =: u.fecha_boleto__c.year() LIMIT 1];
                        //con esto soluciono el error de de-reference.
                        if (odm.id !=null){
                            //soluciona el molestisimo error.
                            if(odm.monto_actual_vendido__c >0 ){ 
                                //attempt to de-reference a null object.
                                odm.monto_actual_vendido__c -= u.valor_real_operacion__c; //se resta el monto actual.
                                update odm;
                            }
                        }   
                        //si el array odms es nulo se debe crear un nuevo objetivo del mes        
              //      }else{
              //          Objetivo_del_mes__c odm2 = new Objetivo_del_mes__c (
              //                                          objetivo_de_venta__c = odv.id,
             //                                           Meta_en_dolares__c = 0,
             //                                           mes__c= u.fecha_boleto__c); 
              //          insert odm2;   
            //        }    
                //si el odvs es nulo
           //     }else {
                    //se inserta nuevo objeto de venta y objeto de mes
          //          objetivo_de_venta__c odv2 = new  objetivo_de_venta__c (
          //                                          comercializadora__c = u.comercializadora__c,
          //                                           proyecto__c = u.obra__c );
         //           insert odv2;
         //           Objetivo_del_mes__c odm2 = new Objetivo_del_mes__c (
        //                                        objetivo_de_venta__c = odv2.id,
       //                                         Meta_en_dolares__c = 0,
         //                                       mes__c= u.fecha_boleto__c); 
       //             insert odm2;   
                
              }
            }        
        }
    }
}
    if (trigger.isDelete) {
        for(Unidad__c u : Trigger.Old) {
            if(trigger.oldMap.get(u.Id).estado__c == 'Vendida' ){ 
                objetivo_de_venta__c odv = [SELECT id,name FROM objetivo_de_venta__c 
                                            where comercializadora__c =: u.comercializadora__c 
                                            and proyecto__c =: u.obra__c  LIMIT 1];
                objetivo_del_mes__c odm = [SELECT id,name, Monto_actual_vendido__c 
                                            FROM objetivo_del_mes__c 
                                            where objetivo_de_venta__c =: odv.id 
                                            and calendar_month(mes__c) =: u.fecha_boleto__c.month() 
                                            and calendar_year(mes__c) =: u.fecha_boleto__c.year() LIMIT 1];
                odm.monto_actual_vendido__c -= u.valor_real_operacion__c;
                update odm;
            }                
        }
    }
}
