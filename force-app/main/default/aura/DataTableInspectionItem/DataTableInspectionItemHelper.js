({
	acaoSelecionarTudoOuNada : function(component, valor) {
		var dados = component.get("v.dados");
        
        for(var i in dados){
            dados[i].Temp__c = valor;
        }
        component.set("v.dados", dados);
        component.set("v.retornoDataTable",dados);
	}
})