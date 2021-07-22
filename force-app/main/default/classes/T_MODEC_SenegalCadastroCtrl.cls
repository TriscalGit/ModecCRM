/**
* @File Name          : T_MODEC_SenegalCadastroCtrl.cls
* @Description        :
* @Author             : Rafael Hadama
* @Group              :
* @Last Modified By   : Rafael Hadama
* @Last Modified On   : 10-23-2020
* @Modification Log   :
* Ver       Date            Author              Modification
* 1.0    01/07/2020   Rafael Hadama     Initial Version
**/
public without sharing class T_MODEC_SenegalCadastroCtrl {
    private static T_MODEC_SenegalCadastroApp cadastroFornecedorApplication = new T_MODEC_SenegalCadastroApp();
    
    @AuraEnabled
    public static string SalvarCadastroFornecedor(string strCadastroFornecedorDto)
    {
        try{
            CadastroFornecedorDto request = (CadastroFornecedorDto)JSON.deserialize(strCadastroFornecedorDto, CadastroFornecedorDto.class);
            cadastroFornecedorApplication.criarFornecedor(request);
            return 'SUCESSO';
        }
        catch (Exception e) {
            system.debug('Exception >' + e.getMessage());
            throw new AuraHandledException('Error Exception happened' + e.getMessage());
        }
    }
    
    /**
* @description Método feito para preencher picklist 'Category Type' na componente
* @author Rafael Hadama | 26/11/2019
* @return List<Categoria>
**/
    @AuraEnabled
    public static String getCategorias()
    {
        Map<String, List<CategoriaRecType>> retorno = new Map<String, List<CategoriaRecType>>();
        List<CategoriaRecType> listaCategorias = new List<CategoriaRecType>();
        CategoriaRecType       baseCategoria   = new CategoriaRecType();
        
        //English
        baseCategoria.value = 'none';
        baseCategoria.label = 'Choose a Category Type';
        listaCategorias.add(baseCategoria);
        
        List<RecordType> tipos = [SELECT id, Name, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'TW1_Category__c'];
        for (RecordType tipo : tipos)
        {
            CategoriaRecType temp = new CategoriaRecType();
            
            temp.label = tipo.Name;
            temp.value = tipo.id;
            temp.developerName = tipo.DeveloperName;
            listaCategorias.add(temp);
        }
        retorno.put('English', listaCategorias);
        List<CategoriaRecType> listaCategorias2 = new List<CategoriaRecType>();
        
        //French
        CategoriaRecType       baseCategoria2   = new CategoriaRecType();
        baseCategoria2.value = 'none';
        baseCategoria2.label = 'Choisissez un type de catégorie';
        listaCategorias2.add(baseCategoria2);
        
        for (RecordType tipo : tipos)
        {
            CategoriaRecType temp = new CategoriaRecType();
            
            if(tipo.DeveloperName == 'TW1_Material'){
                temp.label = 'Matériel';
            }
            if(tipo.DeveloperName == 'TW1_Service'){
                temp.label = 'Un service';
            }
            
            temp.value = tipo.id;
            temp.developerName = tipo.DeveloperName;
            listaCategorias2.add(temp);
        }
        retorno.put('French', listaCategorias2);
        
        return JSON.serialize(retorno);
    }
    
    @AuraEnabled
    public static String montarCamposPicklists()
    {
        Map<String, MAP<String, List<T_SDK_Schema.DtoFieldPicklist>>> retorno = new Map<String, MAP<String, List<T_SDK_Schema.DtoFieldPicklist>>>();
        //T_SDK_DebugLog.EscreverLog('Entrada no método preencherPicklists');
        //Criando map de retorno
        Map<String, List<T_SDK_Schema.DtoFieldPicklist> > mapCamposbyPicklistValues = new Map<String, List<T_SDK_Schema.DtoFieldPicklist> >();
        //Chamando método da util para preencher listas de valores das picklists
        
        List<T_SDK_Schema.DtoFieldPicklist> listCountrySenegal = T_SDK_Schema.getFieldPicklistValues('Account', 'TW1_Country__c');
        // T_SDK_Schema.DtoFieldPicklist       DtoCountryPicklist = new T_SDK_Schema.DtoFieldPicklist();
        // DtoCountryPicklist.label = 'Sénégal';
        // DtoCountryPicklist.value = 'Sénégal';
        // listCountrySenegal.add(DtoCountryPicklist);
        // T_SDK_Schema.DtoFieldPicklist DtoCountryPicklist2 = new T_SDK_Schema.DtoFieldPicklist();
        // DtoCountryPicklist2.label = 'Outros';
        // DtoCountryPicklist2.value = 'Outros';
        // listCountrySenegal.add(DtoCountryPicklist2);
        
        List<T_SDK_Schema.DtoFieldPicklist> listSupplierType = T_SDK_Schema.getFieldPicklistValues('Account', 'TW1_Supplier_Type__c');
        List<T_SDK_Schema.DtoFieldPicklist> listRegimeExclusivo = T_SDK_Schema.getFieldPicklistValues('Account', 'RegimeExclusivo__c');
        
        
         for (T_SDK_Schema.DtoFieldPicklist dtofieldPicklist:listSupplierType)
        {
            switch on dtofieldPicklist.value {
                when 'BANK' {           // when block 1
                    dtofieldPicklist.label = 'Bank';
                }
                when 'GOVERNMENT OFFICE' {              // when block 2
                    dtofieldPicklist.label = 'Government Office';
                }
                when 'INDIRECTLY AFFILIATED COMPANY' {          // when block 3
                    dtofieldPicklist.label = 'Indirectly Affiliated Company';
                }
                when 'INDIVIDUAL REAL ESTATE OWNER' {             // default block, optional
                    dtofieldPicklist.label = 'Individual Real Estate Owner';
                }
                when 'LAW FIRM' {                 // default block, optional
                    dtofieldPicklist.label = 'Law Firm';
                }
                when 'MUNICIPALITY' {             // default block, optional
                    dtofieldPicklist.label = 'Municipality';
                }
                when 'NON-PROFIT PROFESSIONAL TRADE ORGANIZATION' {
                    dtofieldPicklist.label = 'Non-Profit Professional Trade Organization';
                }
                when 'OTHER' {            // default block, optional
                    dtofieldPicklist.label = 'Other';
                }
                when 'STATE UNIVERSITY' {                 // default block, optional
                    dtofieldPicklist.label = 'State University';
                }
                when 'TAX/AUDIT FIRM' {
                    dtofieldPicklist.label = 'Tax/Audit Firm';
                }
                when 'TAXING AUTHORITY' {                 // default block, optional
                    dtofieldPicklist.label = 'Taxing Authority';
                }
                when 'UTILITY PROVIDER' {                 // default block, optional
                    dtofieldPicklist.label = 'Utility Provider';
                }
                when 'WORLDWIDE TRANSPORTATION' {                 // default block, optional
                    dtofieldPicklist.label = 'Worldwide Transportation';
                }
            }
        }
        
        for (T_SDK_Schema.DtoFieldPicklist dtofieldPicklist:listCountrySenegal)
        {
            switch on dtofieldPicklist.value {
                when 'Brazil' {
                    dtofieldPicklist.label = 'Brazil';
                }
                when 'Mexico' {
                    dtofieldPicklist.label = 'Mexico';
                }
                when 'Senegal' {
                    dtofieldPicklist.label = 'Senegal';
                }
                when 'Afghanistan' {
                    dtofieldPicklist.label = 'Afghanistan';
                }
                when 'Albania' {
                    dtofieldPicklist.label = 'Albania';
                }
                when 'Algeria' {
                    dtofieldPicklist.label = 'Algeria';
                }
                when 'Andorra' {
                    dtofieldPicklist.label = 'Andorra';
                }
                when 'Angola' {
                    dtofieldPicklist.label = 'Angola';
                }
                when 'Argentina' {
                    dtofieldPicklist.label = 'Argentina';
                }
                when 'Armenia' {
                    dtofieldPicklist.label = 'Armenia';
                }
                when 'Australia' {
                    dtofieldPicklist.label = 'Australia';
                }
                when 'Austria' {
                    dtofieldPicklist.label = 'Austria';
                }
                when 'Azerbaijan' {
                    dtofieldPicklist.label = 'Azerbaijan';
                }
                when 'Bahamas' {
                    dtofieldPicklist.label = 'Bahamas';
                }
                when 'Bahrain' {
                    dtofieldPicklist.label = 'Bahrain';
                }
                when 'Bangladesh' {
                    dtofieldPicklist.label = 'Bangladesh';
                }
                when 'Barbados' {
                    dtofieldPicklist.label = 'Barbados';
                }
                when 'Belarus' {
                    dtofieldPicklist.label = 'Belarus';
                }
                when 'Belgium' {
                    dtofieldPicklist.label = 'Belgium';
                }
                when 'Belize' {
                    dtofieldPicklist.label = 'Belize';
                }
                when 'Benin' {
                    dtofieldPicklist.label = 'Benin';
                }
                when 'Bhutan' {
                    dtofieldPicklist.label = 'Bhutan';
                }
                when 'Bolivia' {
                    dtofieldPicklist.label = 'Bolivia';
                }
                when 'Bosnia-Herzegovina' {
                    dtofieldPicklist.label = 'Bosnia-Herzegovina';
                }
                when 'Botswana' {
                    dtofieldPicklist.label = 'Botswana';
                }
                when 'Brunei' {
                    dtofieldPicklist.label = 'Brunei';
                }
                when 'Bulgaria' {
                    dtofieldPicklist.label = 'Bulgaria';
                }
                when 'Burkina' {
                    dtofieldPicklist.label = 'Burkina';
                }
                when 'Burma' {
                    dtofieldPicklist.label = 'Burma';
                }
                when 'Burundi' {
                    dtofieldPicklist.label = 'Burundi';
                }
                when 'Cambodia' {
                    dtofieldPicklist.label = 'Cambodia';
                }
                when 'Cameroon' {
                    dtofieldPicklist.label = 'Cameroon';
                }
                when 'Canada' {
                    dtofieldPicklist.label = 'Canada';
                }
                when 'Cape Verde Islands' {
                    dtofieldPicklist.label = 'Cape Verde Islands';
                }
                when 'Chad' {
                    dtofieldPicklist.label = 'Chad';
                }
                when 'Chile' {
                    dtofieldPicklist.label = 'Chile';
                }
                when 'China' {
                    dtofieldPicklist.label = 'China';
                }
                when 'Colombia' {
                    dtofieldPicklist.label = 'Colombia';
                }
                when 'Congo' {
                    dtofieldPicklist.label = 'Congo';
                }
                when 'Costa Rica' {
                    dtofieldPicklist.label = 'Costa Rica';
                }
                when 'Croatia' {
                    dtofieldPicklist.label = 'Croatia';
                }
                when 'Cuba' {
                    dtofieldPicklist.label = 'Cuba';
                }
                when 'Cyprus' {
                    dtofieldPicklist.label = 'Cyprus';
                }
                when 'Czech Republic' {
                    dtofieldPicklist.label = 'Czech Republic';
                }
                when 'Denmark' {
                    dtofieldPicklist.label = 'Denmark';
                }
                when 'Djibouti' {
                    dtofieldPicklist.label = 'Djibouti';
                }
                when 'Dominica' {
                    dtofieldPicklist.label = 'Dominica';
                }
                when 'Dominican Republic' {
                    dtofieldPicklist.label = 'Dominican Republic';
                }
                when 'Ecuador' {
                    dtofieldPicklist.label = 'Ecuador';
                }
                when 'Egypt' {
                    dtofieldPicklist.label = 'Egypt';
                }
                when 'El Salvador' {
                    dtofieldPicklist.label = 'El Salvador';
                }
                when 'England' {
                    dtofieldPicklist.label = 'England';
                }
                when 'Eritrea' {
                    dtofieldPicklist.label = 'Eritrea';
                }
                when 'Estonia' {
                    dtofieldPicklist.label = 'Estonia';
                }
                when 'Ethiopia' {
                    dtofieldPicklist.label = 'Ethiopia';
                }
                when 'Fiji' {
                    dtofieldPicklist.label = 'Fiji';
                }
                when 'Finland' {
                    dtofieldPicklist.label = 'Finland';
                }
                when 'France' {
                    dtofieldPicklist.label = 'France';
                }
                when 'Gabon' {
                    dtofieldPicklist.label = 'Gabon';
                }
                when 'Gambia' {
                    dtofieldPicklist.label = 'Gambia';
                }
                when 'Georgia' {
                    dtofieldPicklist.label = 'Georgia';
                }
                when 'Germany' {
                    dtofieldPicklist.label = 'Germany';
                }
                when 'Ghana' {
                    dtofieldPicklist.label = 'Ghana';
                }
                when 'Great Britain' {
                    dtofieldPicklist.label = 'Great Britain';
                }
                when 'Greece' {
                    dtofieldPicklist.label = 'Greece';
                }
                when 'Grenada' {
                    dtofieldPicklist.label = 'Grenada';
                }
                when 'Guatemala' {
                    dtofieldPicklist.label = 'Guatemala';
                }
                when 'Guinea' {
                    dtofieldPicklist.label = 'Guinea';
                }
                when 'Guyana' {
                    dtofieldPicklist.label = 'Guyana';
                }
                when 'Haiti' {
                    dtofieldPicklist.label = 'Haiti';
                }
                when 'Holland' {
                    dtofieldPicklist.label = 'Holland';
                }
                when 'Honduras' {
                    dtofieldPicklist.label = 'Honduras';
                }
                when 'Hungary' {
                    dtofieldPicklist.label = 'Hungary';
                }
                when 'Iceland' {
                    dtofieldPicklist.label = 'Iceland';
                }
                when 'India' {
                    dtofieldPicklist.label = 'India';
                }
                when 'Indonesia' {
                    dtofieldPicklist.label = 'Indonesia';
                }
                when 'Iran' {
                    dtofieldPicklist.label = 'Iran';
                }
                when 'Iraq' {
                    dtofieldPicklist.label = 'Iraq';
                }
                when 'Ireland' {
                    dtofieldPicklist.label = 'Ireland';
                }
                when 'Israel' {
                    dtofieldPicklist.label = 'Israel';
                }
                when 'Italy' {
                    dtofieldPicklist.label = 'Italy';
                }
                when 'Japan' {
                    dtofieldPicklist.label = 'Japan';
                }
                when 'Jordan' {
                    dtofieldPicklist.label = 'Jordan';
                }
                when 'Kazakhstan' {
                    dtofieldPicklist.label = 'Kazakhstan';
                }
                when 'Kenya' {
                    dtofieldPicklist.label = 'Kenya';
                }
                when 'Korea' {
                    dtofieldPicklist.label = 'Korea';
                }
                when 'Kuwait' {
                    dtofieldPicklist.label = 'Kuwait';
                }
                when 'Laos' {
                    dtofieldPicklist.label = 'Laos';
                }
                when 'Latvia' {
                    dtofieldPicklist.label = 'Latvia';
                }
                when 'Lebanon' {
                    dtofieldPicklist.label = 'Lebanon';
                }
                when 'Liberia' {
                    dtofieldPicklist.label = 'Liberia';
                }
                when 'Libya' {
                    dtofieldPicklist.label = 'Libya';
                }
                when 'Liechtenstein' {
                    dtofieldPicklist.label = 'Liechtenstein';
                }
                when 'Lithuania' {
                    dtofieldPicklist.label = 'Lithuania';
                }
                when 'Luxenbourg' {
                    dtofieldPicklist.label = 'Luxenbourg';
                }
                when 'Macedonia' {
                    dtofieldPicklist.label = 'Macedonia';
                }
                when 'Madasgascar' {
                    dtofieldPicklist.label = 'Madasgascar';
                }
                when 'Malawi' {
                    dtofieldPicklist.label = 'Malawi';
                }
                when 'Malaysia' {
                    dtofieldPicklist.label = 'Malaysia';
                }
                when 'Mali' {
                    dtofieldPicklist.label = 'Mali';
                }
                when 'Malta' {
                    dtofieldPicklist.label = 'Malta';
                }
                when 'Maldives' {
                    dtofieldPicklist.label = 'Maldives';
                }
                when 'Mauritania' {
                    dtofieldPicklist.label = 'Mauritania';
                }
                when 'Mauritius' {
                    dtofieldPicklist.label = 'Mauritius';
                }
                when 'Moldova' {
                    dtofieldPicklist.label = 'Moldova';
                }
                when 'Monaco' {
                    dtofieldPicklist.label = 'Monaco';
                }
                when 'Mongolia' {
                    dtofieldPicklist.label = 'Mongolia';
                }
                when 'Montenegro' {
                    dtofieldPicklist.label = 'Montenegro';
                }
                when 'Morocco' {
                    dtofieldPicklist.label = 'Morocco';
                }
                when 'Mozambique' {
                    dtofieldPicklist.label = 'Mozambique';
                }
                when 'Namibia' {
                    dtofieldPicklist.label = 'Namibia';
                }
                when 'New Zealand' {
                    dtofieldPicklist.label = 'New Zealand';
                }
                when 'Nicaragua' {
                    dtofieldPicklist.label = 'Nicaragua';
                }
                when 'Niger' {
                    dtofieldPicklist.label = 'Niger';
                }
                when 'Nigeria' {
                    dtofieldPicklist.label = 'Nigeria';
                }
                when 'North Korea' {
                    dtofieldPicklist.label = 'North Korea';
                }
                when 'Norway' {
                    dtofieldPicklist.label = 'Norway';
                }
                when 'Oman' {
                    dtofieldPicklist.label = 'Oman';
                }
                when 'Pakistan' {
                    dtofieldPicklist.label = 'Pakistan';
                }
                when 'Panama' {
                    dtofieldPicklist.label = 'Panama';
                }
                when 'Papua New Guinea' {
                    dtofieldPicklist.label = 'Papua New Guinea';
                }
                when 'Paraguay' {
                    dtofieldPicklist.label = 'Paraguay';
                }
                when 'Peru' {
                    dtofieldPicklist.label = 'Peru';
                }
                when 'Philippines' {
                    dtofieldPicklist.label = 'Philippines';
                }
                when 'Poland' {
                    dtofieldPicklist.label = 'Poland';
                }
                when 'Portugal' {
                    dtofieldPicklist.label = 'Portugal';
                }
                when 'Puerto Rico' {
                    dtofieldPicklist.label = 'Puerto Rico';
                }
                when 'Qatar' {
                    dtofieldPicklist.label = 'Qatar';
                }
                when 'Romania' {
                    dtofieldPicklist.label = 'Romania';
                }
                when 'Russia' {
                    dtofieldPicklist.label = 'Russia';
                }
                when 'Rwanda' {
                    dtofieldPicklist.label = 'Rwanda';
                }
                when 'Saudi Arabia' {
                    dtofieldPicklist.label = 'Saudi Arabia';
                }
                when 'Scotland' {
                    dtofieldPicklist.label = 'Scotland';
                }
                when 'Serbia' {
                    dtofieldPicklist.label = 'Serbia';
                }
                when 'Seychelles' {
                    dtofieldPicklist.label = 'Seychelles';
                }
                when 'Sierra Leone' {
                    dtofieldPicklist.label = 'Sierra Leone';
                }
                when 'Singapore' {
                    dtofieldPicklist.label = 'Singapore';
                }
                when 'Slovakia' {
                    dtofieldPicklist.label = 'Slovakia';
                }
                when 'Slovenia' {
                    dtofieldPicklist.label = 'Slovenia';
                }
                when 'Solomon Islands' {
                    dtofieldPicklist.label = 'Solomon Islands';
                }
                when 'Somalia' {
                    dtofieldPicklist.label = 'Somalia';
                }
                when 'South Africa' {
                    dtofieldPicklist.label = 'South Africa';
                }
                when 'South Korea' {
                    dtofieldPicklist.label = 'South Korea';
                }
                when 'Spain' {
                    dtofieldPicklist.label = 'Spain';
                }
                when 'Sri Lanka' {
                    dtofieldPicklist.label = 'Sri Lanka';
                }
                when 'Sudan' {
                    dtofieldPicklist.label = 'Sudan';
                }
                when 'Suriname' {
                    dtofieldPicklist.label = 'Suriname';
                }
                when 'Swaziland' {
                    dtofieldPicklist.label = 'Swaziland';
                }
                when 'Sweden' {
                    dtofieldPicklist.label = 'Sweden';
                }
                when 'Switzerla' {
                    dtofieldPicklist.label = 'Switzerla';
                }
                when 'Syria' {
                    dtofieldPicklist.label = 'Syria';
                }
                when 'Taiwan' {
                    dtofieldPicklist.label = 'Taiwan';
                }
                when 'Tanzania' {
                    dtofieldPicklist.label = 'Tanzania';
                }
                when 'Thailand' {
                    dtofieldPicklist.label = 'Thailand';
                }
                when 'Togo' {
                    dtofieldPicklist.label = 'Togo';
                }
                when 'Trinidad and Tobago' {
                    dtofieldPicklist.label = 'Trinidad and Tobago';
                }
                when 'Tunisia' {
                    dtofieldPicklist.label = 'Tunisia';
                }
                when 'Turkey' {
                    dtofieldPicklist.label = 'Turkey';
                }
                when 'Turkmenistan' {
                    dtofieldPicklist.label = 'Turkmenistan';
                }
                when 'Tuvalu' {
                    dtofieldPicklist.label = 'Tuvalu';
                }
                when 'Uganda' {
                    dtofieldPicklist.label = 'Uganda';
                }
                when 'Ukraine' {
                    dtofieldPicklist.label = 'Ukraine';
                }
                when 'United Arab Emirates' {
                    dtofieldPicklist.label = 'United Arab Emirates';
                }
                when 'United Kingdom (UK)' {
                    dtofieldPicklist.label = 'United Kingdom (UK)';
                }
                when 'United States of America (USA)' {
                    dtofieldPicklist.label = 'United States of America (USA)';
                }
                when 'Uruguay' {
                    dtofieldPicklist.label = 'Uruguay';
                }
                when 'Uzbekistan' {
                    dtofieldPicklist.label = 'Uzbekistan';
                }
                when 'Vanuatu' {
                    dtofieldPicklist.label = 'Vanuatu';
                }
                when 'Vatican' {
                    dtofieldPicklist.label = 'Vatican';
                }
                when 'Venezuela' {
                    dtofieldPicklist.label = 'Venezuela';
                }
                when 'Vietnam' {
                    dtofieldPicklist.label = 'Vietnam';
                }
                when 'Western Samoa' {
                    dtofieldPicklist.label = 'Western Samoa';
                }
                when 'Yemen' {
                    dtofieldPicklist.label = 'Yemen';
                }
                when 'Yugoslavia' {
                    dtofieldPicklist.label = 'Yugoslavia';
                }
                when 'Zaire' {
                    dtofieldPicklist.label = 'Zaire';
                }
                when 'Zambia' {
                    dtofieldPicklist.label = 'Zambia';
                }
                when 'Zimbabwe' {
                    dtofieldPicklist.label = 'Zimbabwe';
                }
            }
        }
        
        mapCamposbyPicklistValues.put('TW1_Country__c', listCountrySenegal);
        mapCamposbyPicklistValues.put('TW1_Supplier_Type__c', listSupplierType);
        mapCamposbyPicklistValues.put('RegimeExclusivo__c', listRegimeExclusivo);
        
        retorno.put('English', mapCamposbyPicklistValues);
        mapCamposbyPicklistValues = new Map<String, List<T_SDK_Schema.DtoFieldPicklist> >();
        
        List<T_SDK_Schema.DtoFieldPicklist> listRegimeExclusivo2 = T_SDK_Schema.getFieldPicklistValues('Account', 'RegimeExclusivo__c');
        for (T_SDK_Schema.DtoFieldPicklist dtofieldPicklist:listRegimeExclusivo2)
        {
            switch on dtofieldPicklist.value {
                when 'Exclusive Regime' {           // when block 1
                    dtofieldPicklist.label = 'Régime Exclusif';
                }
                when 'Mixed Regime' {              // when block 2
                    dtofieldPicklist.label = 'Régime Mixte';
                }
                when 'Non-Exclusive Regime' {          // when block 3
                    dtofieldPicklist.label = 'Régime Non-Exclusif';
                }
            }
        }
            
        List<T_SDK_Schema.DtoFieldPicklist> listSupplierType2 = T_SDK_Schema.getFieldPicklistValues('Account', 'TW1_Supplier_Type__c');
        for (T_SDK_Schema.DtoFieldPicklist dtofieldPicklist:listSupplierType2)
        {
            switch on dtofieldPicklist.value {
                when 'BANK' {           // when block 1
                    dtofieldPicklist.label = 'Banques';
                }
                when 'GOVERNMENT OFFICE' {              // when block 2
                    dtofieldPicklist.label = 'Services Gouvernementaux';
                }
                when 'INDIRECTLY AFFILIATED COMPANY' {          // when block 3
                    dtofieldPicklist.label = 'Société indirectement affiliée à MODEC';
                }
                when 'INDIVIDUAL REAL ESTATE OWNER' {             // default block, optional
                    dtofieldPicklist.label = 'Propriétaire de bien immobilier ';
                }
                when 'LAW FIRM' {                 // default block, optional
                    dtofieldPicklist.label = 'Cabinets d`avocats';
                }
                when 'MUNICIPALITY' {             // default block, optional
                    dtofieldPicklist.label = 'Concessionnaires de Service Publique';
                }
                when 'NON-PROFIT PROFESSIONAL TRADE ORGANIZATION' {
                    dtofieldPicklist.label = 'Organizations professionnelles sans but lucratif ';
                }
                when 'OTHER' {            // default block, optional
                    dtofieldPicklist.label = 'Autre (décrire)';
                }
                when 'STATE UNIVERSITY' {                 // default block, optional
                    dtofieldPicklist.label = 'Universités Publiques';
                }
                when 'TAX/AUDIT FIRM' {
                    dtofieldPicklist.label = 'Entreprises d`audit financier/fiscal ';
                }
                when 'TAXING AUTHORITY' {                 // default block, optional
                    dtofieldPicklist.label = 'Autorité fiscale';
                }
                when 'UTILITY PROVIDER' {                 // default block, optional
                    dtofieldPicklist.label = 'FOURNISSEUR D`UTILITÉ';
                }
                when 'WORLDWIDE TRANSPORTATION' {                 // default block, optional
                    dtofieldPicklist.label = 'Transporteurs internationaux';
                }
            }
        }
        
        List<T_SDK_Schema.DtoFieldPicklist> listCountrySenegal2 = T_SDK_Schema.getFieldPicklistValues('Account', 'TW1_Country__c');
        for (T_SDK_Schema.DtoFieldPicklist dtofieldPicklist:listCountrySenegal2)
        {
            switch on dtofieldPicklist.value {
                when 'Brazil' {
                    dtofieldPicklist.label = 'Brésil';
                }
                when 'Mexico' {
                    dtofieldPicklist.label = 'Mexique';
                }
                when 'Senegal' {
                    dtofieldPicklist.label = 'Sénégal';
                }
                when 'Afghanistan' {
                    dtofieldPicklist.label = 'Afghanistan';
                }
                when 'Albania' {
                    dtofieldPicklist.label = 'Albanie';
                }
                when 'Algeria' {
                    dtofieldPicklist.label = 'Algérie';
                }
                when 'Andorra' {
                    dtofieldPicklist.label = 'Andorre';
                }
                when 'Angola' {
                    dtofieldPicklist.label = 'Angola';
                }
                when 'Argentina' {
                    dtofieldPicklist.label = 'Argentine';
                }
                when 'Armenia' {
                    dtofieldPicklist.label = 'Arménie';
                }
                when 'Australia' {
                    dtofieldPicklist.label = 'Australie';
                }
                when 'Austria' {
                    dtofieldPicklist.label = 'L\'Autriche';
                }
                when 'Azerbaijan' {
                    dtofieldPicklist.label = 'Azerbaïdjan';
                }
                when 'Bahamas' {
                    dtofieldPicklist.label = 'Bahamas';
                }
                when 'Bahrain' {
                    dtofieldPicklist.label = 'Bahreïn';
                }
                when 'Bangladesh' {
                    dtofieldPicklist.label = 'Bangladesh';
                }
                when 'Barbados' {
                    dtofieldPicklist.label = 'Barbade';
                }
                when 'Belarus' {
                    dtofieldPicklist.label = 'Biélorussie';
                }
                when 'Belgium' {
                    dtofieldPicklist.label = 'Belgique';
                }
                when 'Belize' {
                    dtofieldPicklist.label = 'Belize';
                }
                when 'Benin' {
                    dtofieldPicklist.label = 'Bénin';
                }
                when 'Bhutan' {
                    dtofieldPicklist.label = 'Bhoutan';
                }
                when 'Bolivia' {
                    dtofieldPicklist.label = 'Bolivie';
                }
                when 'Bosnia-Herzegovina' {
                    dtofieldPicklist.label = 'Bosnie-Herzégovine';
                }
                when 'Botswana' {
                    dtofieldPicklist.label = 'Botswana';
                }
                when 'Brunei' {
                    dtofieldPicklist.label = 'Brunei';
                }
                when 'Bulgaria' {
                    dtofieldPicklist.label = 'Bulgarie';
                }
                when 'Burkina' {
                    dtofieldPicklist.label = 'Burkina';
                }
                when 'Burma' {
                    dtofieldPicklist.label = 'Birmanie';
                }
                when 'Burundi' {
                    dtofieldPicklist.label = 'Burundi';
                }
                when 'Cambodia' {
                    dtofieldPicklist.label = 'Cambodge';
                }
                when 'Cameroon' {
                    dtofieldPicklist.label = 'Cameroun';
                }
                when 'Canada' {
                    dtofieldPicklist.label = 'Canada';
                }
                when 'Cape Verde Islands' {
                    dtofieldPicklist.label = 'Îles du Cap-Vert';
                }
                when 'Chad' {
                    dtofieldPicklist.label = 'Tchad';
                }
                when 'Chile' {
                    dtofieldPicklist.label = 'Chili';
                }
                when 'China' {
                    dtofieldPicklist.label = 'Chine';
                }
                when 'Colombia' {
                    dtofieldPicklist.label = 'Colombie';
                }
                when 'Congo' {
                    dtofieldPicklist.label = 'Congo';
                }
                when 'Costa Rica' {
                    dtofieldPicklist.label = 'Costa Rica';
                }
                when 'Croatia' {
                    dtofieldPicklist.label = 'Croatie';
                }
                when 'Cuba' {
                    dtofieldPicklist.label = 'Cuba';
                }
                when 'Cyprus' {
                    dtofieldPicklist.label = 'Chypre';
                }
                when 'Czech Republic' {
                    dtofieldPicklist.label = 'République Tchèque';
                }
                when 'Denmark' {
                    dtofieldPicklist.label = 'Danemark';
                }
                when 'Djibouti' {
                    dtofieldPicklist.label = 'Djibouti';
                }
                when 'Dominica' {
                    dtofieldPicklist.label = 'Dominique';
                }
                when 'Dominican Republic' {
                    dtofieldPicklist.label = 'République Dominicaine';
                }
                when 'Ecuador' {
                    dtofieldPicklist.label = 'Equateur';
                }
                when 'Egypt' {
                    dtofieldPicklist.label = 'Egypte';
                }
                when 'El Salvador' {
                    dtofieldPicklist.label = 'Le Salvador';
                }
                when 'England' {
                    dtofieldPicklist.label = 'Angleterre';
                }
                when 'Eritrea' {
                    dtofieldPicklist.label = 'Érythrée';
                }
                when 'Estonia' {
                    dtofieldPicklist.label = 'Estonie';
                }
                when 'Ethiopia' {
                    dtofieldPicklist.label = 'Ethiopie';
                }
                when 'Fiji' {
                    dtofieldPicklist.label = 'Fidji';
                }
                when 'Finland' {
                    dtofieldPicklist.label = 'Finlande';
                }
                when 'France' {
                    dtofieldPicklist.label = 'France';
                }
                when 'Gabon' {
                    dtofieldPicklist.label = 'Gabon';
                }
                when 'Gambia' {
                    dtofieldPicklist.label = 'Gambie';
                }
                when 'Georgia' {
                    dtofieldPicklist.label = 'Géorgie';
                }
                when 'Germany' {
                    dtofieldPicklist.label = 'Allemagne';
                }
                when 'Ghana' {
                    dtofieldPicklist.label = 'Ghana';
                }
                when 'Great Britain' {
                    dtofieldPicklist.label = 'Grande Bretagne';
                }
                when 'Greece' {
                    dtofieldPicklist.label = 'Grèce';
                }
                when 'Grenada' {
                    dtofieldPicklist.label = 'Grenade';
                }
                when 'Guatemala' {
                    dtofieldPicklist.label = 'Guatemala';
                }
                when 'Guinea' {
                    dtofieldPicklist.label = 'Guinée';
                }
                when 'Guyana' {
                    dtofieldPicklist.label = 'Guyane';
                }
                when 'Haiti' {
                    dtofieldPicklist.label = 'Haïti';
                }
                when 'Holland' {
                    dtofieldPicklist.label = 'Hollande';
                }
                when 'Honduras' {
                    dtofieldPicklist.label = 'Honduras';
                }
                when 'Hungary' {
                    dtofieldPicklist.label = 'Hongrie';
                }
                when 'Iceland' {
                    dtofieldPicklist.label = 'Islande';
                }
                when 'India' {
                    dtofieldPicklist.label = 'Inde';
                }
                when 'Indonesia' {
                    dtofieldPicklist.label = 'Indonésie';
                }
                when 'Iran' {
                    dtofieldPicklist.label = 'L\'Iran';
                }
                when 'Iraq' {
                    dtofieldPicklist.label = 'Irak';
                }
                when 'Ireland' {
                    dtofieldPicklist.label = 'Irlande';
                }
                when 'Israel' {
                    dtofieldPicklist.label = 'Israël';
                }
                when 'Italy' {
                    dtofieldPicklist.label = 'Italie';
                }
                when 'Japan' {
                    dtofieldPicklist.label = 'Japon';
                }
                when 'Jordan' {
                    dtofieldPicklist.label = 'Jordan';
                }
                when 'Kazakhstan' {
                    dtofieldPicklist.label = 'Kazakhstan';
                }
                when 'Kenya' {
                    dtofieldPicklist.label = 'Kenya';
                }
                when 'Korea' {
                    dtofieldPicklist.label = 'Corée';
                }
                when 'Kuwait' {
                    dtofieldPicklist.label = 'Koweit';
                }
                when 'Laos' {
                    dtofieldPicklist.label = 'Laos';
                }
                when 'Latvia' {
                    dtofieldPicklist.label = 'Lettonie';
                }
                when 'Lebanon' {
                    dtofieldPicklist.label = 'Liban';
                }
                when 'Liberia' {
                    dtofieldPicklist.label = 'Libéria';
                }
                when 'Libya' {
                    dtofieldPicklist.label = 'Libye';
                }
                when 'Liechtenstein' {
                    dtofieldPicklist.label = 'Liechtenstein';
                }
                when 'Lithuania' {
                    dtofieldPicklist.label = 'Lituanie';
                }
                when 'Luxenbourg' {
                    dtofieldPicklist.label = 'Luxembourg';
                }
                when 'Macedonia' {
                    dtofieldPicklist.label = 'Macédoine';
                }
                when 'Madasgascar' {
                    dtofieldPicklist.label = 'Madagascar';
                }
                when 'Malawi' {
                    dtofieldPicklist.label = 'Malawi';
                }
                when 'Malaysia' {
                    dtofieldPicklist.label = 'Malaisie';
                }
                when 'Mali' {
                    dtofieldPicklist.label = 'Mali';
                }
                when 'Malta' {
                    dtofieldPicklist.label = 'Malte';
                }
                when 'Maldives' {
                    dtofieldPicklist.label = 'Maldives';
                }
                when 'Mauritania' {
                    dtofieldPicklist.label = 'Mauritanie';
                }
                when 'Mauritius' {
                    dtofieldPicklist.label = 'Ile Maurice';
                }
                when 'Moldova' {
                    dtofieldPicklist.label = 'Moldavie';
                }
                when 'Monaco' {
                    dtofieldPicklist.label = 'Monaco';
                }
                when 'Mongolia' {
                    dtofieldPicklist.label = 'Mongolie';
                }
                when 'Montenegro' {
                    dtofieldPicklist.label = 'Monténégro';
                }
                when 'Morocco' {
                    dtofieldPicklist.label = 'Maroc';
                }
                when 'Mozambique' {
                    dtofieldPicklist.label = 'Mozambique';
                }
                when 'Namibia' {
                    dtofieldPicklist.label = 'Namibie';
                }
                when 'New Zealand' {
                    dtofieldPicklist.label = 'Nouvelle-Zélande';
                }
                when 'Nicaragua' {
                    dtofieldPicklist.label = 'Nicaragua';
                }
                when 'Niger' {
                    dtofieldPicklist.label = 'Niger';
                }
                when 'Nigeria' {
                    dtofieldPicklist.label = 'Nigeria';
                }
                when 'North Korea' {
                    dtofieldPicklist.label = 'Corée du Nord';
                }
                when 'Norway' {
                    dtofieldPicklist.label = 'Norvège';
                }
                when 'Oman' {
                    dtofieldPicklist.label = 'Oman';
                }
                when 'Pakistan' {
                    dtofieldPicklist.label = 'Pakistan';
                }
                when 'Panama' {
                    dtofieldPicklist.label = 'Panama';
                }
                when 'Papua New Guinea' {
                    dtofieldPicklist.label = 'Papouasie Nouvelle Guinée';
                }
                when 'Paraguay' {
                    dtofieldPicklist.label = 'Paraguay';
                }
                when 'Peru' {
                    dtofieldPicklist.label = 'Pérou';
                }
                when 'Philippines' {
                    dtofieldPicklist.label = 'Philippines';
                }
                when 'Poland' {
                    dtofieldPicklist.label = 'Pologne';
                }
                when 'Portugal' {
                    dtofieldPicklist.label = 'le Portugal';
                }
                when 'Puerto Rico' {
                    dtofieldPicklist.label = 'Porto Rico';
                }
                when 'Qatar' {
                    dtofieldPicklist.label = 'Qatar';
                }
                when 'Romania' {
                    dtofieldPicklist.label = 'Roumanie';
                }
                when 'Russia' {
                    dtofieldPicklist.label = 'Russie';
                }
                when 'Rwanda' {
                    dtofieldPicklist.label = 'Rwanda';
                }
                when 'Saudi Arabia' {
                    dtofieldPicklist.label = 'Arabie Saoudite';
                }
                when 'Scotland' {
                    dtofieldPicklist.label = 'Écosse';
                }
                when 'Serbia' {
                    dtofieldPicklist.label = 'Serbie';
                }
                when 'Seychelles' {
                    dtofieldPicklist.label = 'les Seychelles';
                }
                when 'Sierra Leone' {
                    dtofieldPicklist.label = 'Sierra Leone';
                }
                when 'Singapore' {
                    dtofieldPicklist.label = 'Singapour';
                }
                when 'Slovakia' {
                    dtofieldPicklist.label = 'Slovaquie';
                }
                when 'Slovenia' {
                    dtofieldPicklist.label = 'Slovénie';
                }
                when 'Solomon Islands' {
                    dtofieldPicklist.label = 'Les îles Salomon';
                }
                when 'Somalia' {
                    dtofieldPicklist.label = 'Somalie';
                }
                when 'South Africa' {
                    dtofieldPicklist.label = 'Afrique du Sud';
                }
                when 'South Korea' {
                    dtofieldPicklist.label = 'Corée du Sud';
                }
                when 'Spain' {
                    dtofieldPicklist.label = 'Espagne';
                }
                when 'Sri Lanka' {
                    dtofieldPicklist.label = 'Sri Lanka';
                }
                when 'Sudan' {
                    dtofieldPicklist.label = 'Soudan';
                }
                when 'Suriname' {
                    dtofieldPicklist.label = 'Suriname';
                }
                when 'Swaziland' {
                    dtofieldPicklist.label = 'Swaziland';
                }
                when 'Sweden' {
                    dtofieldPicklist.label = 'Suède';
                }
                when 'Switzerla' {
                    dtofieldPicklist.label = 'Switzerla';
                }
                when 'Syria' {
                    dtofieldPicklist.label = 'Syrie';
                }
                when 'Taiwan' {
                    dtofieldPicklist.label = 'Taïwan';
                }
                when 'Tanzania' {
                    dtofieldPicklist.label = 'Tanzanie';
                }
                when 'Thailand' {
                    dtofieldPicklist.label = 'Thaïlande';
                }
                when 'Togo' {
                    dtofieldPicklist.label = 'Aller';
                }
                when 'Trinidad and Tobago' {
                    dtofieldPicklist.label = 'Trinité-et-Tobago';
                }
                when 'Tunisia' {
                    dtofieldPicklist.label = 'Tunisie';
                }
                when 'Turkey' {
                    dtofieldPicklist.label = 'dinde';
                }
                when 'Turkmenistan' {
                    dtofieldPicklist.label = 'Turkménistan';
                }
                when 'Tuvalu' {
                    dtofieldPicklist.label = 'Tuvalu';
                }
                when 'Uganda' {
                    dtofieldPicklist.label = 'Ouganda';
                }
                when 'Ukraine' {
                    dtofieldPicklist.label = 'Ukraine';
                }
                when 'United Arab Emirates' {
                    dtofieldPicklist.label = 'Emirats Arabes Unis';
                }
                when 'United Kingdom (UK)' {
                    dtofieldPicklist.label = 'Royaume-Uni (UK)';
                }
                when 'United States of America (USA)' {
                    dtofieldPicklist.label = 'États-Unis d\'Amérique (USA)';
                }
                when 'Uruguay' {
                    dtofieldPicklist.label = 'Uruguay';
                }
                when 'Uzbekistan' {
                    dtofieldPicklist.label = 'Ouzbékistan';
                }
                when 'Vanuatu' {
                    dtofieldPicklist.label = 'Vanuatu';
                }
                when 'Vatican' {
                    dtofieldPicklist.label = 'Vatican';
                }
                when 'Venezuela' {
                    dtofieldPicklist.label = 'Venezuela';
                }
                when 'Vietnam' {
                    dtofieldPicklist.label = 'Vietnam';
                }
                when 'Western Samoa' {
                    dtofieldPicklist.label = 'Samoa occidentales';
                }
                when 'Yemen' {
                    dtofieldPicklist.label = 'Yémen';
                }
                when 'Yugoslavia' {
                    dtofieldPicklist.label = 'Yougoslavie';
                }
                when 'Zaire' {
                    dtofieldPicklist.label = 'Zaïre';
                }
                when 'Zambia' {
                    dtofieldPicklist.label = 'Zambie';
                }
                when 'Zimbabwe' {
                    dtofieldPicklist.label = 'Zimbabwe';
                }
            }
        }
        mapCamposbyPicklistValues.put('TW1_Country__c', listCountrySenegal2);
        mapCamposbyPicklistValues.put('TW1_Supplier_Type__c', listSupplierType2);
        mapCamposbyPicklistValues.put('RegimeExclusivo__c', listRegimeExclusivo2);
        retorno.put('French', mapCamposbyPicklistValues);
        return JSON.serialize(retorno);
    }
    
    @AuraEnabled
    public static String getCategoriesDTO()
    {
        Map<string, Map<String, CategoriaDTO> > mapRecTypebyListCategories = cadastroFornecedorApplication.montarListaCategoriasDTO();
        
        string mapJSON = JSON.serialize(mapRecTypebyListCategories);
        
        return mapJSON;
    }
    
    @AuraEnabled
    public static Map<string, Supplier_Portal_Content__c> GetSupplierPortalContent()
    {
        T_MODEC_SupplierPortalContentRep        SupplierContentREP = new T_MODEC_SupplierPortalContentRep();
        list<Supplier_Portal_Content__c>        portalConfigs      = SupplierContentREP.GetSenegalSupplierContents();
        Map<string, Supplier_Portal_Content__c> mapPortalConfigs   = new Map<string, Supplier_Portal_Content__c>();
        
        for (Supplier_Portal_Content__c content :portalConfigs)
        {
            if (content.TW1_Page_Language__c == 'French')
            {
                mapPortalConfigs.put('French', content);
            }
            
            if (content.TW1_Page_Language__c == 'English')
            {
                mapPortalConfigs.put('English', content);
            }
        }
        system.debug('portalConfigs>' + portalConfigs);
        system.debug('portalConfigs size() >' + portalConfigs.size());
        system.debug('mapPortalConfigs>' + mapPortalConfigs);
        return mapPortalConfigs;
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
        public string labelEN;
        public string labelFR;
    }
    
    
    
    public class CadastroFornecedorDto
    {
        public String CpfCnpj;
        public String TaxPayerNumber;
        public String NomeEmpresa;
        public String NomeFantasia;
        public String Email;
        public String TipoFornecedor;
        public String RegimeExclusivo;
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