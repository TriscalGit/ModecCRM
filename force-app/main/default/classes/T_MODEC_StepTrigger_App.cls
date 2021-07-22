/**
 * @File Name          : T_MODEC_StepTrigger_App.cls
 * @Description        :
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 07-22-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    03/07/2020   Rafael Hadama     Initial Version
 **/
public class T_MODEC_StepTrigger_App {
    /**
     * @description Method called by afterupdate trigger, to validate the correct Request TW1_Inspection_Status__c to update.
     * @author Rafael Hadama | 03/07/2020
     * @param OldStep
     * @param NewStep
     * @return void
     **/
    public static void ValidateApprovalStepInspection(TW1_Step__c OldStep, TW1_Step__c NewStep)
    {
        String RecTypeStepDateConfirmation = Schema.SObjectType.TW1_Step__c.getRecordTypeInfosByDeveloperName().get('Approval_Step_Date_Confirmation').getRecordTypeId();

        system.debug('RecTypeStepDateConfirmation ' + RecTypeStepDateConfirmation);
        T_MODEC_Request_Rep RequestREP = new T_MODEC_Request_Rep();

        if (NewStep.RecordTypeId == RecTypeStepDateConfirmation)
        {
            system.debug('Enter the ValidateApprovalStepInspection method.');

            //Validating that the step is closed, and user choose to Cancel or Reschedule Inspection
            if ((OldStep.TW1_Status__c != NewStep.TW1_Status__c) && (NewStep.TW1_Status__c == 'Closed') && ((NewStep.TW1_Inspection_Date_Confirmation__c == 'Cancel') || (NewStep.TW1_Inspection_Date_Confirmation__c == 'Reschedule') || (NewStep.TW1_Inspection_Date_Confirmation__c == 'Confirm')))
            {
                system.debug('Step was closed and InspectionDateConfirmation is cancel or reschedule, validate the date between the Inspection Scheduled Date and Now()');
                //If TW1_Inspection_Date_Confirmation__c == 'Cancel' || 'Reschedule

                //booleano para validar regra de negócio


                /*if (NewStep.TW1_Inspection_Scheduled_Date__c < NewStep.TW1_Conclusion_Date__c)
                 * {
                 *  ReproveRequest = true;
                 * }*/
                //TW1_Inspection_Scheduled_Date__c datetime field
                //TW1_Conclusion_Date__c datetime field.

                //If diferenca entre TW1_Inspection_Scheduled_Date__c e TW1_Conclusion_Date__c < 24horas || TW1_Inspection_Scheduled_Date__c < TW1_Conclusion_Date__c
                //request Inspection status - Reproved
                //senao - request TW1_Inspection_Status__c - a escolha pelo usuario ( Canceled ou Rescheduled) *fazer de para pois valores de step e request sao diferentes.
                //Querying request inspection
                TW1_Request__c InspectionToUpdate = RequestREP.getInspectionAndInspectionLines(NewStep.TW1_Request__c);
                if (NewStep.TW1_Inspection_Date_Confirmation__c != 'Confirm')
                {
                    boolean  ReproveRequest    = false;
                    Datetime ConclusionDateNow = Datetime.now();
                    system.debug('ConclusionDateNow >' + ConclusionDateNow);
                    ReproveRequest = ValidateTimeBetweenTwoDateTimes(NewStep.TW1_Inspection_Scheduled_Date__c, ConclusionDateNow);



                    if (ReproveRequest)
                    {
                        InspectionToUpdate.TW1_Inspection_Status__c = 'Reproved';
                    }
                    else
                    {
                        if (NewStep.TW1_Inspection_Date_Confirmation__c == 'Cancel')
                        {
                            InspectionToUpdate.TW1_Inspection_Status__c = 'Canceled';
                        }
                        if (NewStep.TW1_Inspection_Date_Confirmation__c == 'Reschedule')
                        {
                            InspectionToUpdate.TW1_Inspection_Status__c = 'Rescheduled';
                        }
                    }
                }
                else
                {
                    InspectionToUpdate.TW1_Inspection_Status__c = 'Inspection Scheduled';
                }

                TriggerFactory.stopRequestTrigger = false;

                update InspectionToUpdate;



                //concluition date <--> TW1_Inspection_Date_Confirmation__c
                //caso a diferenca seja menor que 24horas - request Inspection status - Reproved.

                //senão será canceled ou rescehdle, o que ele prencher. request Inspection status
            }
        }
    }

    /**
     * @description Method that validate if the difference between 2 datetimes are less than 24hours, excluding weekends and holidays.
     * Return true if difference is less than 24hours and false if not.
     * @author Rafael Hadama | 03/07/2020
     * @param InspectionScheduleDate
     * @param StepConfirmationDate
     * @return boolean
     **/
    public static boolean ValidateTimeBetweenTwoDateTimes(DateTime InspectionScheduleDate, DateTime StepConfirmationDate)
    {
        system.debug('Enter the method ValidateTimeBetweenTwoDateTimes');
        T_MODEC_ScheduleInspection_App ScheduleApp = new T_MODEC_ScheduleInspection_App();

        //ScheduleApp.MapDateHolidays = new Map<Date, Holiday>();
        //If dates are in the sameday = return true
        //Because obviously they are less than 24 hours apart.
        boolean DatesAreSameday = InspectionScheduleDate.isSameDay(StepConfirmationDate);

        if (DatesAreSameday)
        {
            system.debug('DatesAreSameday >> ' + DatesAreSameday);
            return true;
        }

        system.debug('InspectionScheduleDate . getDate: ' + InspectionScheduleDate.date());
        system.debug('StepConfirmationDate . getDate: ' + StepConfirmationDate.date());
        //If not, calculate difference in days and validate if the dates are less than 24hours apart.
        //example today is friday - and inspection date is on a monday, should return true if they are 24hours apart (considering datetime fields)
        //Checking the number of days apart
        Date ScheduleDate     = InspectionScheduleDate.date();
        Date ConfirmationDate = StepConfirmationDate.date();

        system.debug('ScheduleDate > ' + ScheduleDate);
        system.debug('ConfirmationDate > ' + ConfirmationDate);
        Integer numberDaysDue = ConfirmationDate.daysBetween(ScheduleDate);
        system.debug('numberDaysDue >' + numberDaysDue);

        if (numberDaysDue < 0)
        {
            //This means that the confirmation date is greater than the InspectionScheduleDate
            return true;
        }


        boolean TimeBetweenLessThan1day;

        if (numberDaysDue == 1)
        {
            //in this case we should valdidate the time beetwen both datetimes.
            //Meaning calculate the number of hours(minutes) from both, and see if they surpass 24hours(1440minutes)
            TimeBetweenLessThan1day = CalculateNumberofMinutesBetweenTimes(InspectionScheduleDate.time(), StepConfirmationDate.time());
            //return TimeBetweenHigherThan1day;
        }
        else
        {
            //validate if the days between are holidays or weekends
            integer numberOfValidDays   = 0;
            integer numberOfInvalidDays = 0;
            for (integer i = 1; i < numberDaysDue; i++)
            {
                system.debug('ConfirmationDate.addDays(i) >' + ConfirmationDate.addDays(i));

                if (ScheduleApp.CheckIfDateIsWeekend(ConfirmationDate.addDays(i)))
                {
                    system.debug('Date is weekend >' + ConfirmationDate.addDays(i));
                    numberOfInvalidDays = numberOfInvalidDays + 1;
                }
                else if (ScheduleApp.CheckIfDateIsHoliday(ConfirmationDate.addDays(i)))
                {
                    system.debug('Date is holiday >' + ConfirmationDate.addDays(i));
                    numberOfInvalidDays = numberOfInvalidDays + 1;
                }
                else
                {
                    numberOfValidDays = numberOfValidDays + 1;
                }
                system.debug('Teste >' + i);
            }

            system.debug('numberOfInvalidDays >' + numberOfInvalidDays);
            system.debug('numberOfValidDays >' + numberOfValidDays);

            if (numberOfValidDays >= 1)
            {
                //this means that there is a valid day between both dates
                return false;
            }

            if (numberOfValidDays == 0)
            {
                TimeBetweenLessThan1day = CalculateNumberofMinutesBetweenTimes(InspectionScheduleDate.time(), StepConfirmationDate.time());
                //return TimeBetweenHigherThan1day;
                //validate the datetime between both datetime informed.
            }
        }

        //boolean retorno = false;

        return TimeBetweenLessThan1day;
    }

    /**
     * @description Method that validates the number of minutes betweent two datetimes - returns false if is higher than 1440 minutes. true otherwise.
     * @author Rafael Hadama | 07-06-2020
     * @param ScheduleTime
     * @param ConfirmationTime
     * @return boolean
     **/
    public static boolean CalculateNumberofMinutesBetweenTimes(Time ScheduleTime, Time ConfirmationTime)
    {
        //Calculating first the number of minutos from the ConfirmationTime to midgnight
        system.debug('ConfirmationTime >' + ConfirmationTime);
        system.debug('ConfirmationTime hour >' + ConfirmationTime.hour());
        system.debug('ConfirmationTime minute >' + ConfirmationTime.minute());
        //Integer variable to calculate the number of minutes to midnight
        integer ConfirmationMinutes         = 0;
        integer ConfirmationHoursToEndOfDay = 24 - ConfirmationTime.hour();
        system.debug('ConfirmationHoursToEndOfDay >' + ConfirmationHoursToEndOfDay);
        //Adding the number of minutes
        if (ConfirmationTime.minute() > 0)
        {
            ConfirmationMinutes = 60 - ConfirmationTime.minute();
            //Removing 1hour from the math, since minutes have been calculated
            ConfirmationHoursToEndOfDay = ConfirmationHoursToEndOfDay - 1;
        }
        system.debug('ConfirmationHoursToEndOfDay apos verificar minutos >' + ConfirmationHoursToEndOfDay);
        system.debug('ConfirmationMinutes sem adicionar horas>' + ConfirmationMinutes);
        ConfirmationMinutes = ConfirmationMinutes + (ConfirmationHoursToEndOfDay * 60);
        system.debug('ConfirmationMinutes +hours>' + ConfirmationMinutes);

        //Calculate number of minutes from midgnight to ConfirmationTime
        system.debug('ScheduleTime >' + ScheduleTime);
        system.debug('ScheduleTime hour >' + ScheduleTime.hour());
        system.debug('ScheduleTime minute >' + ScheduleTime.minute());
        //integer variable to calculate number of minutes from midgnight to the time scheduled.
        integer ScheduleMinutes         = 0;
        integer ScheduleHoursToEndOfDay = ScheduleTime.hour();
        system.debug('ScheduleHoursToEndOfDay >' + ScheduleHoursToEndOfDay);
        ScheduleMinutes = ScheduleTime.minute() + (ScheduleHoursToEndOfDay * 60);
        system.debug('ScheduleMinutes >' + ScheduleMinutes);

        //If totalminutes > 1440 - means that there's more than one day between the datetimes.
        integer totalminutes = ConfirmationMinutes + ScheduleMinutes;
        system.debug('totalminutes >' + totalminutes);


        if (totalminutes >= 1440)
        {
            system.debug('totalminutes >= 1440 :' + totalminutes);
            return false;
        }
        else
        {
            system.debug('totalminutes < 1440 :' + totalminutes);
            return true;
        }
    }

    public static void ValidateIfStepIsClosed(TW1_Step__c OldStep, TW1_Step__c NewStep)
    {
        system.debug('Enter the ValidateIfStepIsClosed method.');
        T_MODEC_Request_Rep requestREP = new T_MODEC_Request_Rep();

        if(OldStep.TW1_Request__c != null && String.valueOf(OldStep.TW1_Request__c) != ''){
            TW1_Request__c relatedrequest      = requestREP.getRequestById(OldStep.TW1_Request__c);
            string         recodtypeInspection = Schema.SObjectType.TW1_Request__c.getRecordTypeInfosByDeveloperName().get('Inspection').getRecordTypeId();
            
            //validating if update is on the conclusion date field, if its true, do not block the update
            if (OldStep.TW1_Conclusion_Date__c == NewStep.TW1_Conclusion_Date__c)
            {
                if (relatedrequest.RecordtypeId == recodtypeInspection)
                {
                    if ((OldStep.TW1_Status__c == 'Closed') || (OldStep.TW1_Status__c == 'Canceled'))
                    {
                        system.debug('Step is closed, block any updates.');
                        //Validating user language to display correct message
                        String currentuserId   = UserInfo.getUserId();
                        User   currentUserInfo = [select LanguageLocaleKey from User where Id = :UserInfo.getUserId()];
                        if (currentUserInfo.LanguageLocaleKey == 'pt_BR')
                        {
                            NewStep.addError('Step está fechada mudanças não são permitidas.');
                        }
                        else
                        {
                            NewStep.addError('Step is closed changes are not allowed.');
                        }
                    }
                }
            }
        }
    }
}