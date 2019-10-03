public class myExpensaUnidadExtension {

    private final Expensa_unidad__c uni;   

    public myExpensaUnidadExtension(ApexPages.StandardController stdController) {
        if (!Test.isRunningTest()) stdController.addFields(new List<String>{'Id','Name', 'Expensa__c', 'Unidad__c'});

        this.uni = (Expensa_unidad__c)stdController.getRecord();
    }

 
    public PageReference doSomething()    
    {

        //this.uni = [SELECT Id, Name, Expensa__c, Monto_a_pagar__c, Fecha_pago__c, Saldo_a_pagar__c, Monto_pagado__c    FROM Expensa_unidad__c WHERE id =: ApexPages.CurrentPage().getparameters().get('id')  LIMIT 1];

        List<Expensa_gasto_general__c> results = Database.query(
            'SELECT Id, Name, Importe__c ' +
            'FROM Expensa_gasto_general__c ' +
            'WHERE Expensa__c = \''+uni.Expensa__c + '\'' +
            'LIMIT 100'
        );
        for (Expensa_gasto_general__c cu : results) {
        }

        return null;
    }
    
    public List<Expensa_gasto_general__c> getCuotas() {
        
        List<Expensa_gasto_general__c> results = Database.query(
            'SELECT Id, Name, Importe__c ' +
            'FROM Expensa_gasto_general__c ' +
            'WHERE Expensa__c = \''+uni.Expensa__c + '\'' +
            'LIMIT 100'
        );
        List<Expensa_gasto_general__c> res = New List<Expensa_gasto_general__c>();
        for (Expensa_gasto_general__c cu : results) {
            res.add(cu);
        }
        return res;
    }
    
    public PageReference doSomethingMore()    
    {

        PageReference pr = new PageReference('/apex/ExpensasUnidadPdf');
        pr.setRedirect(true);
        return pr;
    
    }
    
}