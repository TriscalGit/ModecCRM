public class TriggerHandlerDailyRates extends TriggerHandler {
    public override void beforeInsert(){
        DailyRatesBO.getInstance().formatPercentFields(trigger.new);
    }

    public override void beforeUpdate(){
        DailyRatesBO.getInstance().formatPercentFields(trigger.new);
    }
   
    public override void afterInsert(){
        DailyRatesBO.getInstance().FillNReport(trigger.new);
        DailyRatesBO.getInstance().fillLossesCompositionFields(trigger.new);
        DailyRatesBO.getInstance().formatTimeFields(Trigger.new);
    }

    public override void afterUpdate(){
        DailyRatesBO.getInstance().fillLossesCompositionFields(trigger.new);
    }
}