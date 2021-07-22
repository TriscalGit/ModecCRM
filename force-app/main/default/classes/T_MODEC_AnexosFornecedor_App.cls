/**
 * @File Name          : T_MODEC_AnexosFornecedor_App.cls
 * @Description        : Classe Application para a componente de Anexos do Fornecedor (Request RecordType - BM)
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 10-22-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    15/12/2019   Rafael Hadama     Initial Version
 **/
public class T_MODEC_AnexosFornecedor_App {
    /**
     * @description
     * @author Rafael Hadama | 15/12/2019
     * @param recordOId Id do Content Version
     * @param contentIsNF BOOLEANO
     * @return void
     **/
    public string createDocumentationAndLink(List<String> listFilesId, boolean contentIsNF, string ReqBMId, string nfNumber)
    {
        try{
            //Create Documentation
            //Query Recordtype(TW1_Documentation__c) , novo >> BM_Documents
            RecordType                 recBMdocs      = [SELECT Id, Name, SobjectType FROM RecordType where Developername = 'BM_Documents'];
            RecordType                 recNFAttach    = [SELECT Id, Name, SobjectType FROM RecordType where Developername = 'TW1_NF_Attachment'];
            List<TW1_Documentation__c> listDocsInsert = new List<TW1_Documentation__c>();
            TW1_Request__c             request        = [Select Id, TW3_From_Portal__c from TW1_Request__c where Id =:ReqBMId];
            //map<String, String> mapDocsInsert = new map<String, String>(listDocsInsert);

            //Lista para atualizar como Nota fiscal
            list<string> listaContentVersionIsNF = new list<string>();
            //Lista para realizar DML nos ContentDocumentLink criados.
            list<ContentDocumentLink> listLinks = new list<ContentDocumentLink>();

            for (String fileId : listFilesId)
            {
                TW1_Documentation__c BMDocument = new TW1_Documentation__c();

                if (contentIsNF)
                {
                    BMDocument.RecordTypeId = recNFAttach.Id;
                    listaContentVersionIsNF.add(fileId);
                }
                else
                {
                    BMDocument.RecordTypeId = recBMdocs.Id;
                }
                BMDocument.TW1_Request__c     = ReqBMId;
                BMDocument.TW3_From_Portal__c = request.TW3_From_Portal__c;
                listDocsInsert.add(BMDocument);

                //Criando contentDocLink com a request.
                ContentDocumentLink contLink = new ContentDocumentLink();
                //SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, ShareType FROM ContentDocumentLink
                contLink.LinkedEntityId    = ReqBMId;
                contLink.ContentDocumentId = fileId;
                contLink.ShareType         = 'V';

                listLinks.add(contLink);
            }

            insert listDocsInsert;
            T_SDK_DebugLog.EscreverLog('listDocsInsert DML:> ' + listDocsInsert);


            for (integer i = 0; i < listDocsInsert.size(); i++)
            {
                //Create link with Content Version(recordOId) and Documentation
                ContentDocumentLink contLink = new ContentDocumentLink();
                //SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, ShareType FROM ContentDocumentLink
                contLink.LinkedEntityId    = listDocsInsert[i].Id;
                contLink.ContentDocumentId = listFilesId[i];
                contLink.ShareType         = 'V';

                listLinks.add(contLink);
            }
            insert listLinks;
            T_SDK_DebugLog.EscreverLog('Lista de links criadas^: ' + listLinks);

            list<ContentVersion> listIsNF = [Select Id, TW1_IsNF__c, ContentDocumentId from ContentVersion Where ContentDocumentId =:listaContentVersionIsNF];
            for (ContentVersion nfID:listIsNF)
            {
                nfID.TW1_IsNF__c = true;
            }
            update listIsNF;

            if (contentIsNF)
            {
                TW1_Request__c req = [SELECT Id, TW1_NF__c FROM TW1_Request__c where Id =:ReqBMId];
                req.TW1_NF__c = nfNumber;
                update req;
            }

            return 'Sucesso';
        }
        catch (Exception e) {
            // Exception handling goes here....
            T_SDK_DebugLog.EscreverLog('Erro ao criar Documentation BM - message' + e.getMessage());
            T_SDK_DebugLog.EscreverLog('Erro ao criar Documentation BM- stacktrace: ' + e.getStackTraceString());

            return e.getMessage();
        }
    }

    /**
     * @description Validar o status da NF e o Fiscal Period configurado para liberar ou não que o fornecedor faça upload da NF.
     * @author Rafael Hadama | 27/01/2020
     * @param requestBM
     * @return T_MODEC_AnexosFornecedor_Ctrl.NFDTO
     **/
    public T_MODEC_AnexosFornecedor_Ctrl.NFDTO ValidateNFUpload(TW1_Request__c requestBM)
    {
        T_MODEC_AnexosFornecedor_Ctrl.NFDTO notafiscalDTO = new T_MODEC_AnexosFornecedor_Ctrl.NFDTO();
        //Inicializando notafiscalDTO e configurando variaveis.
        notafiscalDTO.blockNF = false;
        notafiscalDTO.message = '';

        //Validating user language to display correct message
        String currentuserId   = UserInfo.getUserId();
        User   currentUserInfo = [select LanguageLocaleKey from User where Id = :UserInfo.getUserId()];

        if ((requestBM.TW1_NF_Invoice_Status__c == 'NF Accepted') || (requestBM.TW1_NF_Invoice_Status__c == 'Awaiting ACCEPT or REJECT NF or Invoice'))
        {
            T_SDK_DebugLog.EscreverLog('requestBM.TW1_NF_Invoice_Status__c ' + requestBM.TW1_NF_Invoice_Status__c);
            notafiscalDTO.blockNF = true;

            if (currentUserInfo.LanguageLocaleKey == 'pt_BR')
            {
                notafiscalDTO.message = 'NF aceita ou aguardando avaliação.';
            }
            else
            {
                notafiscalDTO.message = 'NF Accepted or Awaiting evaluation.';
            }
        }

        boolean blockFiscalPeriod = ValidateFiscalPeriod();
        if (blockFiscalPeriod)
        {
            T_SDK_DebugLog.EscreverLog('blockFiscalPeriod ' + blockFiscalPeriod);
            notafiscalDTO.blockNF = true;
            if (currentUserInfo.LanguageLocaleKey == 'pt_BR')
            {
                notafiscalDTO.message = 'Upload de NF bloqueado pelo período fiscal.';
            }
            else
            {
                notafiscalDTO.message = 'NF Upload blocked by Fiscal Period';
            }
        }

        return notafiscalDTO;
    }

    /**
     * @description Método que busca na custom settings os periodos (2 campos datetime) para o mês vigente
     * @author Rafael Hadama | 27/01/2020
     * @return boolean
     **/
    public boolean ValidateFiscalPeriod()
    {
        T_MODEC_CustomSettingsRep customSettingsREP = new T_MODEC_CustomSettingsRep();
        TW1_End_Fiscal_Period__c  fpDates           = customSettingsREP.GetFiscalPeriodDates();

        Datetime now = Datetime.now();

        system.debug('now :' + now);
        Integer offset = UserInfo.getTimezone().getOffset(now);
        system.debug('offset :' + offset);
        Datetime local = now.addSeconds(offset / 1000);
        system.debug('local :' + local);

        if (((local > fpDates.TW1_JAN_INI__c.addSeconds(offset / 1000)) && (local < fpDates.TW1_JAN_END__c.addSeconds(offset / 1000))) ||
            ((local > fpDates.TW1_FEB_INI__c.addSeconds(offset / 1000)) && (local < fpDates.TW1_FEB_END__c.addSeconds(offset / 1000))) ||
            ((local > fpDates.TW1_MAR_INI__c.addSeconds(offset / 1000)) && (local < fpDates.TW1_MAR_END__c.addSeconds(offset / 1000))) ||
            ((local > fpDates.TW1_APR_INI__c.addSeconds(offset / 1000)) && (local < fpDates.TW1_APR_END__c.addSeconds(offset / 1000))) ||
            ((local > fpDates.TW1_MAY_INI__c.addSeconds(offset / 1000)) && (local < fpDates.TW1_MAY_END__c.addSeconds(offset / 1000))) ||
            ((local > fpDates.TW1_JUN_INI__c.addSeconds(offset / 1000)) && (local < fpDates.TW1_JUN_END__c.addSeconds(offset / 1000))) ||
            ((local > fpDates.TW1_JUL_INI__c.addSeconds(offset / 1000)) && (local < fpDates.TW1_JUL_END__c.addSeconds(offset / 1000))) ||
            ((local > fpDates.TW1_AUG_INI__c.addSeconds(offset / 1000)) && (local < fpDates.TW1_AUG_END__c.addSeconds(offset / 1000))) ||
            ((local > fpDates.TW1_SEP_INI__c.addSeconds(offset / 1000)) && (local < fpDates.TW1_SEP_END__c.addSeconds(offset / 1000))) ||
            ((local > fpDates.TW1_OCT_INI__c.addSeconds(offset / 1000)) && (local < fpDates.TW1_OCT_END__c.addSeconds(offset / 1000))) ||
            ((local > fpDates.TW1_NOV_INI__c.addSeconds(offset / 1000)) && (local < fpDates.TW1_NOV_END__c.addSeconds(offset / 1000))) ||
            ((local > fpDates.TW1_DEC_INI__c.addSeconds(offset / 1000)) && (local < fpDates.TW1_DEC_END__c.addSeconds(offset / 1000))))
        {
            system.debug('Está dentro do periodo fiscal, bloqueando envio da nota');
            return true;
        }
        system.debug('Está fora do periodo fiscal');
        return false;
    }
}