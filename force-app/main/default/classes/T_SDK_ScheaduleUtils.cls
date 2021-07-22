/**
 * @File Name          : T_SDK_ScheaduleUtils.cls
 * @Description        :
 * @Author             : Felipe Cardozo
 * @Group              :
 * @Last Modified By   : Felipe Cardozo
 * @Last Modified On   : 13/08/2019 15:09:10
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    13/08/2019 11:11:41   Felipe Cardozo     Initial Version
 **/
public with sharing class T_SDK_ScheaduleUtils
{
	/**
	 * @description
	 * @author Felipe Cardozo | 13/08/2019
	 * @param String paSchedulableClassName
	 * @param Integer paScheaduleTimerInterval
	 * @return void
	 */
	public static void scheadule( String paSchedulableClassName, Integer paScheaduleTimerInterval )
	{
		DateTime	vaCurrentDateAndTime	= DateTime.now();
		DateTime	nextRunTime		= DateTime.now().addSeconds( 10 );

		if ( paScheaduleTimerInterval > 0 )
		{
			nextRunTime = vaCurrentDateAndTime.addMinutes( paScheaduleTimerInterval );
		}

		String vaCronString = '' +
				      nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' +
				      nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' +
				      nextRunTime.month() + ' ? ' + nextRunTime.year();

		Schedulable paSchedulableClass = (Schedulable) type.forName( paSchedulableClassName ).newInstance();
		System.schedule( paSchedulableClassName + '-' + vaCurrentDateAndTime.format(), vaCronString, paSchedulableClass );
	}


	public static void abortScheadule( SchedulableContext paSchedulableContext )
	{
		Id jobId = paSchedulableContext.getTriggerId();
		System.abortJob( jobId );
	}
}