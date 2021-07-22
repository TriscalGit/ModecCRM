({
    changeLanguageEng: function(component,idioma, helper) {
        
        var action = component.get("c.changeLang");
        action.setParams({
            lang: idioma
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var changedOK = response.getReturnValue();
                if (changedOK == 'OK')
                    location.reload();
                else {
                    alert('error, changed not OK: ' + changedOK);
                }
            }
            else {
                alert('error in state: ' + state);
            }
        });
        $A.enqueueAction(action);
    },

    getcurrentUserLanguage: function(component,idioma, helper) {
        
        var action = component.get("c.GetUserLanguage");
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                
                var userLang = response.getReturnValue();
                console.log('Language returned>'+userLang);
                if (userLang === 'pt_BR'){
                    console.log('Language PT_BR');
                    component.set("v.labelPortuguese", "Português");
                    component.set("v.labelEnglish", "Inglês");
                }
                if (userLang === 'en_US'){
                    console.log('Language EN US');
                    component.set("v.labelPortuguese", "Portuguese");
                    component.set("v.labelEnglish", "English");
                }
                    l
            }
            else {
                alert('error in state: ' + state);
            }
        });
        $A.enqueueAction(action);
    }
})