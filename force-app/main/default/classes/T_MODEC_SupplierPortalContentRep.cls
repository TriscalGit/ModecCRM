/**
 * @File Name          : T_MODEC_SupplierPortalContentRep.cls
 * @Description        :
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 10-23-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    28/01/2020   Rafael Hadama     Initial Version
 **/
public class T_MODEC_SupplierPortalContentRep {
    public List<Supplier_Portal_Content__c> GetSupplierContents()
    {
        string recordtypeBR = Schema.SObjectType.Supplier_Portal_Content__c.getRecordTypeInfosByDeveloperName().get('Supplier_Portal_BR').getRecordTypeId();
        List<Supplier_Portal_Content__c> listContents = [SELECT Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, TW1_Cover_Picture__c, TW1_Bottom_Picture__c, TW1_Carousel_Picture_1__c, TW1_Carousel_Picture_2__c, TW1_Carousel_Picture_3__c, TW1_Carousel_Picture_4__c, TW1_Carousel_Picture_5__c, TW1_Portal_Login_URL__c, TW1_Welcome_Title__c, TW1_Welcome_Content__c, TW1_Stages_Title__c, TW1_Stage_Content_Left__c, TW1_Stage_Content_Right__c, TW1_FAQ_Title__c, TW1_FAQ_Content__c, TW1_About_Modec_URL__c, TW1_Compliance_URL__c, TW1_HSSEQ_URL__c, TW1_Registration_steps_URL__c, TW1_Ethic_URL__c, TW1_Code_of_conduct_URL__c, TW1_Manuals_URL__c, TW1_FAQ_URL__c, TW1_Contact_Us_URL__c, TW1_Privacy_Policy_URL__c, TW1_Terms_Conditions_URL__c, TW1_Site_Map_URL__c, TW1_Page_Language__c, TW1_Youtube_URL__c, TW1_About_Modec__c, TW1_Compliance__c, TW1_HSSEQ__c, TW1_Seja_um_Fornecedor__c, TW1_Etapas_de_Cadastro__c, TW1_Etica__c, TW1_Codigo_de_conduta__c, TW1_Manuais__c, TW1_FAQ__c, TW1_Sou_Fornecedor__c, TW1_Ja_sou_Fornecedor__c, TW1_Quero_ser_Fornecedor__c, TW1_Cadastro_novo_fornecedor_Pag2__c, TW1_Cadastro_novo_fornecedor_txt_Pag2__c, TW1_CNPJ__c, TW1_Nome_da_Empresa__c, TW1_Nome_Fantasia__c, TW1_Endereco_de_Email__c, TW1_Tipo_de_Fornecedor__c, TW1_Endereco__c, TW1_Cidade__c, TW1_Estado__c, TW1_Pais__c, TW1_Contato_responsavel__c, TW1_Telefone__c, TW1_Email_do_contato__c, TW1_Continuar_btn__c, TW1_Cadastro_novo_fornecedor_Pag3__c, TW1_Cadastro_novo_fornecedor_txt_Pag3__c, TW1_Tipo_de_categoria__c, TW1_Busca_rapida__c, TW1_Categorias_disponiveis__c, TW1_Categorias_selecionadas__c, TW1_Termo_de_aceite_pt1__c, TW1_Termo_de_aceite_pt2__c, TW1_Termo_de_aceite_pt3__c, TW1_Voltar_btn__c, TW1_Concluir_btn__c, TW1_Sucesso_no_cadastro_txt__c, TW1_Sucesso_no_cadastro_btn__c, TW1_Falha_no_cadastro_txt__c, TW1_Falha_no_cadastro_btn__c, TW1_T_and_C__c, TW1_T_and_C_URL__c, TW3_Taxpayer__c FROM Supplier_Portal_Content__c where RecordTypeId =:recordtypeBR];

        T_SDK_DebugLog.EscreverLog('Quantidade de SupplierPortal Contents:' + listContents.size());

        return listContents;
    }

    public List<Supplier_Portal_Content__c> GetSenegalSupplierContents()
    {
        string recordtypeSN = Schema.SObjectType.Supplier_Portal_Content__c.getRecordTypeInfosByDeveloperName().get('Supplier_Portal_Senegal').getRecordTypeId();

        List<Supplier_Portal_Content__c> listContents = [SELECT Id, RegimeExclusivo__c, OwnerId, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, TW1_Cover_Picture__c, TW1_Bottom_Picture__c, TW1_Carousel_Picture_1__c, TW1_Carousel_Picture_2__c, TW1_Carousel_Picture_3__c, TW1_Carousel_Picture_4__c, TW1_Carousel_Picture_5__c, TW1_Portal_Login_URL__c, TW1_Welcome_Title__c, TW1_Welcome_Content__c, TW1_Stages_Title__c, TW1_Stage_Content_Left__c, TW1_Stage_Content_Right__c, TW1_FAQ_Title__c, TW1_FAQ_Content__c, TW1_About_Modec_URL__c, TW1_Compliance_URL__c, TW1_HSSEQ_URL__c, TW1_Registration_steps_URL__c, TW1_Ethic_URL__c, TW1_Code_of_conduct_URL__c, TW1_Manuals_URL__c, TW1_FAQ_URL__c, TW1_Contact_Us_URL__c, TW1_Privacy_Policy_URL__c, TW1_Terms_Conditions_URL__c, TW1_Site_Map_URL__c, TW1_Page_Language__c, TW1_Youtube_URL__c, TW1_About_Modec__c, TW1_Compliance__c, TW1_HSSEQ__c, TW1_Seja_um_Fornecedor__c, TW1_Etapas_de_Cadastro__c, TW1_Etica__c, TW1_Codigo_de_conduta__c, TW1_Manuais__c, TW1_FAQ__c, TW1_Sou_Fornecedor__c, TW1_Ja_sou_Fornecedor__c, TW1_Quero_ser_Fornecedor__c, TW1_Cadastro_novo_fornecedor_Pag2__c, TW1_Cadastro_novo_fornecedor_txt_Pag2__c, TW1_CNPJ__c, TW1_Nome_da_Empresa__c, TW1_Nome_Fantasia__c, TW1_Endereco_de_Email__c, TW1_Tipo_de_Fornecedor__c, TW1_Endereco__c, TW1_Cidade__c, TW1_Estado__c, TW1_Pais__c, TW1_Contato_responsavel__c, TW1_Telefone__c, TW1_Email_do_contato__c, TW1_Continuar_btn__c, TW1_Cadastro_novo_fornecedor_Pag3__c, TW1_Cadastro_novo_fornecedor_txt_Pag3__c, TW1_Tipo_de_categoria__c, TW1_Busca_rapida__c, TW1_Categorias_disponiveis__c, TW1_Categorias_selecionadas__c, TW1_Termo_de_aceite_pt1__c, TW1_Termo_de_aceite_pt2__c, TW1_Termo_de_aceite_pt3__c, TW1_Voltar_btn__c, TW1_Concluir_btn__c, TW1_Sucesso_no_cadastro_txt__c, TW1_Sucesso_no_cadastro_btn__c, TW1_Falha_no_cadastro_txt__c, TW1_Falha_no_cadastro_btn__c, TW1_T_and_C__c, TW1_T_and_C_URL__c, TW3_Taxpayer__c FROM Supplier_Portal_Content__c where RecordTypeId =:recordtypeSN];

        T_SDK_DebugLog.EscreverLog('Quantidade de SupplierPortal Contents:' + listContents.size());

        return listContents;
    }
}