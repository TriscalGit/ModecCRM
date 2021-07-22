/**
 * @File Name          : TriggerFactory.cls
 * @Description        :
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 07-16-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    17/06/2020   Rafael Hadama     Initial Version
 **/
global class TriggerFactory {
    //Attribute to process on bulk
    public static boolean triggerIsBulk = false;

    public static boolean validateRequesterEmail = true;

    public static boolean stopRequestTrigger = true;
	public static boolean stopStepTrigger    = true;

    //@future
    public static void createHandler(Schema.sObjectType soType)
    {
        //Recebe o handle apropriado para o objeto processado
        ITrigger handler = getHandler(soType);

        // Verifica se existe um handler registrado, caso não tenha, subimos uma exception
        if (handler == null)
        {
            throw new TriggerException('Nâo Existe uma Trigger Handler registrada para esse tipo de Objeto: ' + soType);
        }

        // Executa o handler correspondente a sua trigger
        execute(handler);
    }

    private static void execute(ITrigger handler)
    {
        // Before Trigger
        if (Trigger.isBefore)
        {
            // Call the bulk before to handle any caching of data and enable bulkification
            handler.bulkBefore();


            // Iterate through the records to be deleted passing them to the handler.
            if (Trigger.isDelete)
            {
                for (SObject so :Trigger.old)
                {
                    handler.beforeDelete(so);
                }
            }
            // Iterate through the records to be inserted passing them to the handler.
            else if (Trigger.isInsert)
            {
                for (SObject so :Trigger.new)
                {
                    handler.beforeInsert(so);
                }
            }
            // Iterate through the records to be updated passing them to the handler.
            else if (Trigger.isUpdate)
            {
                for (SObject so :Trigger.old)
                {
                    handler.beforeUpdate(so, Trigger.newMap.get(so.Id));
                }
            }
        }
        else
        {
            // Call the bulk after to handle any caching of data and enable bulkification
            handler.bulkAfter();

            // Iterate through the records deleted passing them to the handler.
            if (Trigger.isDelete)
            {
                for (SObject so :Trigger.old)
                {
                    handler.afterDelete(so);
                }
            }
            // Iterate through the records inserted passing them to the handler.
            else if (Trigger.isInsert)
            {
                for (SObject so :Trigger.new)
                {
                    System.debug('entra no afterInsert ');
                    handler.afterInsert(so);
                }
            }
            // Iterate through the records updated passing them to the handler.
            else if (Trigger.isUpdate)
            {
                for (SObject so :Trigger.old)
                {
                    handler.afterUpdate(so, Trigger.newMap.get(so.Id));
                }
            }
            else if (Trigger.isUnDelete)
            {
                for (SObject so :Trigger.new)
                {
                    handler.OnUndelete(so);
                }
            }
        }

        // Perform any post processing
        handler.andFinally();
    }

    private static ITrigger getHandler(Schema.sObjectType soType)
    {
        if (soType == TW1_Request__c.sObjectType)
        {
            return new T_MODEC_Handler_Request(Trigger.isExecuting, Trigger.size);
        }

        if (soType == Account.sObjectType)
        {
            return new T_MODEC_Handler_Account(Trigger.isExecuting, Trigger.size);
        }

        if (soType == BM_Item__c.sObjectType)
        {
            return new T_MODEC_Handler_BMItem(Trigger.isExecuting, Trigger.size);
        }

        if (soType == TW1_Inspection_Item__c.sObjectType)
        {
            return new T_MODEC_Handler_InspecItem(Trigger.isExecuting, Trigger.size);
        }

        if (soType == TW1_Step__c.sObjectType)
        {
            return new T_MODEC_Handler_Step(Trigger.isExecuting, Trigger.size);
        }
        if (soType == ContentDocument.sObjectType)
      	{
         	return new T_MODEC_Handler_ContentDocument(Trigger.isExecuting, Trigger.size);
      	}
        
        return null;
    }
}