({

    GetCategoriasDisponiveis: function (component, callback) {
        //resgata o cadastro de fornecedor a ser clonado
        console.log("Chamando serviço GetCategorias");
        var pais = component.get("v.paisSelecionado");
        var action = component.get("c.getCategorias");
        action.setParams({
            paisfornecedor: pais
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("Retorno: " + state);
            if (component.isValid() && state === "SUCCESS") {
                var categorias = response.getReturnValue();
                console.log(categorias);

                var options = [];
                categorias.forEach(function (TW1_Category__c) {
                    //seta value e label de values em categories
                    options.push({
                        label: TW1_Category__c.TW1_Category__c,
                        value: TW1_Category__c.Id
                    });
                });
                console.log(options);

                component.set("v.Categorias", options);
            } else {
                alert("Erro: GetCategoriasDisponiveis " + records);
            }
        });
        $A.enqueueAction(action);
    },
    GetCategorias: function (component, callback) {
        //resgata o cadastro de fornecedor a ser clonado
        console.log("Chamando serviço GetCategorias");
        var action = component.get("c.getCategorias");
        var language = component.get("v.CurrentLanguage");

        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("Retorno GetCategorias: " + state);
            console.log("Retorno Return value GetCategorias: " + response.getReturnValue());
            // console.log("Retorno get Error GetCategorias: " + response.getError()[0].message);
            if (component.isValid() && state === "SUCCESS") {
                var categorias = JSON.parse(response.getReturnValue());
                component.set("v.Categorias", categorias[language]);
                component.set("v.MapaCategorias", categorias);
            } else {
                alert("Erro GetCategorias: " + records);
            }
        });
        $A.enqueueAction(action);
    },

    MontarListaCampos: function (component, callback) {
        var action = component.get("c.montarCamposPicklists");
        var language = component.get("v.CurrentLanguage");

        /// Executando ação
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("Retorno: MontarListaCampos " + state);
            console.log("Retorno Return value MontarListaCampos: " + response.getReturnValue());
            //console.log("Retorno get Error MontarListaCampos: " + response.getError()[0].message);

            if (component.isValid() && state === "SUCCESS") {
                var response = JSON.parse(response.getReturnValue());
                console.log("Map campos retornado");
                console.log("response campos: ", response);
                component.set("v.mapPicklistValues", response);
                //language = 'English';
                component.set("v.currentMapPicklistValues", response[language]);
            } else {
                alert("Erro: MontarListaCampos", response);
            }
        });
        $A.enqueueAction(action);
    },
    GetAllCategoriesbyMap: function (component, callback) {
        //resgata o cadastro de fornecedor a ser clonado
        console.log("Chamando serviço getCategoriesDTO");
        //var pais = component.get("v.paisSelecionado");
        var action = component.get("c.getCategoriesDTO");

        /*action.setParams({
            country: pais
        });*/

        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("Retorno GetAllCategoriesbyMap: " + state);
            if (component.isValid() && state === "SUCCESS") {
                var categorias = response.getReturnValue();
                var result = JSON.parse(categorias);
                console.log('Map retornado: ' + result);
                component.set("v.listaCompletaPorCategoria", result);
            } else {
                alert("Erro: GetAllCategoriesbyMap " + records);
            }
        });
        $A.enqueueAction(action);
    },
    SalvarFornecedor: function (component, callback) {
        //resgata o cadastro de fornecedor a ser clonado
        console.log("Chamando serviço salvar fornecedor");
        var paisSelecionado = component.get("v.paisSelecionado");
        var cadastroFornecedorSelecionado = component.get("v.cadastroFornecedorDto");
        cadastroFornecedorSelecionado.pais = paisSelecionado;
        var strParam = JSON.stringify(cadastroFornecedorSelecionado);
        console.log(strParam);

        var action = component.get("c.SalvarCadastroFornecedor");

        action.setParams({
            strCadastroFornecedorDto: strParam
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("Retorno: " + state);
            if (component.isValid() && state === "SUCCESS") {
                var retorno = response.getReturnValue();

                component.set("v.carregando", false);
                component.set("v.container1", false);
                component.set("v.container2", false);
                component.set("v.container3", false);

                if (retorno = 'SUCESSO') {
                    console.log('Fornecedor cadastrado com sucesso');
                    component.set("v.Sucesso", true);
                    component.set("v.Erro", false);
                }
                else {
                    console.log('Fornecedor cadastrado com sucesso');
                    component.set("v.Sucesso", false);
                    component.set("v.Erro", true);
                }

            } else {
                var erros = response.getError();
                console.log("erro: " + erros[0].message);
                //alert("Erro: " + erros[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    GetMetadata: function (component, callback) {
        //resgata o cadastro de fornecedor a ser clonado
        console.log("Chamando serviço getMetadataPictures");
        var action = component.get("c.getMetadataPictures");

        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("Retorno: " + state);
            if (component.isValid() && state === "SUCCESS") {
                var metadata = response.getReturnValue();
                component.set("v.SupplierMetadata", metadata);
                var listaCarousel = [];
                if (metadata.Carousel_Picture_1__c !== undefined) {
                    console.log("pic1", metadata.Carousel_Picture_1__c);
                    listaCarousel.push(metadata.Carousel_Picture_1__c);
                }
                if (metadata.Carousel_Picture_2__c !== undefined) {
                    console.log("pic2", metadata.Carousel_Picture_2__c);
                    listaCarousel.push(metadata.Carousel_Picture_2__c);
                }
                if (metadata.Carousel_Picture_3__c !== undefined) {
                    console.log("pic3", metadata.Carousel_Picture_3__c);
                    listaCarousel.push(metadata.Carousel_Picture_3__c);
                }
                if (metadata.Carousel_Picture_4__c !== undefined) {
                    console.log("pic4", metadata.Carousel_Picture_4__c);
                    listaCarousel.push(metadata.Carousel_Picture_4__c);
                }
                if (metadata.Carousel_Picture_5__c !== undefined) {
                    console.log("pic5", metadata.Carousel_Picture_5__c);
                    listaCarousel.push(metadata.Carousel_Picture_5__c);
                }

                component.set("v.carouselList", listaCarousel);

            } else {
                alert("Erro: GetMetadata " + records);
            }
        });
        $A.enqueueAction(action);
    },

    GetSupplierContents: function (component, callback) {
        //resgata o cadastro de fornecedor a ser clonado
        console.log("Chamando serviço GetSupplierPortalContents");
        var action = component.get("c.GetSupplierPortalContent");

        var language = component.get("v.CurrentLanguage");
        console.log("language: " + language);
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("Retorno GetSupplierContents: " + state);
            if (component.isValid() && state === "SUCCESS") {
                var content = response.getReturnValue();
                component.set("v.MapSupplierContent", content);
                console.log("Retorno Contents ", content);
                //console.log("map . Portuguese"+content[language].TW1_Cover_Picture__c);

                component.set("v.CurrrentSupplierContent", content[language]);


                var listaCarousel = [];
                if (content[language].TW1_Carousel_Picture_1__c !== undefined) {
                    console.log("pic1", content[language].TW1_Carousel_Picture_1__c);
                    listaCarousel.push(content[language].TW1_Carousel_Picture_1__c);
                }
                if (content[language].TW1_Carousel_Picture_2__c !== undefined) {
                    console.log("pic2", content[language].TW1_Carousel_Picture_2__c);
                    listaCarousel.push(content[language].TW1_Carousel_Picture_2__c);
                }
                if (content[language].TW1_Carousel_Picture_3__c !== undefined) {
                    console.log("pic3", content[language].TW1_Carousel_Picture_3__c);
                    listaCarousel.push(content[language].TW1_Carousel_Picture_3__c);
                }
                if (content[language].TW1_Carousel_Picture_4__c !== undefined) {
                    console.log("pic4", content[language].TW1_Carousel_Picture_4__c);
                    listaCarousel.push(content[language].TW1_Carousel_Picture_4__c);
                }
                if (content[language].TW1_Carousel_Picture_5__c !== undefined) {
                    console.log("pic5", content[language].TW1_Carousel_Picture_5__c);
                    listaCarousel.push(content[language].TW1_Carousel_Picture_5__c);
                }

                component.set("v.carouselList", listaCarousel);

            } else {
                alert("Erro:GetSupplierContents " + records);
            }
        });
        $A.enqueueAction(action);
    },

    ValidateCNPJ: function (component, callback) {


        var cadastroFornecedorSelecionado = component.get("v.cadastroFornecedorDto");
        console.log("cadastroFornecedorSelecionado cnpj: " + cadastroFornecedorSelecionado.CpfCnpj);

        /*var action = component.get("c.ValidateCNPJInputAndAccount");
        action.setParams({
            cnpj: cadastroFornecedorSelecionado.CpfCnpj
        });

        //var self = this;

        /// Executando ação
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("Retorno ValidateCNPJ: " + state);

            if (component.isValid() && state === "SUCCESS") {
                var CNPJDTO = JSON.parse(response.getReturnValue());
                console.log("response CNPJDTO Message: " + CNPJDTO.Message);
                console.log("response CNPJDTO Valid: " + CNPJDTO.Valid);

                if (CNPJDTO.Valid) {
                    console.log("CNPJ Valido helper");
                    component.set("v.container1", false);
                    component.set("v.container2", false);
                    component.set("v.container3", true);
                    component.set("v.ErroCNPJ", false);

                    var paisSelecionado = component.get("v.paisSelecionado");
                    console.log("paisSelecionado :" + paisSelecionado);
                    this.GetCategorias(component);
                }
                else {
                    console.log("CNPJ Invalido helper");
                    var inputCmp = component.find("inputDetectCNPJ");
                    inputCmp.setCustomValidity(CNPJDTO.Message); // if there was a custom error before, reset it

                    inputCmp.reportValidity(); // Tells lightning:input to show the error right away without needing interaction
                    component.set("v.ErroCNPJ", true);
                    component.set("v.ErroCNPJMessage", CNPJDTO.Message);
                }
            } else {
                alert("Erro:ValidateCNPJ ", response);
            }
        });
        $A.enqueueAction(action);*/

        //Adicionado para que entre na pagina seguinte e carregue categorias.
        //Apos sera criado o validador de ninea.

        component.set("v.container1", false);
        component.set("v.container2", false);
        component.set("v.container3", true);
        component.set("v.ErroCNPJ", false);
        var paisSelecionado = component.get("v.paisSelecionado");
        console.log("paisSelecionado :" + paisSelecionado);
        this.GetCategorias(component);
    },
});