public class LibreDeudaListController {

    private String sortOrder = 'Vencimiento__c';
    public String libre{get;set;}   
    public Unidad__c uni{get;set;}   
 
    public PageReference doSomething()    
    {

		uni = [SELECT Id, Name, Total_a_pagar_calculado__c, Saldo_a_pagar__c, Importes_pagados__c, Precio_de_venta__c	 FROM Unidad__c WHERE id =: ApexPages.CurrentPage().getparameters().get('id')  LIMIT 1];

        List<Cobro_unidad__c> results = Database.query(
            'SELECT Id, Name, Fecha_cobro__c, Importe__c, Importe_cobrado__c, Moneda__c, Vencimiento__c ' +
            'FROM Cobro_unidad__c ' +
            'WHERE Saldo__c != 0' +
            ' AND Unidad__c = \''+ApexPages.CurrentPage().getparameters().get('id') + '\'' +
            'ORDER BY ' + sortOrder + ' ASC ' +
            'LIMIT 100'
        );
        this.libre = 'SI';
        for (Cobro_unidad__c cu : results) {
            this.libre = 'NO';
        }

        return null;
    }
    
    public List<Cobro_unidad__c> getCuotas() {
        
        List<Cobro_unidad__c> results = Database.query(
            'SELECT Id, Name, Fecha_cobro__c, Importe__c, Importe_cobrado__c, Moneda__c, Vencimiento__c ' +
            'FROM Cobro_unidad__c ' +
            'WHERE Saldo__c != 0' +
            ' AND Unidad__c = \''+ApexPages.CurrentPage().getparameters().get('id') + '\'' +
            'ORDER BY ' + sortOrder + ' ASC ' +
            'LIMIT 100'
        );
        List<Cobro_unidad__c> res = New List<Cobro_unidad__c>();
        this.libre = 'SI';
        for (Cobro_unidad__c cu : results) {
            res.add(cu);
            this.libre = 'NO';
        }
        return res;
    }
    
    public PageReference doSomethingMore()    
    {

        PageReference pr = new PageReference('/apex/LibreDeudaPdf');
        pr.setRedirect(true);
        return pr;
    
    }
    
}