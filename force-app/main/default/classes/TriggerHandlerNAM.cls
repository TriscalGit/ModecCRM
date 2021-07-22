public class TriggerHandlerNAM extends TriggerHandler 
{
    public override void beforeInsert(){
        NamBO.getInstance().validateNAMName(Trigger.new);
        NamBO.getInstance().updateNAMFields(Trigger.new, null);
        NamBO.getInstance().renameNAM(Trigger.new, null);
        NamBO.getInstance().validations(Trigger.new, null);
        NamBO.getInstance().adjustImageInRichText(Trigger.new);
    }
	public override void beforeUpdate(){
        
        if(!Constants.triggerNAMByPass){ 
            NamBO.getInstance().generatePDFsAutomatically(Trigger.new, (Map<Id, NAM__c>)Trigger.oldMap);
            Constants.triggerNAMByPass = true;
        }

        NamBO.getInstance().updateNAMFields(Trigger.new, (Map<Id, NAM__c>)Trigger.oldMap);        
        NamBO.getInstance().renameNAM(trigger.new, (Map<Id, NAM__c>)Trigger.oldMap);
        NamBO.getInstance().validations(Trigger.new, (Map<Id, NAM__c>)Trigger.oldMap);
    	NamBO.getInstance().adjustImageInRichText(Trigger.new);
    }
    public override void afterUpdate(){
        LogHistoryBO.createLog('NAM', 'Update', Trigger.new, Trigger.oldMap);
        // NamBO.getInstance().createReview(Trigger.new, (Map<Id, NAM__c>)Trigger.oldMap);
        NamBO.getInstance().createSPCTechMember(Trigger.new, (Map<Id, NAM__c>)Trigger.oldMap);
        NamBO.getInstance().techTeamApproved(Trigger.new, (Map<Id, NAM__c>)Trigger.oldMap);
        NamBO.getInstance().updateRelatedWorkOrderName(Trigger.new, (Map<Id, NAM__c>)Trigger.oldMap);
        NamBO.getInstance().updateSPCTechMember(Trigger.new, (Map<Id, NAM__c>)Trigger.oldMap);
    }
}