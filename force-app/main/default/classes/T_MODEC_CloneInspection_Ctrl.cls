/**
 * @File Name          : T_MODEC_CloneInspection_Ctrl.cls
 * @Description        : Apex controller for the LP T_MODEC_CloneInspection
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 30/06/2020 15:15:09
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    29/06/2020   Rafael Hadama     Initial Version
 **/
public class T_MODEC_CloneInspection_Ctrl {
    @AuraEnabled
    public static string CloneInspectionApex(string requestId) {
        T_MODEC_CloneInspection_App CloneApp = new T_MODEC_CloneInspection_App();
        CloneResponseDto responseDto = CloneApp.CloneInspection(requestId);
        return JSON.serialize(responseDto);
    }

    public class CloneResponseDto {
        public string Status;
        public List<string> MessageList = new List<string>();
        public string CloneUrl;
    }
}