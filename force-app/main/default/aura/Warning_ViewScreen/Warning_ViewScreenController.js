({
    init : function(component, event, helper) {
        
        var actionGetWarningsSettings = component.get("c.getWarningsSettings");
        
        actionGetWarningsSettings.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var dados = response.getReturnValue();
                component.set("v.WarningSetting", dados);
                
                setTimeout(
                    $A.getCallback(
                        function() {
                            var width = component.find("measurement").getElement().getBoundingClientRect().width;
                            var CardSize = 12;
                            
                            if(width >= 1000){
                                component.set("v.sizeOfFilter", "6");
                                component.set("v.CardSizes", Math.floor(CardSize/dados.WarningsByRowLarge__c));
                                component.set("v.ScreenSize", "Large");
                                component.set("v.NumberOfWarningsToShow", dados.CardsByScreenLarge__c);
                            } else if(width >= 700){
                                component.set("v.sizeOfFilter", "6");
                                component.set("v.CardSizes", Math.floor(CardSize/dados.WarningsByRowMedium__c));
                                component.set("v.ScreenSize", "Medium");
                                component.set("v.NumberOfWarningsToShow", dados.CardsByScreenMedium__c);
                            } else {
                                component.set("v.sizeOfFilter", "12");
                                component.set("v.CardSizes", Math.floor(CardSize/dados.WarningsByRowSmall__c));
                                component.set("v.ScreenSize", "Small");
                                component.set("v.NumberOfWarningsToShow", dados.CardsByScreenSmall__c);
                            }
                        }
                    )
                );
                
                helper.SearchWarnings(component, event, helper);
                
            } else {
                helper.toastEvent("Error","error","Error to get records.");
            }
        });
        $A.enqueueAction(actionGetWarningsSettings);
    },
    
    OpenWarning : function(component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": event.currentTarget.dataset.value,
        });
        navEvt.fire();
    },
    
    LoadMore : function(component, event, helper) {
        var size = component.get("v.NumberOfWarningsToShow");
        var screenSize = component.get("v.ScreenSize");
        var allSize = component.get("v.TotalNumberOfWarnings");
        var warningSetting = component.get("v.WarningSetting");
        
        if(allSize > size){
            if(screenSize == "Large"){
                size += warningSetting.WarningsLoadMoreLarge__c;
            } else if(screenSize == "Medium"){
                size += warningSetting.WarningsLoadMoreMedium__c;
            } else {
                size += warningSetting.WarningsLoadMoreSmall__c;
            }
            component.set("v.NumberOfWarningsToShow", size);
        } else {
            helper.toastEvent("Warning","warning","No more warnings to load.");
        }
    },
    
    ordenateWarnings : function(component, event, helper) {
         helper.SearchWarnings(component, helper);
    }
})