/**
 * @File Name          : T_MODEC_SenegalCadastroApp.cls
 * @Description        :
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 10-23-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    01/07/2020   Rafael Hadama     Initial Version
 **/
public without sharing class T_MODEC_SenegalCadastroApp {
    T_MODEC_Category_Rep categoryRep = new T_MODEC_Category_Rep();
    T_MODEC_Account_REP accountRep   = new T_MODEC_Account_REP();

    public void CriarFornecedor(T_MODEC_SenegalCadastroCtrl.CadastroFornecedorDto cadastroFornecedorDto)
    {
        system.debug('TipoFornecedor >>' + cadastroFornecedorDto.TipoFornecedor);
        Account conta = new Account();

        string recordtypeSenegal = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('TW3_Supplier_Not_Homologated_Senegal').getRecordTypeId();
        //RecordType recordTypeAccount = [Select id from RecordType where DeveloperName = 'TW1_Vendor_Not_Homologated'];

        //TW1_CNPJ__c / TW1_CPF__c
        conta.Name = cadastroFornecedorDto.NomeEmpresa;

        conta.TW2_Ninea__c = cadastroFornecedorDto.CpfCnpj;
        conta.TW3_Taxpayer_Identification__c = cadastroFornecedorDto.TaxPayerNumber;

        conta.TW1_Trade_Name__c            = cadastroFornecedorDto.NomeFantasia;
        conta.TW1_Company_Email_Address__c = cadastroFornecedorDto.Email;
        conta.TW1_Supplier_Type__c         = cadastroFornecedorDto.TipoFornecedor;
        conta.BillingStreet  = cadastroFornecedorDto.Endereco;
        conta.BillingCity    = cadastroFornecedorDto.Cidade;
        conta.BillingState   = cadastroFornecedorDto.Estado;
        conta.BillingCountry = cadastroFornecedorDto.Pais;
        system.debug('BillingCountry >' + cadastroFornecedorDto.Pais);
        conta.TW1_Country__c = cadastroFornecedorDto.Pais;
        system.debug('Country >' + conta.TW1_Country__c);
        conta.TW1_Contact_Name__c          = cadastroFornecedorDto.ContatoResponsavel;
        conta.TW1_Contact_Phone__c         = cadastroFornecedorDto.ContatoTelefone;
        conta.TW1_Contact_email_address__c = cadastroFornecedorDto.ContatoEmail;
        conta.RegimeExclusivo__c           = cadastroFornecedorDto.RegimeExclusivo;
        conta.RecordTypeId       = recordtypeSenegal;
        conta.TW3_From_Portal__c = 'Senegal';
        insert conta;
        system.debug('conta >' + conta);
        List<TW1_Vendor_Category__c> lstCategorias = new List<TW1_Vendor_Category__c> ();
        for (T_MODEC_SenegalCadastroCtrl.CategoriaDTO categoriaDto : cadastroFornecedorDto.CategoriasSelecionadas.values())
        {
            system.debug('categoriaDto >' + categoriaDto);
            TW1_Vendor_Category__c categoria = new TW1_Vendor_Category__c();
            categoria.TW1_Vendor__c   = conta.Id;
            categoria.TW1_Category__c = categoriaDto.value;
            lstCategorias.add(categoria);
        }

        insert lstCategorias;
        system.debug('lstCategorias >' + lstCategorias);
    }

    public Map<string, Map<String, T_MODEC_SenegalCadastroCtrl.CategoriaDTO> > montarListaCategoriasDTO()
    {
        Map<string, Map<String, T_MODEC_SenegalCadastroCtrl.CategoriaDTO> > mapCategorias = new Map<string, Map<String, T_MODEC_SenegalCadastroCtrl.CategoriaDTO> >();

        list<TW1_Category__c> listaCategorias = categoryRep.getAllCategories();

        //Criando map a ser preenchido

        for (TW1_Category__c cat:listaCategorias)
        {
            Map<String, T_MODEC_SenegalCadastroCtrl.CategoriaDTO> mapDTO = mapCategorias.get(cat.RecordType.DeveloperName);

            if (mapDTO == null)
            {
                mapDTO = new Map<String, T_MODEC_SenegalCadastroCtrl.CategoriaDTO>();
            }


            T_MODEC_SenegalCadastroCtrl.CategoriaDTO categoriaDTO = new T_MODEC_SenegalCadastroCtrl.CategoriaDTO();
            if (cat.RecordType.DeveloperName != 'TW1_Service')
            {
                categoriaDTO.label   = cat.TW1_Category__c;
                categoriaDTO.labelEN = cat.TW1_Category_EN__c;
                categoriaDTO.labelFR = cat.TW3_Category_FR__c;
            }
            else
            {
                categoriaDTO.label   = cat.TW1_Sub_Category__c;
                categoriaDTO.labelEN = cat.TW1_SUB_CATEGORY_EN__c;
                categoriaDTO.labelFR = cat.TW3_Sub_Categoria_FR__c;
            }

            //Map here the translation fields.
            //TW1_SUB_CATEGORY_EN__c, TW1_Category_EN__c, TW3_Category_FR__c, TW3_Sub_Categoria_FR__c
            //labelFR , labelEN
            categoriaDTO.value = cat.Id;
            mapDTO.put(cat.Id, categoriaDTO);
            mapCategorias.put(cat.RecordType.DeveloperName, mapDTO);
        }

        return mapCategorias;
    }
}