@isTest
private class TestUnidadVenta {
    static testMethod void TestUnidadVenta(){

        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Comercializadora').getRecordTypeId();
        
            Account a = new Account(name = 'test123', recordtypeid = RecordTypeIdAccount, CBU__c = '1111111111111111111111' );
            insert a;

            Moneda__c m = new Moneda__c(name='test');
            insert m;

            Obra__c o = new Obra__c(name='test');
            insert o;

            Objetivo_De_venta__c odv = new Objetivo_De_venta__c(name = 'test',Comercializadora__c = a.id,  Proyecto__c = o.id);
            insert odv;
            
            Objetivo_del_mes__c odm = new Objetivo_del_mes__c(name = 'test', Meta_en_dolares__c = 30000 ,Monto_actual_vendido__c = 0, Objetivo_De_Venta__c = odv.id , mes__c= date.today());
            insert odm;


            Unidad__c u = new Unidad__c(name='1',Moneda_comision__c = m.id,  obra__c = o.id, Comercializadora__c = a.id , Estado__c = 'Vendida' , 	Fecha_boleto__c = date.today() , Valor_real_operacion__c = 20000);
            insert u;
        
            Unidad__c u2 = new Unidad__c(name='2',Moneda_comision__c = m.id,  obra__c = o.id, Comercializadora__c = a.id , Estado__c = 'Disponible' , 	Fecha_boleto__c = date.today() , Valor_real_operacion__c = 20000);
            insert u2;

            Unidad__c u4 = new Unidad__c(name='2',Moneda_comision__c = m.id,  obra__c = o.id, Comercializadora__c = a.id , Estado__c = 'Disponible' , 	Fecha_boleto__c = date.today().addDays(45), Valor_real_operacion__c = 20000);
            insert u4;
            //System.debug('MATU'+ date.today().addDays(45));

              u4.Estado__c = 'Vendida';
            update u4;

            odm.Monto_actual_vendido__c = 1;
            update odm;

            Unidad__c u3 = new Unidad__c(name='2',Moneda_comision__c = m.id,  obra__c = o.id, Comercializadora__c = a.id , Estado__c = 'Vendida' , 	Fecha_boleto__c = date.today() , Valor_real_operacion__c = 20000);
            insert u3;

            odm.Monto_actual_vendido__c = 0;
            update odm;

            u.Estado__c = 'Disponible';
            update u;
        //monto actual en 0 
        
              u2.Estado__c = 'Vendida';
            update u2;
            //monto actual en 0
            u.Estado__c = 'Vendida';
           odm.Monto_actual_vendido__c = 1;
            update u;
            update odm;
           //monto actual en 1
             u.Estado__c = 'Disponible';
           odm.Monto_actual_vendido__c = 1;
            update u;
            update odm;
           //monto actual en 1
           
            delete u;
            
    }
}