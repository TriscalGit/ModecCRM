public class TriggerHandlerContractDailyRateHist extends TriggerHandler {
    public override void beforeInsert(){
    }

    public override void beforeUpdate(){
    }
   
    public override void afterInsert(){
        ContractDailyRateHistBO.getInstance().atualizarTaxasBOM(Trigger.new);
    }

    public override void afterUpdate(){
        ContractDailyRateHistBO.getInstance().atualizarTaxasBOM(Trigger.new);
    }
}