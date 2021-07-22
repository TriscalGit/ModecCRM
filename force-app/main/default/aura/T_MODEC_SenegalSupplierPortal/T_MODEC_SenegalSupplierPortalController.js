({
    init: function (component, event, helper) {
        //component.set("v.listaEsq ", {});
        helper.MontarListaCampos(component);
        component.set('v.cadastroFornecedorDto', {});

        var paisSelecionado = component.get("v.paisSelecionado");
        console.log("paisSelecionado :" + paisSelecionado);

        var url = $A.get('$Resource.modecRodape'); //pegar imagem de background do footer
        component.set('v.backgroundImageURL', url);

        helper.GetCategorias(component);
        helper.GetAllCategoriesbyMap(component);
        //helper.GetMetadata(component);
        helper.GetSupplierContents(component);
        console.log("final do init");
    },

    gotoURL: function (component, event, helper) {
        /*var urlEvent = $A.get("e.force:navigateToURL");
        
        console.log('url:'+url.TW1_Portal_Login_URL__c);
        urlEvent.setParams({
          "url":url.TW1_Portal_Login_URL__c
        });
        urlEvent.fire();*/

        var url = component.get("v.CurrrentSupplierContent");
        window.open(url.TW1_Portal_Login_URL__c);
    },

    gotoStartingPage: function (component, event, helper) {

        //var url = component.get("v.CurrrentSupplierContent");
        location.reload();

    },

    SwitchToPage2: function (component, event, helper) {
        component.set("v.container1", false);
        component.set("v.container2", true);
        component.set("v.container3", false);
    },

    SwitchToPage3: function (component, event, helper) {
        //Js que faz validação de dados da página 2
        var allValid = component.find('inputDetect').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);

        
        var validateEmail1 = component.find("inputDetectEmail");
        var valorEmail1 = validateEmail1.get("v.value");
        var validateEmail2 = component.find("inputDetectEmail2");
        var valorEmail2 = validateEmail1.get("v.value");
        
        /*if(!valorEmail1.includes('@') || (!valorEmail1.includes('.com') && !valorEmail1.includes('.COM'))){
            alert('ERRO');
            validateEmail1.setCustomValidity("E-mail inválido GUFS"); // if there was a custom error before, reset it
            validateEmail1.reportValidity(); // Tells lightning:input to show the error right away without needing interaction
        } else {
            alert('CLEAR ERRO');
            validateEmail1.set("v.validity", null);
        }*/
        /*if(!valorEmail2.includes('@') || !valorEmail2.includes('.com') || !valorEmail2.includes('.COM')){
            validateEmail2.setCustomValidity("E-mail inválido"); // if there was a custom error before, reset it
            validateEmail2.reportValidity(); // Tells lightning:input to show the error right away without needing interaction
        }*/
        
        if (!allValid) {
            console.log('ERRO');
            return;
        }

        console.log('Campos ok');
        /*component.set("v.carregando", true);
        var cadastroFornecedorSelecionado = component.get("v.cadastroFornecedorDto");
        cadastroFornecedorSelecionado.CategoriasSelecionadas = component.get("v.listaCategoriaSelecionadas");
        component.set("v.cadastroFornecedorDto", cadastroFornecedorSelecionado);
        console.log(JSON.stringify(cadastroFornecedorSelecionado));
        helper.SalvarFornecedor(component);*/

        /*console.log("CNPJ Valido helper");
        component.set("v.container1", false);
        component.set("v.container2", false);
        component.set("v.container3", true);
        component.set("v.ErroCNPJ", false);

        var paisSelecionado = component.get("v.paisSelecionado");
        console.log("paisSelecionado :" + paisSelecionado);
        helper.GetCategorias(component);*/
        /*var allValidCNPJ = component.find('inputDetectCNPJ').get("v.value");
        console.log('Input cnpj:' + allValidCNPJ);


        // Aqui vamos começar nossa brincadeira
        // Preciso selecionar todas as categorias de um pais
        // Preciso buscar todas as categorias e informações
        if (allValidCNPJ !== undefined) {
            helper.ValidateCNPJ(component);
        }
        else {
            console.log("CNPJ Invalido na controller");
            var validateCmp = component.find("inputDetectCNPJ");
            validateCmp.setCustomValidity("CNPJ Inválido"); // if there was a custom error before, reset it

            validateCmp.reportValidity(); // Tells lightning:input to show the error right away without needing interaction
            component.set("v.ErroCNPJ", true);
        }*/

        component.set("v.container1", false);
        component.set("v.container2", false);
        component.set("v.container3", true);

        var paisSelecionado = component.get("v.paisSelecionado");
        console.log("paisSelecionado :" + paisSelecionado);
        helper.GetCategorias(component);
    },

    SwitchBackToPage2: function (component, event, helper) {
        component.set("v.container1", false);
        component.set("v.container2", true);
        component.set("v.container3", false);
    },

    Select: function (component, event, helper) {
        var posicao = event.currentTarget;
        $A.util.toggleClass(posicao, "highlightedLi");
    },
    handleChange: function (cmp, event) {
        // This will contain an array of the "value" attribute of the selected options
        var selectedOptionValue = event.getParam("value");
        alert(
            "Option selected with value: '" + selectedOptionValue.toString() + "'"
        );
    },
    SelecionarListaCategoriasDisponiveis: function (component, event, helper) {
        // This will contain an array of the "value" attribute of the selected options
        console.log('Entrou com sucesso na alteração');

        console.log('Set carregando');
        component.set("v.carregando", true);

        setTimeout(function () {
            var rectypeSelecionado = component.find("inputDetectPage3").get("v.value");
            console.log(rectypeSelecionado);
            component.set("v.categoriaSelecionada", rectypeSelecionado);

            var mapCategoriasEsquerdoCorrente = {};

            //Buscando map das categorias
            var mapCategorias = component.get("v.listaCompletaPorCategoria");

            var categorias = mapCategorias[rectypeSelecionado];
            console.log(categorias);

            for (var catID in categorias) {
                console.log('iterando por catID: ' + catID);
                console.log('iterando por catObjDto: ' + categorias[catID].label);
                mapCategoriasEsquerdoCorrente[catID] = categorias[catID];
            }
            console.log('MAP -> ');
            console.log(mapCategoriasEsquerdoCorrente);

            component.set("v.mapCategoriasEsquerdoCorrente", mapCategoriasEsquerdoCorrente);

            console.log('Chamando sinc');

            var a = component.get('c.SincListasCategorias');
            $A.enqueueAction(a);


        }, 0);
    },
    SincListasCategorias: function (component) {

        console.log('Entrou no sinc');

        var listaCategoriaSelecionadas = component.get("v.listaCategoriaSelecionadas");
        console.log('Categorias selecionadas');
        console.log(listaCategoriaSelecionadas);

        var ModelolistaDir = [];

        for (var catID in listaCategoriaSelecionadas) {
            console.log('iterando por catID: ' + catID);
            console.log('iterando por catObjDto: ' + listaCategoriaSelecionadas[catID].label);
            ModelolistaDir.push(listaCategoriaSelecionadas[catID]);
        }

        component.set("v.ModelolistaDir", ModelolistaDir);

        var mapCategoriasEsquerdoCorrente = component.get("v.mapCategoriasEsquerdoCorrente");
        var ModelolistaEsq = [];

        console.log('Categorias mapCategoriasEsquerdoCorrente');
        var searchStr = component.get("v.quickSearchText");

        console.log(mapCategoriasEsquerdoCorrente);

        for (var catID in mapCategoriasEsquerdoCorrente) {
            console.log('iterando por catID: ' + catID);
            console.log('iterando por catObjDto: ' + mapCategoriasEsquerdoCorrente[catID].label);
            console.log('iterando por catObjDto: ' + mapCategoriasEsquerdoCorrente[catID].labelFR);
            console.log('iterando por catObjDto: ' + mapCategoriasEsquerdoCorrente[catID].labelEN);
            if (listaCategoriaSelecionadas[catID] == null &&
                mapCategoriasEsquerdoCorrente[catID].label.toLowerCase().includes(searchStr.toLowerCase())) {
                ModelolistaEsq.push(mapCategoriasEsquerdoCorrente[catID]);
            }
        }

        component.set("v.ModelolistaEsq", ModelolistaEsq);

        component.set("v.carregando", false);
    },
    MoverParaDireita: function (component, event, helper) {
        component.set("v.carregando", true);
        console.log('Buscando categorias selecionadas3.');
        var selected = component.find("InputSelectMultiple").get("v.value");
        console.log('Selecionadas objs ' + selected);
        var listSelected = selected.split(";");
        console.log('Categorias selecionadas> ' + listSelected);

        var mapCategoriasEsquerdoCorrente = component.get("v.mapCategoriasEsquerdoCorrente");
        var listaCategoriaSelecionadas = component.get("v.listaCategoriaSelecionadas");

        for (var i = 0; i < listSelected.length; i++) {
            listaCategoriaSelecionadas[mapCategoriasEsquerdoCorrente[listSelected[i]].value] = mapCategoriasEsquerdoCorrente[listSelected[i]];
        }
        //Set na lista de selecionadas
        component.set("v.listaCategoriaSelecionadas", listaCategoriaSelecionadas);

        var a = component.get('c.SincListasCategorias');
        $A.enqueueAction(a);
    },

    MoverParaEsquerda: function (component, event, helper) {
        component.set("v.carregando", true);
        var selected = component.find("InputSelectMultiple2").get("v.value");
        console.log('Selecionadas objs ' + selected);
        var listSelected = selected.split(";");
        console.log('Categorias selecionadas> ' + listSelected);

        var listaCategoriaSelecionadas = component.get("v.listaCategoriaSelecionadas");

        for (var i = 0; i < listSelected.length; i++) {
            delete listaCategoriaSelecionadas[listSelected[i]];
        }
        //Set na lista de selecionadas
        component.set("v.listaCategoriaSelecionadas", listaCategoriaSelecionadas);

        var a = component.get('c.SincListasCategorias');
        $A.enqueueAction(a);
    },
    FiltroCategoriasDisponiveis: function (component, event, helper) {

        var mapCategoriasEsquerdoCorrente = component.get("v.mapCategoriasEsquerdoCorrente");
        var listaCategoriaSelecionadas = component.get("v.listaCategoriaSelecionadas");
        var searchStr = component.get("v.quickSearchText");
        var ModelolistaEsq = [];
        var CurrentLanguage = component.get("v.CurrentLanguage");

        for (var catID in mapCategoriasEsquerdoCorrente) {
            
            if (CurrentLanguage == 'English') {
                if (listaCategoriaSelecionadas[catID] == null &&
                    mapCategoriasEsquerdoCorrente[catID].labelEN.toLowerCase().includes(searchStr.toLowerCase())) {
                    ModelolistaEsq.push(mapCategoriasEsquerdoCorrente[catID]);
                }
            } else if(CurrentLanguage == 'French'){
                if (listaCategoriaSelecionadas[catID] == null &&
                    mapCategoriasEsquerdoCorrente[catID].labelFR.toLowerCase().includes(searchStr.toLowerCase())) {
                    ModelolistaEsq.push(mapCategoriasEsquerdoCorrente[catID]);
                }
            } else {
                if (listaCategoriaSelecionadas[catID] == null &&
                    mapCategoriasEsquerdoCorrente[catID].label.toLowerCase().includes(searchStr.toLowerCase())) {
                    ModelolistaEsq.push(mapCategoriasEsquerdoCorrente[catID]);
                }
            }
        }

        component.set("v.ModelolistaEsq", ModelolistaEsq);
    },
    ConcluirCadastroFornecedor: function (component, event, helper) {
        //verificação de categorias selecionadas
        var catSelecionadas = component.get('v.ModelolistaDir');
        console.log('listagem de cat selecionadas: ', catSelecionadas);
        /*if (catSelecionadas == 'undefined' || catSelecionadas == '' || catSelecionadas == null) {
            component.set("v.containerCatCheck", true);
            return;
        }
        if (catSelecionadas != 'undefined' || catSelecionadas != '' || catSelecionadas != null) {
            component.set("v.containerCatCheck", false);
        }*/
        //final do código de verificação de categorias selecionadas

        //verificação de validação do checkbox
        var allValid = component.find('inputDetect').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);

        if (!allValid) {
            return;
        }
        //final do código de validação do checkbox

        component.set("v.carregando", true);
        var cadastroFornecedorSelecionado = component.get("v.cadastroFornecedorDto");
        cadastroFornecedorSelecionado.CategoriasSelecionadas = component.get("v.listaCategoriaSelecionadas");
        component.set("v.cadastroFornecedorDto", cadastroFornecedorSelecionado);
        console.log(JSON.stringify(cadastroFornecedorSelecionado));
        helper.SalvarFornecedor(component);
    },

    ChangePortalLanguage: function (component, event, helper) {

        var languageButton = event.currentTarget.value;


        var languageAux;
        console.log('languageButton9 :' + languageButton);
        if (languageButton === 'FR') {
            languageAux = 'French';
        }
        if (languageButton === 'EN') {
            languageAux = 'English';
        }
        //buscar valor salvo na variavel CurrentLanguage
        var language = component.get("v.CurrentLanguage");
        console.log('Current Language :' + language);
        //Validar qual linguagem foi selecionada pelo usuario.
        if (languageAux !== language) {
            console.log('Change language');
            var MapSupplierContent = component.get("v.MapSupplierContent");
            component.set("v.CurrentLanguage", languageAux);
            component.set("v.CurrrentSupplierContent", MapSupplierContent[languageAux]);
            
            
            if (languageAux == 'French') {
                component.set("v.messageWhenPatternMismatchEmail", "Veuillez vérifier l'e-mail tapé.");
                component.set("v.messageWhenValueMissing", "Veuillez Saisir.");
                component.set("v.IsFrench", true);
            } else {
                component.set("v.messageWhenPatternMismatchEmail", "Invalid, please enter a valid email.");
                component.set("v.messageWhenValueMissing", "Required field.");
                component.set("v.IsFrench", false);
            }
            var mapPicklistValues = component.get('v.mapPicklistValues');
            component.set('v.currentMapPicklistValues', mapPicklistValues[languageAux]);
            var MapaCategorias = component.get('v.MapaCategorias');
            component.set('v.Categorias', MapaCategorias[languageAux]);

            var leftList = component.get("v.ModelolistaEsq");
            component.set("v.ModelolistaEsq", leftList);
            var rightList = component.get("v.ModelolistaDir");
            component.set("v.ModelolistaDir", rightList);
        }
        //caso seja diferente da atual, adicionar a nova na variavel
        //Antes buscar map com os contents e colocar o escolhido.
    },

    ChangeCountryOption: function (component, event, helper) {

        var paisSelecionado = component.get('v.paisSelecionado');
        //campo TW1_Pais__c
        console.log('paisSelecionado :' + paisSelecionado);

        if (paisSelecionado == 'Senegal') {
            console.log('Senegal tax ');
            component.set("v.TaxpayerField", false);
        }
        else {
            console.log('Outro tax :');
            component.set("v.TaxpayerField", true);
        }

        var currentDTO = component.get('v.cadastroFornecedorDto');
        currentDTO.CpfCnpj = '';
        currentDTO.TaxPayerNumber = '';
        component.set("v.cadastroFornecedorDto", currentDTO);
        //para modificar label do campo.
        var currentLayoutDTO = component.get('v.CurrrentSupplierContent');
        component.set("v.CurrrentSupplierContent", currentLayoutDTO);
    }
});