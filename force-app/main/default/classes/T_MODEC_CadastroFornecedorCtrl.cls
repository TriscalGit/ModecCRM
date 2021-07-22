/**
 * @File Name          : T_MODEC_CadastroFornecedorCtrl.cls
 * @Description        :
 * @Author             : Raoni Brand
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 10-28-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    01/11/2019   Raoni Brand     Initial Version
 **/
public without sharing class T_MODEC_CadastroFornecedorCtrl {
    private static T_MODEC_CadastroFornecedorApplication cadastroFornecedorApplication = new T_MODEC_CadastroFornecedorApplication();

    @AuraEnabled
    public static string SalvarCadastroFornecedor(string strCadastroFornecedorDto)
    {
        try{
            CadastroFornecedorDto request = (CadastroFornecedorDto)JSON.deserialize(strCadastroFornecedorDto, CadastroFornecedorDto.class);
            cadastroFornecedorApplication.criarFornecedor(request);
            return 'SUCESSO';
        }
        catch (Exception e) {
            throw new AuraHandledException('Error Exception happened' + e.getMessage());
        }
    }

    /**
     * @description Método feito para preencher picklist 'Category Type' na componente
     * @author Rafael Hadama | 26/11/2019
     * @return List<Categoria>
     **/
    @AuraEnabled
    public static List<CategoriaRecType> getCategorias()
    {
        List<CategoriaRecType> listaCategorias = new List<CategoriaRecType>();
        CategoriaRecType       baseCategoria   = new CategoriaRecType();

        baseCategoria.value = 'none';
        baseCategoria.label = 'Choose a Category Type';
        listaCategorias.add(baseCategoria);

        List<RecordType> tipos = [SELECT id, Name, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'TW1_Category__c'];
        for (RecordType tipo : tipos)
        {
            CategoriaRecType temp = new CategoriaRecType();

            temp.value         = tipo.id;
            temp.label         = tipo.Name;
            temp.developerName = tipo.DeveloperName;
            listaCategorias.add(temp);
        }
        system.debug(listaCategorias);
        return listaCategorias;
    }

    @AuraEnabled
    public static Map<String, List<T_SDK_Schema.DtoFieldPicklist> > montarCamposPicklists()
    {
        system.debug('Chegou aqui');
        //T_SDK_DebugLog.EscreverLog('Entrada no método preencherPicklists');
        //Criando map de retorno
        Map<String, List<T_SDK_Schema.DtoFieldPicklist> > mapCamposbyPicklistValues = new Map<String, List<T_SDK_Schema.DtoFieldPicklist> >();
        //Chamando método da util para preencher listas de valores das picklists
        mapCamposbyPicklistValues.put('TW1_Country__c', T_SDK_Schema.getFieldPicklistValues('Account', 'TW1_Country__c'));
        mapCamposbyPicklistValues.put('TW1_Supplier_Type__c', T_SDK_Schema.getFieldPicklistValues('Account', 'TW1_Supplier_Type__c'));
        return mapCamposbyPicklistValues;
    }

    @AuraEnabled
    public static String getCategoriesByCountryDTOTst(string country)
    {
        Map<string, Map<String, CategoriaDTO> > mapRecTypebyListCategories = cadastroFornecedorApplication.montarListaCategoriasDTO(country);
        string mapJSON = JSON.serialize(mapRecTypebyListCategories);

        return mapJSON;
    }

    @AuraEnabled
    public static Map<string, Supplier_Portal_Content__c> GetSupplierPortalContents()
    {
        T_MODEC_SupplierPortalContentRep        SupplierContentREP = new T_MODEC_SupplierPortalContentRep();
        list<Supplier_Portal_Content__c>        portalConfigs      = SupplierContentREP.GetSupplierContents();
        Map<string, Supplier_Portal_Content__c> mapPortalConfigs   = new Map<string, Supplier_Portal_Content__c>();

        for (Supplier_Portal_Content__c content :portalConfigs)
        {
            if (content.TW1_Page_Language__c == 'Portuguese')
            {
                mapPortalConfigs.put('Portuguese', content);
            }
            if (content.TW1_Page_Language__c == 'English')
            {
                mapPortalConfigs.put('English', content);
            }
        }
        T_SDK_DebugLog.EscreverLog('PortalConfig: ' + portalConfigs);
        return mapPortalConfigs;
    }

    @AuraEnabled
    public static string ValidateCNPJInputAndAccount(string cnpj)
    {
        boolean CNPJValid = T_SDK_ValidateCNPJ.validaCNPJ(cnpj);

        T_SDK_DebugLog.EscreverLog('Consulta ao SDK Cnpj true=CNPJValido, false=CNPJ Invalido >' + CNPJValid);
        CNPJDto cnpjDTO = new CNPJDto();
        cnpjDTO.Message = '';

        if (CNPJValid)
        {
            cnpjDTO.Valid = cadastroFornecedorApplication.SearchCNPJInAccounts(cnpj);
            T_SDK_DebugLog.EscreverLog('Buscando contas com cnpj inserido >');
            if (cnpjDTO.Valid == false)
            {
                cnpjDTO.Message = 'CNPJ já está cadastrado, entre em contato com o responsável da conta.';
            }
            return JSON.serialize(cnpjDTO);
        }
        else
        {
            cnpjDTO.Valid   = false;
            cnpjDTO.Message = 'CNPJ Inválido.';
            return JSON.serialize(cnpjDTO);
        }
    }

    public class CNPJDto {
        public string Message;
        public boolean Valid;
    }

    public class CategoriaRecType {
        @AuraEnabled
        public string label;
        @AuraEnabled
        public string value;
        @AuraEnabled
        public string developerName;
    }

    public class CategoriaDTO {
        public string label;
        public string value;
    }



    public class CadastroFornecedorDto
    {
        public String CpfCnpj;
        public String TaxPayerNumber;
        public String NomeEmpresa;
        public String NomeFantasia;
        public String Email;
        public String TipoFornecedor;
        public String Endereco;
        public String Cidade;
        public String Estado;
        public String Pais;
        public String ContatoResponsavel;
        public String ContatoTelefone;
        public String ContatoEmail;
        public Map<String, CategoriaDTO> CategoriasSelecionadas;
    }
}