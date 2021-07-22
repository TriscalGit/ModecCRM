({
	saveScheduledInspection: function (component, callback) {
		console.log("chegou na helper");
		var request = component.get('v.InspectionDatesDto');
		var action = component.get('c.ScheduleInspection');

		var rid = component.get("v.recordId");
		request.RequestId = rid;
		console.log("request: ", request);
		action.setParams({
			"strRequest": JSON.stringify(request)
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			console.log("Retorno: " + state);
			if (component.isValid() && state === "SUCCESS") {

				var resultado = response.getReturnValue();
				console.log('Retorno Criacao BM DOC ' + resultado);

				var result = JSON.parse(resultado);
				console.log('Retorno apos parse' + result.Status);
				component.set('v.InspectionResponseDto', result);
				//Adicionar aqui if(result.Status == 'Sucesso) ... 
				if (result.Status == 'Sucesso') {
					component.set('v.successMsg', true);
					window.location.reload()
				} else {
					component.set('v.errorMsg', true);
					component.set('v.saveButton', false);
				}

			} else {
				console.log('Erro no controller APEX:' + response.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	}
})