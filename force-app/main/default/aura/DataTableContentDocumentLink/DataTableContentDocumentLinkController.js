({
    selectCheckbox : function(component, event, helper) {
		var param = event.currentTarget;
        var dados = component.get("v.dados");
        var result = [];
        var count = 0;
        
        for(var i in dados){
            if(dados[i].Id == param.dataset.value){
                if(dados[i].Temp__c){
                    dados[i].Temp__c = false;
                    count++;
                } else {
                    dados[i].Temp__c = true;
                    result.push(dados[i]);
                }
            } else {
                if(dados[i].Temp__c){
                    result.push(dados[i]);
                } else {
                    count++;
                }
            }
        }
        if(count > 0){
            component.set("v.isButtonSelectAll",true);
        } else {
            component.set("v.isButtonSelectAll",false);
        }
        component.set("v.dados", dados);
        component.set("v.retornoDataTable",result);
	},
    
    init: function (cmp, event, helper) {
        var dados = JSON.parse(JSON.stringify(cmp.get("v.dados")));
        cmp.set("v.data",dados);
        cmp.set('v.columns', [
            {label: 'Title', fieldName: 'Title', type: 'text'},
            {label: 'Extension', fieldName: 'FileExtension', type: 'text', cellAttributes: { alignment: 'center' }},
            {label: 'Size', fieldName: 'ContentSize', type: 'number', cellAttributes: { alignment: 'center' }}
        ]);
        
        if($A.get("$Browser.formFactor") != 'DESKTOP'){
            for(var i in dados){
                dados[i].Temp__c = false;
            }
        }
    },

    updateSelectedText: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        cmp.set("v.retornoDataTable",selectedRows);
        cmp.set('v.selectedRowsCount', selectedRows.length);
    },

    selectAll: function (component, event, helper) {
        helper.acaoSelecionarTudoOuNada(component, true);
        component.set("v.isButtonSelectAll",false);
    },

    notSelectAll: function (component, event, helper) {
        helper.acaoSelecionarTudoOuNada(component, false);
        component.set("v.isButtonSelectAll",true);
    }
})