/**
 * @File Name          : T_MODEC_ScheduleInspection_Ctrl.cls
 * @Description        : Classe controller da LP T_Modec_ScheduleInspection. Validação das datas escolhidas.
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Raoni Brand
 * @Last Modified On   : 10/07/2020 11:01:59
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    17/06/2020   Rafael Hadama     Initial Version
 **/
public class T_MODEC_ScheduleInspection_Ctrl {
    /**
     * @description Method that validates the inspection dates selected by the client.
     * @author Rafael Hadama | 17/06/2020
     * @param recordId
     * @return string
     **/
    @AuraEnabled
    public static string ScheduleInspection(string strRequest)
    {
        T_MODEC_ScheduleInspection_App ScheduleApp = new T_MODEC_ScheduleInspection_App();

        system.debug('request>>>' + strRequest);

        InspectionDatesDto request = (InspectionDatesDto)JSON.deserialize(strRequest, InspectionDatesDto.class);

        system.debug('request>>>' + request);

        InspectionResponseDto retornoDto = ScheduleApp.ValidateScheduledInspection(request, true);
        //InspectionResponseDto retornoDto = new InspectionResponseDto();

        /*InspectionResponseDto retornoDto = new InspectionResponseDto();
         * retornoDto.Status = 'Sucesso';
         * list<string> listretorno = new list<string>();
         * listretorno.add('Teste 1');
         * listretorno.add('Teste 2');
         * listretorno.add('Teste 3');
         * retornoDto.MessageList = listretorno;*/
        system.debug('retornoDto' + retornoDto);

        return JSON.serialize(retornoDto);
    }

    //Classe DTO de retorno do componente de agendar inspeção.
    public class InspectionDatesDto {
        public string InspectionType;
        public date InspectionDate1;
        public date InspectionDate2;
        public date InspectionDate3;
        public date EmergencyInspectionDate;
        public String EmergencyEmail;
        public string InspectionNote;
        public string RequestId;
    }

    //criar classe de retorno ao lighting component.
    public class InspectionResponseDto {
        public string Status;
        public list<string> MessageList;
    }
}