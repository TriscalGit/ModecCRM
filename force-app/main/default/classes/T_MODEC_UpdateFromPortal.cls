/**
 * @description       :
 * @author            : Rafael Hadama
 * @group             :
 * @last modified on  : 10-29-2020
 * @last modified by  : Rafael Hadama
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   10-29-2020   Rafael Hadama   Initial Version
 **/
global class T_MODEC_UpdateFromPortal implements Database.Batchable<sObject> {
    //variable to hold the recordtypeId for use in query.
    global string ObjectType;
    global T_MODEC_UpdateFromPortal(String objectToUpdate)
    {
        system.debug('sobject for batch >' + objectToUpdate);
        this.ObjectType = objectToUpdate;
    }

    //Querying all documentation related to a request of recordtype Inspection and its open.
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        string query = 'SELECT Id, RecordTypeId, TW3_From_Portal__c FROM ' + ObjectType + '  where TW3_From_Portal__c = null';

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC,
                        List<Sobject>             scope)
    {
        system.debug('List of objects queried >' + scope);
        system.debug('sobject for batch >' + ObjectType);

        TriggerFactory.stopRequestTrigger = false;
        TriggerFactory.stopStepTrigger    = false;
        //update ctrlTriggers;
        if (ObjectType == 'TW1_Request__c')
        {
            list<TW1_Request__c> listreq = (list<TW1_Request__c>)scope;
            for (TW1_Request__c req:listreq)
            {
                req.TW3_From_Portal__c = 'Brazil';
            }
            system.debug('listreq >' + listreq);
            update listreq;
        }
        else if (ObjectType == 'TW1_Step__c')
        {
            system.debug('Step batch >');
            list<TW1_Step__c> liststep = (list<TW1_Step__c>)scope;
            for (TW1_Step__c req:liststep)
            {
                req.TW3_From_Portal__c = 'Brazil';
            }
            system.debug('liststep >' + liststep);
            update liststep;
        }
        else if (ObjectType == 'TW1_Documentation__c')
        {
            list<TW1_Documentation__c> listdoc = (list<TW1_Documentation__c>)scope;
            for (TW1_Documentation__c req:listdoc)
            {
                req.TW3_From_Portal__c = 'Brazil';
            }
            system.debug('listdoc >' + listdoc);
            update listdoc;
        }
        else if (ObjectType == 'TW1_Interaction__c')
        {
            list<TW1_Interaction__c> listint = (list<TW1_Interaction__c>)scope;
            for (TW1_Interaction__c req:listint)
            {
                req.TW3_From_Portal__c = 'Brazil';
            }
            system.debug('listint >' + listint);
            update listint;
        }
    }

    global void finish(Database.BatchableContext BC)
    {
        system.debug('Final do batch');
    }
}