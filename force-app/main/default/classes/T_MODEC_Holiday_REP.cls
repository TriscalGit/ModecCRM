/**
 * @File Name          : T_MODEC_Holiday_REP.cls
 * @Description        : Classe REP do objeto Holiday
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 24/06/2020 14:42:48
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    22/06/2020   Rafael Hadama     Initial Version
 **/
public class T_MODEC_Holiday_REP {
    public list<Holiday> getHolidaysList()
    {
        list<Holiday> HolidaysList = [SELECT Id, Name, IsAllDay, Description, ActivityDate, CreatedDate, CreatedById FROM Holiday where ActivityDate >= TODAY];

        return HolidaysList;
    }
}