/**
 * @File Name          : T_MODEC_SenegalCadastroTest.cls
 * @Description        :
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 10-15-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    01/07/2020   Rafael Hadama     Initial Version
 **/
@isTest
public class T_MODEC_SenegalCadastroTest {
    /**
     * @description Criando massa de teste para cadastro de um novo fornecedor
     * @author Felipe Cardozo | 05/12/2019
     * @return void
     **/
    @testSetup static void Setup()
    {
        RecordType tipoMaterial = [SELECT id, DeveloperName FROM RecordType WHERE SobjectType = 'TW1_Category__c' AND DeveloperName = 'TW1_Material'];
        RecordType tipoService  = [SELECT id, DeveloperName FROM RecordType WHERE SobjectType = 'TW1_Category__c' AND DeveloperName = 'TW1_Service'];

        // Criando categorias para serem selecionadas e testada.
        TW1_Category__c categoriaServico = new TW1_Category__c();

        categoriaServico.RecordTypeId          = tipoService.Id;
        categoriaServico.TW1_Category__c       = 'Serv Catering Offshore';
        categoriaServico.TW1_Sub_Category__c   = 'Catering Offshore';
        categoriaServico.TW1_Code__c           = 'SERV_14.01';
        categoriaServico.TW1_Material_Group__c = '36814000';
        categoriaServico.TW1_Country__c        = 'Brazil';

        TW1_Category__c categoriaMaterial = new TW1_Category__c();
        categoriaMaterial.RecordTypeId          = tipoMaterial.Id;
        categoriaMaterial.TW1_Category__c       = 'Mail and cargo transport';
        categoriaMaterial.TW1_Material_Group__c = '78100000';
        categoriaMaterial.TW1_Country__c        = 'Brazil';


        insert new TW1_Category__c[] { categoriaServico, categoriaMaterial };

        //Buscando Usuário de integração para preencher custom settings devido ao process builder Account - General process
        //User userIntegracao = [Select id from User where Name = 'Modec Integração'];
        ID_Account__c customSettingsIDAccount = new ID_Account__c();
        customSettingsIDAccount.Id_IntegrationUser__c = UserInfo.getUserId();
        insert customSettingsIDAccount;
    }

    @istest static void TesteCadastroFornecedorSucesso()
    {
        List<TW1_Category__c> categorias = [SELECT id, TW1_Category__c FROM TW1_Category__c];

        T_MODEC_SenegalCadastroCtrl.CadastroFornecedorDto cadastroFornecedorDto = new T_MODEC_SenegalCadastroCtrl.CadastroFornecedorDto();
        cadastroFornecedorDto.NomeEmpresa        = 'Empresa de teste LTDA';
        cadastroFornecedorDto.NomeFantasia       = 'Empresa de teste';
        cadastroFornecedorDto.Email              = 'Empresa@email.com';
        cadastroFornecedorDto.TipoFornecedor     = 'MUNICIPALITY';
        cadastroFornecedorDto.Endereco           = 'Rua teste, 134 - Bairro';
        cadastroFornecedorDto.Cidade             = 'Cidade';
        cadastroFornecedorDto.Estado             = 'Estado';
        cadastroFornecedorDto.Pais               = 'Brazil';
        cadastroFornecedorDto.ContatoResponsavel = 'Contato teste';
        cadastroFornecedorDto.ContatoTelefone    = '212345678';
        cadastroFornecedorDto.ContatoEmail       = 'conato@email.com.br';

        Map<String, T_MODEC_SenegalCadastroCtrl.CategoriaDTO> mapCategorias = new Map<String, T_MODEC_SenegalCadastroCtrl.CategoriaDTO>();
        for (TW1_Category__c cat : categorias)
        {
            T_MODEC_SenegalCadastroCtrl.CategoriaDTO categoriaDto = new T_MODEC_SenegalCadastroCtrl.CategoriaDTO();
            categoriaDto.value = cat.Id;
            mapCategorias.put(cat.Id, categoriaDto);
        }
        cadastroFornecedorDto.CategoriasSelecionadas = mapCategorias;

        String jsonTeste = JSON.serialize(cadastroFornecedorDto);
        T_MODEC_SenegalCadastroCtrl.SalvarCadastroFornecedor(jsonTeste);
    }

    @istest static void TestaBuscarCategoriasEPickList()
    {
        T_MODEC_SenegalCadastroCtrl.getCategorias();
        T_MODEC_SenegalCadastroCtrl.montarCamposPicklists();

        string strJson = T_MODEC_SenegalCadastroCtrl.getCategoriesDTO();
        System.assert (!string.isEmpty(strJson));
    }

    @isTest static void testSupplierContents()
    {
        list<Supplier_Portal_Content__c> listDML             = new List<Supplier_Portal_Content__c>();
        Supplier_Portal_Content__c       spContentPortuguese = new Supplier_Portal_Content__c();
        string recordtypeSN = Schema.SObjectType.Supplier_Portal_Content__c.getRecordTypeInfosByDeveloperName().get('Supplier_Portal_Senegal').getRecordTypeId();

        spContentPortuguese.name = 'SPContent French';
        spContentPortuguese.TW1_Page_Language__c = 'French';
        spContentPortuguese.recordtypeId         = recordtypeSN;

        listDML.add(spContentPortuguese);
        insert listDML;

        Test.startTest();

        Map<string, Supplier_Portal_Content__c> mapSpContents = T_MODEC_SenegalCadastroCtrl.GetSupplierPortalContent();

        system.debug('mapSpContents :' + mapSpContents);
        system.assertEquals(1, mapSpContents.size());

        Test.stopTest();
    }

    static void MakeMetadataAndCustomSettings()
    {
        system.debug('Teste system debug dentro do testSetupmetodo');
        T_Debug_Setting__mdt testSetting = new T_Debug_Setting__mdt();
        testSetting.Label                          = 'Teste';
        testSetting.DeveloperName                  = 'Teste';
        testSetting.T_Armazenar_Cause__c           = true;
        testSetting.T_Armazenar_linha_debug__c     = true;
        testSetting.T_Armazenar_StackTrace__c      = true;
        testSetting.T_Armazenar_texto_Exception__c = true;
        T_SDK_DebugLog_Test.testSetting            = testSetting;

        //Creating Custom Settings

        /*ID_Account__c customSettingIdAccount = new ID_Account__c();
         * customSettingIdAccount.Id_IntegrationUser__c = UserInfo.getUserId();
         * insert customSettingIdAccount;*/

        Controle_de_Triggers__c customControleTrigger = new Controle_de_Triggers__c();
        customControleTrigger.Trigger_Request__c = true;
        customControleTrigger.Trigger_Account__c = true;
        insert customControleTrigger;
    }
}