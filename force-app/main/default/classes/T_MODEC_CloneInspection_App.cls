/**
 * @File Name          : T_MODEC_CloneInspection_App.cls
 * @Description        : Apex application for the LP T_MODEC_CloneInspection
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 07-09-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    29/06/2020   Rafael Hadama     Initial Version
 **/
public class T_MODEC_CloneInspection_App {
    
    public T_MODEC_CloneInspection_Ctrl.CloneResponseDto CloneInspection(string RequestId) {
        
        T_MODEC_CloneInspection_Ctrl.CloneResponseDto ResponseDto = new T_MODEC_CloneInspection_Ctrl.CloneResponseDto();
        
        try {
            T_MODEC_Request_Rep RequestREP = new T_MODEC_Request_Rep();
            TW1_Request__c Inspection = RequestREP.getInspectionAndInspectionLinesCLONE(RequestId);       
            
            TW1_Request__c CloneInspection = new TW1_Request__c();
            CloneInspection.RecordTypeId                           = Inspection.RecordtypeId;
            CloneInspection.TW1_Purchase_Order__c                  = Inspection.TW1_Purchase_Order__c;
            CloneInspection.TW1_Work_Order__c                      = Inspection.TW1_Work_Order__c;
            CloneInspection.TW1_Change_and_Repair_Project__c       = Inspection.TW1_Change_and_Repair_Project__c;
            CloneInspection.TW1_Project_Number__c                  = Inspection.TW1_Project_Number__c;
            CloneInspection.TW1_Management_Of_Change__c            = Inspection.TW1_Management_Of_Change__c;
            CloneInspection.TW1_WO_Due_Date__c                     = Inspection.TW1_WO_Due_Date__c;
            CloneInspection.TW1_Planned_Delivery_Date__c           = Inspection.TW1_Planned_Delivery_Date__c;
            CloneInspection.Technical_Inspection_Recommendation__c = Inspection.Technical_Inspection_Recommendation__c;
            CloneInspection.TW1_Facility__c                        = Inspection.TW1_Facility__c;
            CloneInspection.TW1_Inspection_Perfomed__c             = Inspection.TW1_Inspection_Perfomed__c;
            CloneInspection.TW1_Inspection_Contact_Number__c       = Inspection.TW1_Inspection_Contact_Number__c;
            CloneInspection.TW1_Inspection_Address__c              = Inspection.TW1_Inspection_Address__c;
            CloneInspection.TW1_Vendor__c                          = Inspection.TW1_Vendor__c;
            CloneInspection.Inspection_Type__c                     = Inspection.Inspection_Type__c;
            CloneInspection.TW1_Related_Request__c                 = Inspection.Id;
            CloneInspection.TW1_Supplier_Email__c                  = Inspection.TW1_Supplier_Email__c;
            CloneInspection.TW1_Inspection_Status__c               = 'Not Submitted';
            
            TriggerFactory.stopRequestTrigger = false;
            Database.SaveResult SaveResult = Database.insert(CloneInspection, true);
            
            if (SaveResult.isSuccess()) {
                User uObj = [Select id, Profile.UserLicense.Name from User where Id =: UserInfo.getUserId()];
                
                ResponseDto.Status = 'Sucesso';
                if (uObj.Profile.UserLicense.Name == 'External Apps') {
                    ResponseDto.CloneUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + '/modecsupplierportal/s/detail/' + SaveResult.getId();
                } else {
                    ResponseDto.CloneUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + SaveResult.getId();
                }
                
                if (Inspection.Inspection_Items__r.size() > 0) {
                    
                    List<TW1_Inspection_Item__c> listInspecItens = new list<TW1_Inspection_Item__c>();
                    
                    for (TW1_Inspection_Item__c InspecItem: Inspection.Inspection_Items__r) {
                        TW1_Inspection_Item__c inspectionItem = new TW1_Inspection_Item__c();
                        
                        inspectionItem.TW1_Quantity__c = InspecItem.TW1_Quantity__c;
                        inspectionItem.TW1_Tag_or_Certificate_Number__c = InspecItem.TW1_Tag_or_Certificate_Number__c;
                        inspectionItem.TW1_Heat_Number__c = InspecItem.TW1_Heat_Number__c;
                        inspectionItem.TW1_Item_Description__c = InspecItem.TW1_Item_Description__c;
                        inspectionItem.TW1_Request__c = SaveResult.getId();
                        inspectionItem.TW1_Previous_Status__c = InspecItem.TW1_Status__c;
                        inspectionItem.TW5_Isometric_Drawing__c = InspecItem.TW5_Isometric_Drawing__c;
                        inspectionItem.TW5_PO_Item_Number__c = InspecItem.TW5_PO_Item_Number__c;
                        
                        listInspecItens.add(inspectionItem);
                    }
                    insert listInspecItens;
                }
            } else {
                for (Database.Error err : SaveResult.getErrors()) {
                    ResponseDto.Status = 'Erro';
                    ResponseDto.MessageList.add(err.getMessage());
                    System.debug('Database.Error T_MODEC_CloneInspection_App.class - Method: CloneInspection() ==> ' + err.getMessage());
                }
            }
        } catch(Exception e){
            ResponseDto.Status = 'Erro';
            ResponseDto.MessageList.add(e.getMessage());
            System.debug('Exception.Error T_MODEC_CloneInspection_App.class - Method: CloneInspection() ==> ' + e.getMessage());
        }
        return ResponseDto;
    }
}