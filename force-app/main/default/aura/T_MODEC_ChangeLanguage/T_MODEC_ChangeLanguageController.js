({
    init: function (component, event, helper) {

        //helper.getcurrentUserLanguage(component);
    },
    changeLanguageGer: function (component, event, helper) {
        helper.changeLanguageEng(component, 'pt_BR');
        component.set("v.labelPortuguese", "Português");
        component.set("v.labelEnglish", "Inglês");
    },
    changeLanguageEng: function (component, event, helper) {
        helper.changeLanguageEng(component, 'en_US');
        component.set("v.labelPortuguese", "Portuguese");
        component.set("v.labelEnglish", "English");
    },
})