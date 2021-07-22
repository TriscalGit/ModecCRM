({
    toastEvent : function(title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,  // Erro --> "error" | Sucesso --> "success" | Informação --> "info"
            "message": message
        });
        toastEvent.fire();
    },
    
    searchForSuppliers : function(component, helper) {
        component.set('v.isLoading',true);
        component.set("v.data", null);
        var action = component.get("c.searchForSuppliers");
        var SearchDTO = {
            SupplierName: component.get('v.filterInputName'),
            SearchType: component.get('v.filterSelectTypeOfFilter'),
            Category: component.get('v.filterInputCategory'),
            SubCategory: component.get('v.filterInputSubCategory'),
            CategoryRT: component.get('v.filterInputTipoCategoria'),
            VendorVetting: component.get('v.filterInputVendorVetting'),
            recordId: component.get('v.recordId')            
        }
       
        action.setParams({
            pesquisa: SearchDTO
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var values = response.getReturnValue();
                if(values != null && values.length > 0) {
                    if(SearchDTO.SearchType == "Participantes"){
                        component.set('v.columns', [
                            {label: 'Código do participante', fieldName: 'Name', type: 'text'},
                            {label: 'Supplier Name', fieldName: 'SupplierName', type: 'text'},
                            {label: 'CNPJ', fieldName: 'SupplierCNPJ', type: 'text'},
                            {label: 'Supplier Type', fieldName: 'SupplierType', type: 'text'}
                        ]);
                        
                        for(var x=0;x<values.length;x++){
                            values[x].SupplierName = values[x].TCF_Supplier__r.Name;
                            values[x].SupplierCNPJ = values[x].TCF_Supplier__r.TW1_CNPJ__c;
                            values[x].SupplierType = values[x].TCF_Supplier__r.TW1_Supplier_Type__c;
                        }
                        
                    } else {
                        component.set('v.columns', [
                            {label: 'Name', fieldName: 'Name', type: 'text'},
                            {label: 'CNPJ', fieldName: 'TW1_CNPJ__c', type: 'text'},
                            {label: 'Vendor Vetting', fieldName: 'TW1_Vendor_Vetting__c', type: 'text'},
                            {label: 'Supplier Type', fieldName: 'TW1_Supplier_Type__c', type: 'text'}
                        ]);
                    }
                    component.set("v.data", values);
                    component.set("v.hasResults", true);
                } else {
                    component.set("v.hasResults", false);
                }
            } else {
                component.set("v.hasResults", false);
                helper.toastEvent("Error","error","Sorry, it wasn't possible to get the records that you search for.");
            }
            component.set('v.selectedRows', null);
            component.set('v.selectedRowsCount', 0);
            component.set('v.isLoading',false);
        });
        $A.enqueueAction(action);
    },
    
    getPicklistValues: function (component, campo, variavel){        
        var actionGetVendorVetting = component.get("c.getPicklistVendorVetting");
        
        actionGetVendorVetting.setParams({
            apiFieldName: campo
        });
        
        actionGetVendorVetting.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {   
                var unid = response.getReturnValue();
                
                component.set(variavel, JSON.parse(unid));
            } else {
                helper.toastEvent("Error","error","Occurred an error when trying to build the supplier segmentation component. Please try reloading the page or contact your system administrator.");
            }
        });
        $A.enqueueAction(actionGetVendorVetting);
    }
})