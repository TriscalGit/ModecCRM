({
    CloneInspection: function (component, callback) {
        var action = component.get("c.CloneInspectionApex");
        var recId = component.get("v.recordId");
        console.log('Id request> ' + recId);
        action.setParams({ "requestId": recId });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {

                var resultado = response.getReturnValue();
                console.log('Retorno Criacao Clone Inspection ' + resultado);

                var result = JSON.parse(resultado);
                console.log('Retorno apos parse' + result.Status);

                //Criar if com o result.Status - Possiveis valores Sucesso ou Erro
                //Caso seja sucesso - apresentar mensagem que foi com sucesso e incluir um hyperlink na mensagem com o result.CloneUrl

                //Caso ocorra erro
				//Exibir mensagens que são retornado atraves da lista -> result.MessageList
				
				if (result.Status == 'Sucesso') {

					console.log('url da pagina clonada: ' + result.CloneUrl);
					component.set("v.cloneUrl", result.CloneUrl);
					component.set("v.successMsg", true);
                	component.set("v.IsSpinner", false);
				} else {
					component.set("v.errorMsg", true);
                	component.set("v.IsSpinner", false);
				}
            }
            else {
                console.log('Erro no controller APEX:' + response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

})