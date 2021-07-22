/**
 * @File Name          : T_MODEC_CadastroFornecedorApplication.cls
 * @Description        :
 * @Author             : Raoni Brand
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 10-28-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    01/11/2019   Raoni Brand     Initial Version
 **/
public without sharing class T_MODEC_CadastroFornecedorApplication {
    T_MODEC_Category_Rep categoryRep = new T_MODEC_Category_Rep();
    T_MODEC_Account_REP accountRep   = new T_MODEC_Account_REP();

    public void CriarFornecedor(T_MODEC_CadastroFornecedorCtrl.CadastroFornecedorDto cadastroFornecedorDto)
    {
        Account conta = new Account();

        RecordType recordTypeAccount = [Select id from RecordType where DeveloperName = 'TW1_Vendor_Not_Homologated'];

        //TW1_CNPJ__c / TW1_CPF__c
        conta.Name = cadastroFornecedorDto.NomeEmpresa;

        conta.TW1_CNPJ__c = cadastroFornecedorDto.CpfCnpj;
        conta.TW3_Taxpayer_Identification__c = cadastroFornecedorDto.TaxPayerNumber;


        conta.TW1_Trade_Name__c            = cadastroFornecedorDto.NomeFantasia;
        conta.TW1_Company_Email_Address__c = cadastroFornecedorDto.Email;
        conta.TW1_Supplier_Type__c         = cadastroFornecedorDto.TipoFornecedor;
        conta.BillingStreet                = cadastroFornecedorDto.Endereco;
        conta.BillingCity                  = cadastroFornecedorDto.Cidade;
        conta.BillingState                 = cadastroFornecedorDto.Estado;
        conta.BillingCountry               = cadastroFornecedorDto.Pais;
        conta.TW1_Country__c               = cadastroFornecedorDto.Pais;
        conta.TW1_Contact_Name__c          = cadastroFornecedorDto.ContatoResponsavel;
        conta.TW1_Contact_Phone__c         = cadastroFornecedorDto.ContatoTelefone;
        conta.TW1_Contact_email_address__c = cadastroFornecedorDto.ContatoEmail;
        conta.RecordTypeId                 = recordTypeAccount.Id;
        conta.TW3_From_Portal__c           = 'Brazil';
        insert conta;

        List<TW1_Vendor_Category__c> lstCategorias = new List<TW1_Vendor_Category__c> ();
        for (T_MODEC_CadastroFornecedorCtrl.CategoriaDTO categoriaDto : cadastroFornecedorDto.CategoriasSelecionadas.values())
        {
            TW1_Vendor_Category__c categoria = new TW1_Vendor_Category__c();
            categoria.TW1_Vendor__c   = conta.Id;
            categoria.TW1_Category__c = categoriaDto.value;
            lstCategorias.add(categoria);
        }

        insert lstCategorias;
    }

    public Map<string, Map<String, T_MODEC_CadastroFornecedorCtrl.CategoriaDTO> > montarListaCategoriasDTO(string pais)
    {
        Map<string, Map<String, T_MODEC_CadastroFornecedorCtrl.CategoriaDTO> > mapCategorias = new Map<string, Map<String, T_MODEC_CadastroFornecedorCtrl.CategoriaDTO> >();

        list<TW1_Category__c> listaCategorias = categoryRep.getCategoriesbyCountryAndRecType(pais);

        //Criando map a ser preenchido

        for (TW1_Category__c cat:listaCategorias)
        {
            Map<String, T_MODEC_CadastroFornecedorCtrl.CategoriaDTO> mapDTO = mapCategorias.get(cat.RecordType.DeveloperName);

            if (mapDTO == null)
            {
                mapDTO = new Map<String, T_MODEC_CadastroFornecedorCtrl.CategoriaDTO>();
            }


            T_MODEC_CadastroFornecedorCtrl.CategoriaDTO categoriaDTO = new T_MODEC_CadastroFornecedorCtrl.CategoriaDTO();
            if (cat.RecordType.DeveloperName != 'TW1_Service')
            {
                categoriaDTO.label = cat.TW1_Category__c;
            }
            else
            {
                categoriaDTO.label = cat.TW1_Sub_Category__c;
            }

            categoriaDTO.value = cat.Id;
            mapDTO.put(cat.Id, categoriaDTO);
            mapCategorias.put(cat.RecordType.DeveloperName, mapDTO);
        }

        return mapCategorias;
    }

    public boolean SearchCNPJInAccounts(string cnpj)
    {
        list<Account> listAccounts = accountRep.SearchAccountByCNPJ(cnpj);

        if (listAccounts.size() > 0)
        {
            return false;
        }
        else
        {
            return true;
        }
    }
}