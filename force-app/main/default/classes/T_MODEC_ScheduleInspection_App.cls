/**
 * @File Name          : T_MODEC_ScheduleInspection_App.cls
 * @Description        : Classe application da LP T_Modec_ScheduleInspection. Validação das datas escolhidas.
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 07-22-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    17/06/2020   Rafael Hadama     Initial Version
 **/
public class T_MODEC_ScheduleInspection_App {
    public Map<Date, Holiday> MapDateHolidays { get; set; }
    public T_MODEC_ScheduleInspection_Ctrl.InspectionResponseDto AuraResponse { get; set; }

    public long StaticQtdDaysRule { get; set; }
    public decimal StaticDailyHourBreak { get; set; }

    public string UserLanguage { get; set; }

    public T_MODEC_ScheduleInspection_App()
    {
        MapDateHolidays = new Map<Date, Holiday>();
        T_MODEC_Holiday_REP HolidayRep   = new T_MODEC_Holiday_REP();
        list<Holiday>       HolidaysList = HolidayRep.getHolidaysList();
        System.debug('HolidaysList> ' + HolidaysList);

        //Saturday, sunday and holiday are note valid days for the purpose of this logic
        for (Holiday notValidDay:HolidaysList)
        {
            MapDateHolidays.put(notValidDay.ActivityDate, notValidDay);
        }

        System.debug('MapDateHolidays> ' + MapDateHolidays);
    }

    public T_MODEC_ScheduleInspection_Ctrl.InspectionResponseDto ValidateScheduledInspection(T_MODEC_ScheduleInspection_Ctrl.InspectionDatesDto scheduleDTO, boolean SaveDateInputs)
    {
        //MapDateHolidays          = new Map<Date, Holiday>();
        AuraResponse             = new T_MODEC_ScheduleInspection_Ctrl.InspectionResponseDto();
        AuraResponse.Status      = 'Sucesso';
        AuraResponse.MessageList = new list<String>();


        //Querying current user language
        String currentuserId   = UserInfo.getUserId();
        User   currentUserInfo = [select LanguageLocaleKey from User where Id = :UserInfo.getUserId()];
        UserLanguage = currentUserInfo.LanguageLocaleKey;
        system.debug('current UserLanguage: ' + UserLanguage);
        //Querying custom setting schedule info TW2_Inspection_Advance_Hours_Schedule , TW2_Inspection_Daily_Hour_Break__c
        Controle_de_Triggers__c ctrlTriggers = Controle_de_Triggers__c.getInstance();

        System.debug('ctrlTriggers.TW2_Inspection_Advance_Hours_Schedule__c > ' + ctrlTriggers.TW2_Inspection_Advance_Hours_Schedule__c);
        System.debug('ctrlTriggers.TW2_Inspection_Daily_Hour_Break__c > ' + ctrlTriggers.TW2_Inspection_Daily_Hour_Break__c);
        StaticDailyHourBreak = ctrlTriggers.TW2_Inspection_Daily_Hour_Break__c;
        decimal QtdDayDecimal = ctrlTriggers.TW2_Inspection_Advance_Hours_Schedule__c / 24;
        long    QtdDaysRule   = QtdDayDecimal.round(System.RoundingMode.CEILING);
        System.debug('QtdDaysRule> ' + QtdDaysRule);
        StaticQtdDaysRule = QtdDaysRule;
        //Query made with date filter -> Holiday Data >= Today


        System.debug('scheduleDTO> ' + scheduleDTO);

        T_MODEC_Request_Rep requestREP = new T_MODEC_Request_Rep();

        //realizar query na request com id = requestId
        TW1_Request__c    inspection    = requestREP.getRequestById(scheduleDTO.RequestId);
        Map<String, Date> InputDatesMap = new Map<String, Date>();
        if (scheduleDTO.InspectionType == 'normal')
        {
            //metodo normal

            InputDatesMap.put('Date Option 1', Date.valueOf(scheduleDTO.InspectionDate1));
            InputDatesMap.put('Date Option 2', Date.valueOf(scheduleDTO.InspectionDate2));
            InputDatesMap.put('Date Option 3', Date.valueOf(scheduleDTO.InspectionDate3));
            ValidateRegularInspectionSchedule(InputDatesMap, Inspection);
        }
        else
        {
            //metodo emergencial

            InputDatesMap.put('Emergency Date', Date.valueOf(scheduleDTO.EmergencyInspectionDate));
            ValidateEmergencialInspectionSchedule(InputDatesMap, Inspection, scheduleDTO.EmergencyEmail);
        }

        system.debug('AuraResponse antes de retornar ao aura' + AuraResponse);

        if (AuraResponse.Status == 'Erro')
        {
            return AuraResponse;
        }
        else
        {
            if (SaveDateInputs)
            {
                SaveInspectionDates(InputDatesMap, Inspection, scheduleDTO);
            }
            return AuraResponse;
        }
    }

    public void ValidateRegularInspectionSchedule(Map<String, Date> InputDatesMap, TW1_Request__c Inspection)
    {
        system.debug('Metodo ValidateRegularInspectionSchedule');

        CheckRequestStatus(Inspection);
        if (AuraResponse.MessageList.size() > 0)
        {
            return;
        }
        //validando dates
        CheckDates(InputDatesMap);
        if (AuraResponse.MessageList.size() > 0)
        {
            return;
        }
        CheckDatesInputs(InputDatesMap);
        if (AuraResponse.MessageList.size() > 0)
        {
            return;
        }
        CheckNotWorkingDays(InputDatesMap);
        if (AuraResponse.MessageList.size() > 0)
        {
            return;
        }
        CheckDateAntecedencia(InputDatesMap, 'normal');
        if (AuraResponse.MessageList.size() > 0)
        {
            return;
        }
    }

    public void ValidateEmergencialInspectionSchedule(Map<String, Date> InputDatesMap, TW1_Request__c Inspection, String EmergencyEmail)
    {
        CheckRequestStatus(Inspection);
        if (AuraResponse.MessageList.size() > 0)
        {
            return;
        }
        //validando dates
        CheckDates(InputDatesMap);
        if (AuraResponse.MessageList.size() > 0)
        {
            return;
        }
        //validating email.
        ValidateEmergencyEmail(EmergencyEmail);
        if (AuraResponse.MessageList.size() > 0)
        {
            return;
        }

        /*CheckNotWorkingDays(InputDatesMap);
         * if (AuraResponse.MessageList.size() > 0)
         * {
         *  return;
         * }*/
        /*
         * CheckDateAntecedencia(InputDatesMap, 'emergencial');
         * if (AuraResponse.MessageList.size() > 0)
         * {
         *  return;
         * }*/
    }

    /**
     * @description Method that validates if the request status is == 'Not Submitted'
     * @author Rafael Hadama | 24/06/2020
     * @return void
     **/
    public void CheckRequestStatus(TW1_Request__c Inspection)
    {
        list<string> listMessageAux = new list<string>();

        //realizar query na request com id = requestId
        system.debug('Inspection: ' + Inspection.TW1_Inspection_Status__c);
        if (Inspection.TW1_Inspection_Status__c != 'Not Submitted')
        {
            //Erro pois a data é invalida - anterior a hoje
            AuraResponse.Status = 'Erro';
            if (UserLanguage == 'pt_BR')
            {
                listMessageAux.add('Esta inspeção já foi enviada');
            }
            else
            {
                listMessageAux.add('This inspection was already sent.');
            }
        }

        if (listMessageAux.size() > 0)
        {
            AuraResponse.MessageList.addAll(listMessageAux);
        }
    }

    public void SaveInspectionDates(Map<String, Date> InputDatesMap, TW1_Request__c Inspection, T_MODEC_ScheduleInspection_Ctrl.InspectionDatesDto ScheduleDto)
    {
        //Inspection.TW1_Emergency_Email__c =;
        //String InspectionNote
        list<string> listMessageAux = new list<string>();

        system.debug('inspection: ' + Inspection.TW1_Inspection_Status__c);
        system.debug('InspectionType: ' + ScheduleDto.InspectionType);

        if (ScheduleDto.InspectionType == 'normal')
        {
            Inspection.TW1_Inspection_Date_Option_1__c = InputDatesMap.get('Date Option 1');
            Inspection.TW1_Inspection_Date_Option_2__c = InputDatesMap.get('Date Option 2');
            Inspection.TW1_Inspection_Date_Option_3__c = InputDatesMap.get('Date Option 3');
            Inspection.TW1_Note__c            = ScheduleDto.InspectionNote;
            Inspection.TW1_Emergency_Date__c  = null;
            Inspection.TW1_Emergency_Email__c = null;
        }
        else
        {
            Inspection.TW1_Emergency_Date__c  = InputDatesMap.get('Emergency Date');
            Inspection.TW1_Note__c            = ScheduleDto.InspectionNote;
            Inspection.TW1_Emergency_Email__c = ScheduleDto.EmergencyEmail;

            Inspection.TW1_Inspection_Date_Option_1__c = null;
            Inspection.TW1_Inspection_Date_Option_2__c = null;
            Inspection.TW1_Inspection_Date_Option_3__c = null;
        }
        TriggerFactory.stopRequestTrigger = false;
        update Inspection;
    }

    /**
     * @description Method that validates if any of the dates in the list is < TODAY
     * @author Rafael Hadama | 24/06/2020
     * @return void
     **/
    public void CheckDates(Map<String, Date> MapDates)
    {
        list<string> listMessageAux = new list<string>();

        for (Date inputDate:MapDates.values())
        {
            if (inputDate < date.today())
            {
                //Erro pois a data é invalida - anterior a hoje
                AuraResponse.Status = 'Erro';


                if (UserLanguage == 'pt_BR')
                {
                    listMessageAux.add('Data ' + inputDate.format() + ' é inválida');
                }
                else
                {
                    listMessageAux.add('Date ' + inputDate.format() + ' is invalid');
                }
            }
        }
        if (listMessageAux.size() > 0)
        {
            AuraResponse.MessageList.addAll(listMessageAux);
        }
    }

    public void ValidateEmergencyEmail(string Emergencyemail)
    {
        list<string> listMessageAux = new list<string>();

        /*for (Date inputDate:MapDates.values())
         * {
         *  if (inputDate < date.today())
         *  {
         *
         *  }
         * }*/
        string rectypeIdEmailListInspection = Schema.SObjectType.TW1_Email_List__c.getRecordTypeInfosByDeveloperName().get('TW1_Inspection_Email').getRecordTypeId();
        List<TW1_Email_List__c> emailList   = [SELECT TW1_Email__c, TW1_Status__c FROM TW1_Email_List__c WHERE TW1_Status__c = 'Ativo' AND RecordtypeId = :rectypeIdEmailListInspection];

        T_SDK_DebugLog.EscreverLog('lista de emails :' + emailList);
        List<string> listEmailsAtivos = new List<string>();

        for (TW1_Email_List__c em :emailList)
        {
            listEmailsAtivos.add(em.TW1_Email__c);
        }

        //Verificar se emails de EmergencyEmail (TW1_Request__c) estão em TW1_Email__c (TW1_Email_List__c)
        if (!listEmailsAtivos.contains(Emergencyemail))
        {
            T_SDK_DebugLog.EscreverLog('Entrou na comparação entre emails em Emergencyemail e TW1_Email__c');
            //Validating user language to display correct message
            //Erro pois a data é invalida - anterior a hoje
            AuraResponse.Status = 'Erro';


            if (UserLanguage == 'pt_BR')
            {
                listMessageAux.add('O email ' + Emergencyemail + ' não está cadastrado no sistema.');
            }
            else
            {
                listMessageAux.add('The email ' + Emergencyemail + ' is not registered in the system.');
            }
        }



        if (listMessageAux.size() > 0)
        {
            AuraResponse.MessageList.addAll(listMessageAux);
        }
    }

    /**
     * @description Method that validates if there are duplicate dates and the order Date1>Date2>Date3.
     * @author Rafael Hadama | 24/06/2020
     * @return void
     **/
    public void CheckDatesInputs(Map<String, Date> MapDates)
    {
        list<string> listMessageAux = new list<string>();
        Date         Date1          = MapDates.get('Date Option 1');
        Date         Date2          = MapDates.get('Date Option 2');
        Date         Date3          = MapDates.get('Date Option 3');

        if ((Date1 == Date2) || (Date1 == Date3) || (Date2 == Date3))
        {
            system.debug('erro data duplicada');
            //Erro pois existe data duplicada
            AuraResponse.Status = 'Erro';

            if (UserLanguage == 'pt_BR')
            {
                listMessageAux.add('Existem data duplicadas.');
            }
            else
            {
                listMessageAux.add('There are duplicate dates.');
            }


            AuraResponse.MessageList.addAll(listMessageAux);
            return;
        }

        if ((Date1 > Date2) || (Date1 > Date3) || (Date2 > Date3))
        {
            system.debug('erro data fora ordem');
            //Erro pois existe data fora de ordem
            AuraResponse.Status = 'Erro';

            if (UserLanguage == 'pt_BR')
            {
                listMessageAux.add('A ordem das datas deve ser Data 1 > Data 2 > Data 3.');
            }
            else
            {
                listMessageAux.add('The order of the dates should be Date 1 > Date 2 > Date 3.');
            }


            AuraResponse.MessageList.addAll(listMessageAux);
            return;
        }
    }

    /**
     * @description Method that validates the dates are working days (holidays and weekends are not.)
     * @author Rafael Hadama | 24/06/2020
     * @return void
     **/
    public void CheckNotWorkingDays(Map<String, Date> MapDates)
    {
        list<string> listMessageAux = new list<string>();
        Date         Date1          = MapDates.get('Date Option 1');
        Date         Date2          = MapDates.get('Date Option 2');
        Date         Date3          = MapDates.get('Date Option 3');

        for (String key:MapDates.keySet())
        {
            Date requestDate = MapDates.get(key);
            //testes date
            Time     myTime = Time.newInstance(12, 0, 0, 0);
            DateTime dt     = DateTime.newInstanceGmt(requestDate, myTime);
            system.debug('dt' + dt);
            system.debug('Datetime format ' + dt.format('EEEE'));

            if (CheckIfDateIsWeekend(requestDate))
            {
                system.debug('Date is in the weekend');
                AuraResponse.Status = 'Erro';

                if (UserLanguage == 'pt_BR')
                {
                    listMessageAux.add('A ' + key + ' é no final de semana.');
                }
                else
                {
                    listMessageAux.add('The ' + key + ' is on the weekend.');
                }
            }
            else
            {
                //validate if its a holiday
                if (CheckIfDateIsHoliday(requestDate))
                {
                    Holiday salesforceHoliday = MapDateHolidays.get(requestDate);
                    system.debug('Date is an holiday :' + salesforceHoliday);
                    AuraResponse.Status = 'Erro';

                    if (UserLanguage == 'pt_BR')
                    {
                        listMessageAux.add('A ' + key + ' é feriado.');
                    }
                    else
                    {
                        listMessageAux.add('The ' + key + ' is a holiday.');
                    }
                }
            }
        }

        if (listMessageAux.size() > 0)
        {
            AuraResponse.MessageList.addAll(listMessageAux);
        }
    }

    /**
     * @description Method that validates if the input date is in the correct range that is allowed to schedule.
     * @author Rafael Hadama | 24/06/2020
     * @return void
     **/
    public void CheckDateAntecedencia(Map<String, Date> MapDates, string InspectionType)
    {
        list<string> listMessageAux = new list<string>();

        //StaticQtdDaysRule long
        //StaticDailyHourBreak decimal

        //criar logica para encontrar primeiro dia liberado para inspecao

        //campos para se guiar
        system.debug('datetime no banco' + Datetime.now());
        system.debug('date no funcao' + Datetime.now().date());
        system.debug('Hora no contexto' + Datetime.now().hour());
        system.debug('day no contexto' + Datetime.now().day());

        //Creating date to use in this logic
        Date MinimumScheduleDate = Date.Today();



        system.debug('MinimumScheduleDate :' + MinimumScheduleDate);

        system.debug('StaticDailyHourBreak :' + StaticDailyHourBreak);
        system.debug('Datetime.now().hour() :' + Datetime.now().hour());

        if ((StaticDailyHourBreak <= Datetime.now().hour()))
        {
            system.debug('Horario de agendamento contando dia de hoje já passou: ');
            //Adding 1 more day, so the count begins tomorrow.
            MinimumScheduleDate = MinimumScheduleDate.addDays(1);
        }
        integer QtdDias  = Integer.valueOf(StaticQtdDaysRule);
        integer contagem = 0;

        system.debug('QtdDias: ' + QtdDias);

        system.debug('MinimumScheduleDate antes de iniciar while loop ' + MinimumScheduleDate);
        while (contagem <= (QtdDias))
        {
            system.debug('contagem inicio loop:' + contagem);
            if (CheckIfDateIsWeekend(MinimumScheduleDate) || CheckIfDateIsHoliday(MinimumScheduleDate))
            {
                //dia para desconsiderar - somar mais um dia ao Date MinimumScheduleDate
                system.debug('Este dia NAO é valido contador se mantem igual :  ' + MinimumScheduleDate);
                MinimumScheduleDate = MinimumScheduleDate.addDays(1);
            }
            else
            {
                system.debug('Este dia é valido:  ' + MinimumScheduleDate);
                //dia valido, contagem +1;
                contagem = contagem + 1;
                system.debug('contagem apos incremento:' + contagem);

                //validando dia seguinte e contagem.

                //validando se já pulamos a quantidade de dias parametrizados.
                if (contagem > QtdDias)

                {
                    system.debug('Nao precisa de incremento na data, chegamos ao minimo :' + MinimumScheduleDate);
                }
                else
                {
                    MinimumScheduleDate = MinimumScheduleDate.addDays(1);
                }


                //somar mais um dia ao Date MinimumScheduleDat
                //e somar uma na contagem pois este dia é válido(não é final de semana ou feriado) - Somente se o proximo dia seja valido senão.
            }
            system.debug('MinimumScheduleDate no final while loop ' + MinimumScheduleDate);
        }
        system.debug('MinimumScheduleDate após while loop ' + MinimumScheduleDate);
        system.debug('contagem apos fora do loop ' + contagem);


        for (Date inputDate:MapDates.values())
        {
            if (InspectionType == 'normal')
            {
                //Validando se os dias colocados tem a antecedencia minima.
                if (inputDate < MinimumScheduleDate)
                {
                    //Erro pois a data é invalida - anterior a hoje
                    AuraResponse.Status = 'Erro';

                    if (UserLanguage == 'pt_BR')
                    {
                        listMessageAux.add('Data ' + inputDate.format() + ' é anterior a data mínima para agendamento > ' + MinimumScheduleDate.format());
                    }
                    else
                    {
                        listMessageAux.add('Date ' + inputDate.format() + ' is earlier then the Minimum schedule date > ' + MinimumScheduleDate.format());
                    }
                }
            }

            /*else
             * {
             *  if (inputDate >= MinimumScheduleDate)
             *  {
             *      //Erro pois a data é invalida - anterior a hoje
             *      AuraResponse.Status = 'Erro';
             *
             *      if (UserLanguage == 'pt_BR')
             *      {
             *          listMessageAux.add('Data emergencial ' + inputDate.format() + ' deve ser anterior a data mínima para agendamento > ' + MinimumScheduleDate.format());
             *      }
             *      else
             *      {
             *          listMessageAux.add('Emergency Date ' + inputDate.format() + ' should be earlier to the Minimum schedule date > ' + MinimumScheduleDate.format());
             *      }
             *  }
             * }*/
        }
        if (listMessageAux.size() > 0)
        {
            AuraResponse.MessageList.addAll(listMessageAux);
        }
    }

    /**
     * @description method that validates if a holiday is configured in the date variable.
     * @author Rafael Hadama | 25/06/2020
     * @param DateTovalidate
     * @return boolean
     **/
    public boolean CheckIfDateIsHoliday(Date DateTovalidate)
    {
        boolean IsHoliday = false;

        if (MapDateHolidays.get(DateTovalidate) != Null)
        {
            IsHoliday = true;
        }
        return IsHoliday;
    }

    public boolean CheckIfDateIsWeekend(Date DateTovalidate)
    {
        boolean IsWeekend = false;

        Time     myTime = Time.newInstance(12, 0, 0, 0);
        DateTime dt     = DateTime.newInstanceGmt(DateTovalidate, myTime);

        system.debug('dt' + dt);
        system.debug('Datetime format ' + dt.format('EEEE'));

        if ((dt.format('EEEE') == 'Sunday') || (dt.format('EEEE') == 'Saturday'))
        {
            system.debug('Date is in the weekend');
            IsWeekend = true;
        }

        return IsWeekend;
    }
}