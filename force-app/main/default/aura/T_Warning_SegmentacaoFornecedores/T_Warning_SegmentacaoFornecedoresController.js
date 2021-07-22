({
    init: function (component, event, helper) {        
        //-------------------------------------------------------------------------------------------------------------------
        //Define como será os valores de exibição dentro do dataTable
        component.set('v.columns', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'CNPJ', fieldName: 'TW1_CNPJ__c', type: 'text'},
            {label: 'Vendor Vetting', fieldName: 'TW1_Vendor_Vetting__c', type: 'text'},
            {label: 'Supplier Type', fieldName: 'TW1_Supplier_Type__c', type: 'text'}
        ]);
        
        //-------------------------------------------------------------------------------------------------------------------
        //Busca os valores de RecordType da Categoria para montar um select no filtro
        var actionGetCategoriesRT = component.get("c.getCategoryRecordTypes");
        actionGetCategoriesRT.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var values = response.getReturnValue();
                component.set('v.listValuesOfFilterInputTipoCategoria', values);
            } else {
                helper.toastEvent("Error","error","Occurred an error when trying to build the supplier segmentation component. Please try reloading the page or contact your system administrator.");
            }
        });
        $A.enqueueAction(actionGetCategoriesRT);
        
        //-------------------------------------------------------------------------------------------------------------------
        //Busca os valores de um campo Picklist para montar um select no filtro.
        helper.getPicklistValues(component, "TW1_Vendor_Vetting__c", "v.listValuesOfFilterInputVendorVetting");
        //-------------------------------------------------------------------------------------------------------------------
        //Realiza a primeira pesquisa buscando os todos os fornecedores
        helper.searchForSuppliers(component, helper);
        
        //-------------------------------------------------------------------------------------------------------------------
    },

    updateSelectedText: function (component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        component.set('v.selectedRowsCount', selectedRows.length);
        component.set('v.selectedRows', selectedRows);
    },
    
    searchAction: function (component, event, helper) {
        helper.searchForSuppliers(component, helper);
        component.find('DataTableResults').set('v.selectedRows',[]);
    },
    
    keyCheck: function (component, event, helper) {
        if (event.which == 13){
            helper.searchForSuppliers(component, helper);
            component.find('DataTableResults').set('v.selectedRows',[]);
        }
    },
    
    clearFilterFields: function (component, event, helper) {
        component.set('v.filterInputName', '');
        component.set('v.filterInputCategory', '');
        component.set('v.filterInputSubCategory', '');
        component.set('v.filterInputVendorVetting', '');
        component.set('v.filterInputTipoCategoria', '');
        helper.searchForSuppliers(component, helper);
        component.find('DataTableResults').set('v.selectedRows',[]);
    },
    
    handleSort: function(component, event, helper) {
        var sortedBy = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        var data = component.get('v.data');

        var cloneData = this.data.slice(0);
        cloneData.sort((this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1)));
        
        component.set('v.data', cloneData);
        component.set('v.sortDirection', sortDirection);
        component.set('v.sortedBy', sortedBy);
    },
    
    addParticipantes: function(component, event, helper) {
        var selectedRows = component.get('v.selectedRows');
        var recordId = component.get('v.recordId');
        
        var actionAddParticipantes = component.get("c.addParticipantesApex");
        
        actionAddParticipantes.setParams({
            participantes: selectedRows,
            recordId: recordId
        });
        
        actionAddParticipantes.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                helper.toastEvent("Success","success","Parabens! Registros salvos com exito");
                $A.get('e.force:refreshView').fire();
                helper.searchForSuppliers(component, helper);
                component.find('DataTableResults').set('v.selectedRows',[]);
            } else {
                helper.toastEvent("Error","error","Error on save records.");
            }
        });
        $A.enqueueAction(actionAddParticipantes);
    },
    
    deleteAction: function(component, event, helper) {
        var selectedRows = component.get('v.selectedRows');
        var actionRemoveParticipantes = component.get("c.removeParticipantesApex");
        
        actionRemoveParticipantes.setParams({
            jsonStr: selectedRows
        });
        
        actionRemoveParticipantes.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                helper.toastEvent("Success","success","Parabens! Registros removidos com exito");
                $A.get('e.force:refreshView').fire();
                helper.searchForSuppliers(component, helper);
                component.find('DataTableResults').set('v.selectedRows',[]);
            } else {
                helper.toastEvent("Error","error","Error on delete records.");
            }
        });
        $A.enqueueAction(actionRemoveParticipantes);
    }
})