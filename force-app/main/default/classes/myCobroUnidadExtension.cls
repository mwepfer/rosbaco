public class myCobroUnidadExtension {

    private final Cobro_unidad__c cobro;   
    public Unidad__c Unidad {get;set;}   
    public Account propietario {get;set;}  
    public  Num2Text nwcObj ;
    public String numinWords {get; set;}

    public myCobroUnidadExtension(ApexPages.StandardController stdController) {

        this.cobro = (Cobro_unidad__c)stdController.getRecord();
        this.unidad = [SELECT Id, Name, propietario_principal__c    FROM unidad__c WHERE id =: this.cobro.unidad__c  LIMIT 1];
        this.propietario = [SELECT Id, Name   FROM account WHERE id =: this.unidad.propietario_principal__c  LIMIT 1];
        this.nwcObj = new Num2Text();
        this.numInWords = nwcObj.getNumberTOWordConvertion(this.cobro.importe_cobrado__c);            


    }

 
    public PageReference doSomething()    
    {


        return null;
    }
    
    
    public PageReference doSomethingMore()    
    {

        PageReference pr = new PageReference('/apex/ExpensasUnidadPdf');
        pr.setRedirect(true);
        return pr;
    
    }
    
}