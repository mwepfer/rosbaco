public with sharing class CrearOrdenDeCompra {
    private Presupuesto_base__c p;   

    public CrearOrdenDeCompra(ApexPages.StandardSetController controller)
    {
    }

    public CrearOrdenDeCompra(ApexPages.StandardController controller)
    {
    }

    public PageReference doSomething()    
    {
    
        ///lightning/r/Presupuesto_base__c/a0AQ000000FESPOMA5/view
        //PageReference pr = new PageReference('/lightning/r/Orden_de_compra__c/a0M1U000001fyOiUAI/view');


        this.p = [SELECT Id, Name, Obra__c, moneda__c, proveedor__c, responsable_carga__c, sociedad__c    FROM Presupuesto_base__c WHERE id =: ApexPages.CurrentPage().getparameters().get('id')  LIMIT 1];

        Orden_de_compra__c oc = new Orden_de_compra__c(name=p.name, presupuesto__c = p.id, obra__c = p.obra__c, proveedor__c = p.proveedor__c, moneda__c = p.moneda__c, responsable_carga__c = p.responsable_carga__c, sociedad__c = p.sociedad__c, fecha__c = date.today());
        insert oc;
        
        List<Presupuesto_detalle__c> results = Database.query(
            'SELECT Id, Name, concepto__c, rubro__c, descripcion__c,fecha_estimada_ejecucion__c, tasa_impuestos__c, cantidad__c, valor_unitario__c, unidad_de_medida__c ' +
            'FROM Presupuesto_detalle__c ' +
            'WHERE Presupuesto_base__c = \''+p.id + '\'' +
            'LIMIT 100'
        );
        for (Presupuesto_detalle__c pd : results) {
            Orden_de_compra_entrega__c ocd = new Orden_de_compra_entrega__c(orden_de_compra__c = oc.id, detalle__c = pd.descripcion__c, fecha_entrega_prevista__c = pd.fecha_estimada_ejecucion__c, fecha_estimada_ejecucion__c = pd.fecha_estimada_ejecucion__c,  concepto__c = pd.concepto__c, rubro__c = pd.rubro__c, cantidad__c = pd.cantidad__c, valor_unitario__c = pd.valor_unitario__c, tasa_impuestos__c = pd.tasa_impuestos__c, unidad_de_medida__c = pd.unidad_de_medida__c);
            insert ocd;
        }

        
        PageReference pr = new PageReference('/lightning/r/Orden_de_compra__c/'+oc.id+'/view');
        pr.setRedirect(true);
        return pr;
    }

}