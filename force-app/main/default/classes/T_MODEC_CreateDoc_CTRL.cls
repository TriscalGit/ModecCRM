/**
* @File Name          : T_MODEC_CreateDoc_CTRL.cls
* @Description        :
* @Author             : Rafael Hadama
* @Group              :
* @Last Modified By   : Rafael Hadama
* @Last Modified On   : 07-22-2020
* @Modification Log   :
* Ver       Date            Author              Modification
* 1.0    09/12/2019      Rafael Hadama         Initial Version
* 1.1    01/06/2021      Gabriel Uchoa             Updated
**/

public without sharing class T_MODEC_CreateDoc_CTRL {
    
    public static void findSobjectType(string recordID) {
        
        Map<String, String>             keys     = new Map<String, String>();
        Map<String, Schema.SobjectType> describe = Schema.getGlobalDescribe();
        
        string nomeObjeto = '';
        
        for (String s:describe.keyset())
        {
            string prefix = describe.get(s).getDescribe().getKeyPrefix();
            //system.debug('prefix :' + describe.get(s).getDescribe().getKeyPrefix());
            //system.debug('sobject :' + s);
            if (prefix != null)
            {
                if (recordID.startsWith(prefix))
                {
                    nomeObjeto = s;
                }
            }
            keys.put(describe.get(s).getDescribe().getKeyPrefix(), s);
        }
        system.debug('nomeObjeto :' + nomeObjeto);
        
        list<RecordType> listRecTypesDocumentation = [SELECT id, Name FROM RecordType WHERE SobjectType =:nomeObjeto];
        
        for (RecordType rec:listRecTypesDocumentation)
        {
            system.debug('RecordType:' + rec.Name);
        }
    }
    
    @AuraEnabled
    public static list<recTypesDto> getlistRecTypesDocumentation(string recordID) {
        
        Id tempId = recordId;
        String SObjectName = (String) tempId.getSObjectType().getDescribe().getName();
        list<RecordType> listRecTypesDocumentation = new list<RecordType>();
        ID_Profile__c profiles;
        
        if(!Test.isRunningTest()){
            profiles = ID_Profile__c.getInstance();
        } else{
            profiles = new ID_Profile__c();
            profiles.ID_Profile_Supplier__c = 'XXXXXXXXXXXXXXX';
            profiles.ID_Profile_System_Admin__c = 'XXXXXXXXXXXXXXX';
        }
        
        If(SObjectName == 'TW1_Request__c'){
            
            list<TW1_Request__c> reqInspection = [Select id, RecordtypeId from TW1_Request__c where Id =:recordID];
            
            string recodtypeInspection = Schema.SObjectType.TW1_Request__c.getRecordTypeInfosByDeveloperName().get('Inspection').getRecordTypeId();
            string recodtypePOReviewForm = Schema.SObjectType.TW1_Request__c.getRecordTypeInfosByDeveloperName().get('T_PO_Review_Form').getRecordTypeId();
                     //GUFS_Merge
            //caso essa variavel seja vazia, significa que o objeto alvo não é request.
            if (reqInspection.size() > 0) {
                
                if (reqInspection[0].RecordtypeId == recodtypeInspection) {
                    listRecTypesDocumentation = [SELECT id, Name, DeveloperName FROM RecordType WHERE SobjectType = 'TW1_Documentation__c' AND DeveloperName = 'TW1_Inspection_Documentation'];
                             //GUFS_Merge
                } else if(reqInspection[0].RecordtypeId == recodtypePOReviewForm) {
                    listRecTypesDocumentation = [SELECT id, Name, DeveloperName FROM RecordType WHERE SobjectType = 'TW1_Documentation__c' AND DeveloperName = 'T_PO_Review_Form'];
                             //GUFS_Merge
                } else {
                    listRecTypesDocumentation = [SELECT id, Name FROM RecordType WHERE SobjectType = 'TW1_Documentation__c'];
                }
            } else {
                listRecTypesDocumentation = [SELECT id, Name FROM RecordType WHERE SobjectType = 'TW1_Documentation__c'];
            }
            
        } else if (SObjectName == 'TW1_Interaction__c'){
            TW1_Interaction__c Interaction = [select recordType.DeveloperName from TW1_Interaction__c where id =: recordId];
            
            if(Interaction.recordType.DeveloperName == 'TW1_Incidents'){
                if(UserInfo.getProfileId() == profiles.ID_Profile_Supplier__c){
                    listRecTypesDocumentation = [SELECT id, Name, DeveloperName 
                                                 FROM RecordType 
                                                 WHERE SobjectType = 'TW1_Documentation__c' AND 
                                                 (DeveloperName = 'EvidenceIncidentInvestigation' OR DeveloperName = 'TW1_Outros')];
                } else {
                    listRecTypesDocumentation = [SELECT id, Name, DeveloperName 
                                                 FROM RecordType 
                                                 WHERE SobjectType = 'TW1_Documentation__c' AND 
                                                 (DeveloperName = 'ReportIncidensInvestigation' OR DeveloperName = 'EvidenceIncidentInvestigation' OR DeveloperName = 'TW1_Outros')];
                }
            } else {
                listRecTypesDocumentation = [SELECT id, Name FROM RecordType WHERE SobjectType = 'TW1_Documentation__c'];
            }
            
        } else if (SObjectName == 'TOBJ_AvaliacaoHSE__c'){
            TOBJ_AvaliacaoHSE__c evaluation = [select recordType.DeveloperName from TOBJ_AvaliacaoHSE__c where id =: recordId];
            
            if(UserInfo.getProfileId() == profiles.ID_Profile_Supplier__c || UserInfo.getProfileId() == profiles.ID_Profile_System_Admin__c){
            	if(evaluation.recordType.DeveloperName == 'TRT_Initial') {
                
                    listRecTypesDocumentation = [SELECT id, Name, DeveloperName 
                                                 FROM RecordType 
                                                 WHERE SobjectType = 'TW1_Documentation__c' AND 
                                                 (DeveloperName = 'TRT_02RegulatoryDocumentation' OR 
                                                  DeveloperName = 'TRT_03LeadershipRoleResponsibility' OR
                                                  DeveloperName = 'TRT_04RiskManagement' OR
                                                  DeveloperName = 'TRT_05PeopleManagement' OR
                                                  DeveloperName = 'TRT_06CommunicationsHSE' OR
                                                  DeveloperName = 'TRT_07Observations' OR
                                                  DeveloperName = 'TRT_08InternalAudits' OR
                                                  DeveloperName = 'TRT_09EmergencyManagement' OR
                                                  DeveloperName = 'TRT_10EnvironmentalManagement' OR
                                                  DeveloperName = 'TRT_11AccidentHistory' OR
                                                  DeveloperName = 'TRT_12EquipmentMaintenanceCalibration')];
                }
            }
        } else if (SObjectName == 'TW1_Step__c'){
            TW1_Step__c step = [select recordType.DeveloperName from TW1_Step__c where id =: recordId];
            if(step.recordType.developerName == 'Incidente_AcoesSeremTomadas' ||
               step.recordType.developerName == 'Incidente_EvidenciaIncidente' ||
               step.recordType.developerName == 'Incidente_ValidarEvidenciaIncidente' ||
               step.recordType.developerName == 'Incidente_ValidacaoDasAcoesIncidente'){
                   if(UserInfo.getProfileId() == profiles.ID_Profile_Supplier__c){
                       listRecTypesDocumentation = [SELECT id, Name, DeveloperName 
                                                    FROM RecordType 
                                                    WHERE SobjectType = 'TW1_Documentation__c' AND 
                                                    (DeveloperName = 'EvidenceIncidentInvestigation' OR DeveloperName = 'TW1_Outros')];
                   } else {
                       listRecTypesDocumentation = [SELECT id, Name, DeveloperName 
                                                    FROM RecordType 
                                                    WHERE SobjectType = 'TW1_Documentation__c' AND 
                                                    (DeveloperName = 'ReportIncidensInvestigation' OR DeveloperName = 'EvidenceIncidentInvestigation' OR DeveloperName = 'TW1_Outros')];
                   }
               } else if(step.recordType.developerName == 'Warning_ReceiveConfirmation') {
                   listRecTypesDocumentation = [SELECT id, Name, DeveloperName 
                                                    FROM RecordType 
                                                    WHERE SobjectType = 'TW1_Documentation__c' AND 
                                                    DeveloperName = 'RTStepWarningConfirmation'];
                   
               } else if(step.recordType.developerName == 'TW5_Quality_Receipt_Inspection_Supplier_Documentation') {
                   listRecTypesDocumentation = [SELECT id, Name, DeveloperName 
                                                FROM RecordType 
                                                WHERE SobjectType = 'TW1_Documentation__c' AND 
                                                DeveloperName = 'TW5_QualityReceiptInspectionSupplierDocumentation'];
               } else {
                   listRecTypesDocumentation = [SELECT id, Name FROM RecordType WHERE SobjectType = 'TW1_Documentation__c'];
               }            
        } else {
            listRecTypesDocumentation = [SELECT id, Name FROM RecordType WHERE SobjectType = 'TW1_Documentation__c'];
        }
        
        
        list<recTypesDto> listReturn = new list<recTypesDto>();
        
        for (RecordType rec:listRecTypesDocumentation)
        {
            recTypesDto recDto = new recTypesDto();
            recDto.value = rec.Id;
            recDto.label = rec.Name;
            listReturn.add(recDto);
        }
        return listReturn;
    }
    
    @AuraEnabled
    public static map<string, String> getRectypeMap(string recordID) {
        
        list<TW1_Request__c> reqInspection = [Select id, RecordtypeId from TW1_Request__c where Id =:recordID];
        
        //system.debug('Request : ' + reqInspection[0]);
        
        list<RecordType> listRecTypesDocumentation = new list<RecordType>();
        string           recodtypeInspection       = Schema.SObjectType.TW1_Request__c.getRecordTypeInfosByDeveloperName().get('Inspection').getRecordTypeId();
        
        system.debug('recodtypeInspection : ' + recodtypeInspection);
        //caso essa variavel seja vazia, significa que o objeto alvo não é request.
        
        //caso essa variavel seja vazia, significa que o objeto alvo não é request.
        if (reqInspection.size() > 0)
        {
            if (reqInspection[0].RecordtypeId == recodtypeInspection)
            {
                listRecTypesDocumentation = [SELECT id, Name, DeveloperName FROM RecordType WHERE SobjectType = 'TW1_Documentation__c' AND DeveloperName = 'TW1_Inspection_Documentation'];
                system.debug('is inspection : ' + listRecTypesDocumentation);
            }
            else
            {
                listRecTypesDocumentation = [SELECT id, Name FROM RecordType WHERE SobjectType = 'TW1_Documentation__c'];
                system.debug('All rectype documentation : ' + listRecTypesDocumentation);
            }
        }
        else
        {
            listRecTypesDocumentation = [SELECT id, Name FROM RecordType WHERE SobjectType = 'TW1_Documentation__c'];
            system.debug('All rectype documentation : ' + listRecTypesDocumentation);
        }
        
        map<string, string> mapRecTypes = new map<string, string>();
        
        for (RecordType rec:listRecTypesDocumentation)
        {
            mapRecTypes.put(rec.Id, rec.Name);
        }
        return mapRecTypes;
    }
    
    @AuraEnabled
    public static string createDocumentationAuxiliar(string recordtypeId, string stepId) {       
        
        T_MODEC_CreateDocumentation_App createDoc_App = new T_MODEC_CreateDocumentation_App();
        string documentationId = createDoc_App.documentationInsertDMLAux(recordtypeId);
        
        return documentationId;
    }
    
    @AuraEnabled
    public static string updateDoc(string documentId, string relatedObjectId, string comentarios)
    {
        T_SDK_DebugLog.EscreverLog('relatedObjectId > :' + relatedObjectId);
        T_SDK_DebugLog.EscreverLog('documentation criado > :' + documentId);
        
        T_MODEC_CreateDocumentation_App createDoc_App = new T_MODEC_CreateDocumentation_App();
        
        Map<String, String>             keys     = new Map<String, String>();
        Map<String, Schema.SobjectType> describe = Schema.getGlobalDescribe();
        
        string nomeObjeto = '';
        
        for (String s:describe.keyset())
        {
            string prefix = describe.get(s).getDescribe().getKeyPrefix();
            if (prefix != null)
            {
                if (relatedObjectId.startsWith(prefix))
                {
                    nomeObjeto = s;
                }
            }
            keys.put(describe.get(s).getDescribe().getKeyPrefix(), s);
        }
        system.debug('nomeObjeto :' + nomeObjeto);
        
        T_SDK_DebugLog.EscreverLog('nomeObjeto > :' + nomeObjeto);
        
        string documentationId = createDoc_App.documentationUpdateDMLAux(documentId, relatedObjectId, comentarios, nomeObjeto);
        
        return documentationId;
    }
    
    /*
     * Author: Gabriel Uchôa
     * Description: Get SObject Type of recordId 
     * Created date: 2021-01-18
     */
    @AuraEnabled
    public static String getTypeOfRecordId(Id recordID){
        String retorno = null;
        IF(recordID != null) {
            retorno = recordID.getSObjectType().getDescribe().getName();
        }
        return retorno;
    }
    
    /*
     * Author: Gabriel Uchôa
     * Description: Get SObject Type of recordId 
     * Created date: 2021-05-25
     */
    @AuraEnabled
    public static SObject getMainSObjectRecordFromRecordId(Id recordID, String campos){
        SObject retorno = null;
        Try{
            String SObjectType = getTypeOfRecordId(recordID);
            String query = 'select '+campos+' from '+SObjectType+' where id = \''+recordID+'\'';
            retorno = Database.query(query);
        } catch(Exception e){
            System.debug('Error T_MODEC_CreateDoc_CTRL.class - Method: getMainSObjectRecordFromRecordId ==> Error message: '+e.getMessage());
        }
        return retorno;
    }
    
    public class recTypesDto {
        @AuraEnabled
        public string label;
        @AuraEnabled
        public string value;
    }
}