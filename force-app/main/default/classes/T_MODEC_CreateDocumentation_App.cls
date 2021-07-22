/**
 * @File Name          : T_MODEC_CreateDocumentation_App.cls
 * @Description        : Classe Application para criação de Documentation
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 10-22-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    06/12/2019   Rafael Hadama     Initial Version
 **/
public class T_MODEC_CreateDocumentation_App {
    public string documentationInsertDMLAux(string recTypeId)
    {
        try{
            Controle_de_Triggers__c ctrlTriggers = Controle_de_Triggers__c.getInstance();
            TW1_Documentation__c    documentAux  = new TW1_Documentation__c();
            //documentAux.Step__c      = stepId;
            documentAux.RecordTypeId = recTypeId;
            //documentAux.OwnerId = ctrlTriggers.Triscal_User_Id__c;
            documentAux.OwnerId = UserInfo.getUserId();
            documentAux.TW1_DocumentationAux__c = true;
            insert documentAux;
            System.debug('GUFS: '+documentAux.id);
            T_SDK_DebugLog.EscreverLog('Doc criado; ID:> ' + documentAux.Id);
            return documentAux.Id;
        }
        catch (Exception e)
        {
            // Exception handling goes here....
            T_SDK_DebugLog.EscreverLog('Erro ao criar Documentation Auxiliar ' + e.getMessage());
            T_SDK_DebugLog.EscreverLog('Erro ao criar Documentation- stacktrace: ' + e.getStackTraceString());
            string emptyReturn = '';
            return emptyReturn;
        }
    }

    public string documentationUpdateDMLAux(string docId, string recordId, string comments, string objName)
    {
        try{
            //User usuarioTriscal = [Select id from User where Name = 'Suporte Triscal'];
            TW1_Documentation__c documentAux = new TW1_Documentation__c();
            documentAux.id = docId;

            documentAux.TW1_Comments__c = comments;
            //documentAux.RecordTypeId = recTypeId;
            documentAux.OwnerId = UserInfo.getUserId();
            documentAux.TW1_DocumentationAux__c = false;

            if (objName == 'TW1_Step__c')
            {
                documentAux.Step__c = recordId;
                TW1_Step__c step = [Select Id, TW1_Request__c, TW1_Interaction__c, TW3_From_Portal__c from TW1_Step__c where Id =:recordId];
                documentAux.TW1_Interaction__c = step.TW1_Interaction__c;
                documentAux.TW1_Request__c     = step.TW1_Request__c;
                documentAux.TW3_From_Portal__c = step.TW3_From_Portal__c;
                //system.debug('Id Step: ' + step);
            }
            if (objName == 'TW1_Interaction__c')
            {
                TW1_Interaction__c interaction = [Select Id, TW3_From_Portal__c from TW1_Interaction__c where Id =:recordId];
                documentAux.TW3_From_Portal__c = interaction.TW3_From_Portal__c;
                documentAux.TW1_Interaction__c = recordId;
            }
            if (objName == 'TW1_Request__c')
            {
                TW1_Request__c request = [Select Id, TW3_From_Portal__c from TW1_Request__c where Id =:recordId];
                documentAux.TW3_From_Portal__c = request.TW3_From_Portal__c;
                documentAux.TW1_Request__c     = recordId;
            }

            if (objName == 'TW1_MODEC_Contract__c')
            {
                documentAux.MODEC_Contract__c = recordId;
                TW1_MODEC_Contract__c contrato = [SELECT Id, TW1_Request__c FROM TW1_MODEC_Contract__c where id =:recordId];
                documentAux.TW1_Request__c = contrato.TW1_Request__c;
            }
            
            if (objName == 'TOBJ_AvaliacaoHSE__c')
            {
                documentAux.TCF_HSEEvaluation__c = recordId;
            }
            update documentAux;
            T_SDK_DebugLog.EscreverLog('Doc atualizado; ID:> ' + documentAux.Id);
            return documentAux.Id;
        }
        catch (Exception e)
        {
            // Exception handling goes here....
            T_SDK_DebugLog.EscreverLog('Erro ao atualizar Documentation Auxiliar ' + e.getMessage());
            T_SDK_DebugLog.EscreverLog('Erro ao atualizar Documentation- stacktrace: ' + e.getStackTraceString());
            string emptyReturn = '';
            return emptyReturn;
        }
    }
}