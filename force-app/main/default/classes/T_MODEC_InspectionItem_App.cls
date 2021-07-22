/**
 * @File Name          : T_MODEC_InspectionItem_App.cls
 * @Description        :
 * @Author             : Rafael Hadama
 * @Group              :
 * @Last Modified By   : Rafael Hadama
 * @Last Modified On   : 07-13-2020
 * @Modification Log   :
 * Ver       Date            Author              Modification
 * 1.0    29/06/2020   Rafael Hadama     Initial Version
 **/
public class T_MODEC_InspectionItem_App {
    /**
     * @description Method that validate changes in the Inspection Item Status, and update the related Request if all itens have Status != from null.
     * @author Rafael Hadama | 16/06/2020
     * @param OldInspecItem
     * @param NewInspecItem
     * @return void
     **/
    public static void CheckAllInspectionItens(TW1_Inspection_Item__c OldInspecItem, TW1_Inspection_Item__c NewInspecItem)
    {
        T_MODEC_InspecItem_REP InspectionItemREP = new T_MODEC_InspecItem_REP();
        T_MODEC_Request_Rep    RequestREP        = new T_MODEC_Request_Rep();

        if ((OldInspecItem.TW1_Status__c != NewInspecItem.TW1_Status__c) || (OldInspecItem.TW1_Inspection_Appraisal__c != NewInspecItem.TW1_Inspection_Appraisal__c) || (OldInspecItem.TW1_Rejection_Reason__c != NewInspecItem.TW1_Rejection_Reason__c) || (OldInspecItem.TW1_Item_Description__c != NewInspecItem.TW1_Item_Description__c))
        {
            system.debug('Status or Inspection Appraisal or Rejection Reason was modified in Inspection Item.');
            //Querying all inspection itens related to the request
            list<TW1_Inspection_Item__c> listInspecItens = InspectionItemREP.getInspectionItensbyRequestId(NewInspecItem.TW1_Request__c);
            system.debug('List of Inspection Itens:' + listInspecItens);

            //Validating if all Itens status were analized.
            //If not the boolean below is false.
            boolean AllItensStatusAnalyzed = true;

            //referente TW1_All_Inspection_Items_Status__c
            String AllInpectionItemStatus = '';


            //Validating if all Itens status are Approved or Previously Approved.
            //If not the boolean below is false.
            //boolean AllItensStatusApproved = true;

            string AllAppraisals = '';
            for (TW1_Inspection_Item__c InspecItem : listInspecItens)
            {
                if (InspecItem.TW1_Status__c == null)
                {
                    AllItensStatusAnalyzed = false;
                }


                //Preenchend campo para envio no email
                AllAppraisals += 'Inspection Item: ' + InspecItem.TW1_Item_Description__c + '\n';
                if (InspecItem.TW1_Status__c == 'Rejected')
                {
                    AllAppraisals += 'Status: ' + InspecItem.TW1_Status__c + '\n';
                    AllAppraisals += 'Rejection Reason: ' + InspecItem.TW1_Rejection_Reason__c + '\n';
                }
                else
                {
                    AllAppraisals += 'Status: ' + InspecItem.TW1_Status__c + '\n';
                }
                AllAppraisals += 'Inspection Appraisal: ' + InspecItem.TW1_Inspection_Appraisal__c + '\n \n';


                String AllInpectionItemStatusAux = '';
                //Validando status para atualizar TW1_All_Inspection_Items_Status__c field in request.
                if ((InspecItem.TW1_Status__c == 'Approved') || (InspecItem.TW1_Status__c == 'Previously Approved'))
                {
                    AllInpectionItemStatusAux = 'Approved';
                }
                if (InspecItem.TW1_Status__c == 'Approved with Restriction')
                {
                    AllInpectionItemStatusAux = 'Approved with Restriction';
                }
                if (InspecItem.TW1_Status__c == 'Rejected')
                {
                    AllInpectionItemStatusAux = 'Rejected';
                }

                //Verificando que caso existe 1 item - rejected - resultado status request : Rejected
                //Ou se existe nenhuma reject, e pelo menos uma Approved with Restriction : resultado status request :Approved with Restriction

                if (AllInpectionItemStatusAux == 'Rejected')
                {
                    AllInpectionItemStatus = 'Rejected';
                }
                else if (AllInpectionItemStatusAux == 'Approved with Restriction')
                {
                    if (AllInpectionItemStatus != 'Rejected')
                    {
                        AllInpectionItemStatus = 'Approved with Restriction';
                    }
                }
                else if (AllInpectionItemStatusAux == 'Approved')
                {
                    if ((AllInpectionItemStatus != 'Rejected') && (AllInpectionItemStatus != 'Approved with Restriction'))
                    {
                        AllInpectionItemStatus = 'Approved';
                    }
                }
            }

            system.debug('AllItensStatusAnalyzed >' + AllItensStatusAnalyzed);
            system.debug('AllAppraisals >' + AllAppraisals);


            //Querying related Request -- atualizar buscando agora o - TW1_All_Inspection_Items_Status__c
            TW1_Request__c InspectionRequest = RequestREP.getRequestById(NewInspecItem.TW1_Request__c);
            if (AllItensStatusAnalyzed == true)
            {
                InspectionRequest.TW1_All_Inspection_Items_Status_Filled__c = true;
            }
            else
            {
                InspectionRequest.TW1_All_Inspection_Items_Status_Filled__c = false;
            }

            system.debug('Atribuindo o status da inspection na request>' + AllInpectionItemStatus);
            InspectionRequest.TW1_All_Inspection_Items_Status__c = AllInpectionItemStatus;
            InspectionRequest.TW1_All_Appraisal__c = AllAppraisals;

            system.debug('Req TW1_All_Inspection_Items_Status_Filled>' + InspectionRequest.TW1_All_Inspection_Items_Status_Filled__c);
            system.debug('Req TW1_All_Appraisal__c>' + InspectionRequest.TW1_All_Appraisal__c);
            //Adding stopRequestTrigger = false, so the Request trigger does not run
            TriggerFactory.stopRequestTrigger = false;

            update InspectionRequest;
        }
    }
}