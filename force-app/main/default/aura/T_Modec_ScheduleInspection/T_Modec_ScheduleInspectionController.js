({
        doInit: function (component, event, helper) {
                var rid = component.get("v.recordId");
                component.set('v.InspectionDatesDto', {});
                component.set('v.inspectionType', 'normal');
                console.log('tipo de inspeção: ' + component.get("v.inspectionType"));
                console.log('Record Id: ' + rid);
        },

        emergencyDateDiv: function (component, event, helper) {
                component.set('v.InspectionDatesDto', {});
                component.set('v.inspectionType', 'emergencial');
                console.log("trocando para div emergency date.");
                component.set('v.successMsg', false);
                component.set('v.errorMsg', false);
                console.log('tipo de inspeção: ' + component.get("v.inspectionType"));
                component.set('v.container1', false);
                component.set('v.container2', true);

        },

        inspectionDateDiv: function (component, event, helper) {
                component.set('v.InspectionDatesDto', {});
                component.set('v.inspectionType', 'normal');
                console.log("trocando para div inspection dates.");
                component.set('v.successMsg', false);
                component.set('v.errorMsg', false);
                console.log('tipo de inspeção: ' + component.get("v.inspectionType"));
                component.set('v.container1', true);
                component.set('v.container2', false);

        },

        saveScheduledInspection: function (component, event, helper) {

                component.set('v.saveButton', true);
                var allValid = component.find('inputDetect').reduce(function (validSoFar, inputCmp) {
                        inputCmp.showHelpMessageIfInvalid();
                        return validSoFar && inputCmp.get('v.validity').valid;
                }, true);

                if (!allValid) {
                        component.set('v.saveButton', false);
                        return;
                }

                helper.saveScheduledInspection(component);

        },
})