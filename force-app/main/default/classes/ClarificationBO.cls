public without sharing class ClarificationBO {
    private static final ClarificationBO instance = new ClarificationBO();
	public static ClarificationBO getInstance() {
		return instance;
	}
    public void finalComments(List<Clarification__c> lst, Map<Id, Clarification__c> mapOld){
        List<FinalClarification__c> lstFinnalClarification = new List<FinalClarification__c>();
        List<SPCRejectComment__c> lstSPCRejectComment = new List<SPCRejectComment__c>();          
        Map<String, String> mapNAMReproved = new Map<String, String>();
        Set<String> setNAMApproved =  new Set<String>();
        Map<String, String> mapNAMvsStatus =  new Map<String, String>();

        Integer value = 0;

        for(Clarification__c clarification : lst){
            if(!String.IsBlank(clarification.FinalComment__c)){
                if((clarification.Type__c == 'NAM' && clarification.NAMStatus__c != 'SPC Partners') || (clarification.Type__c == 'Closed Out' && clarification.ClosedOutStatus__c != 'SPC Partners')){
                    clarification.addError('You only can edit the clarification when NAM record status is "SPC Partners"');
                    clarification.FinalComment__c = null;
                }
                else if(clarification.Status__c == 'Rejected'){
                    clarification.addError('You cannot Approve a Rejected record');
                    clarification.RejectReason__c = null;
                }
                else{
                    lstFinnalClarification.add(new FinalClarification__c(
                        Clarification__c = clarification.Id,
                        NAM__c = clarification.NAM__c,
                        FinalComment__c = clarification.FinalComment__c,
                        Partner__c = clarification.Partner__c
                    ) );
                    clarification.FinalComment__c = null;
                    clarification.Status__c = 'Approved';
                    setNAMApproved.add(clarification.NAM__c);
                }
            }
            if(!String.IsBlank(clarification.RejectReason__c)){
                if((clarification.Type__c == 'NAM' && clarification.NAMStatus__c != 'SPC Partners') || (clarification.Type__c == 'Closed Out' && clarification.ClosedOutStatus__c != 'SPC Partners')){
                    clarification.addError('You only can edit the clarification when NAM record status is "SPC Partners"');
                    // clarification.RejectReason__c = null;
                }
                else if(clarification.Status__c == 'Approved'){
                    clarification.addError('You cannot Reject an Approved record');
                    // clarification.RejectReason__c = null;
                }else{
                    lstSPCRejectComment.add(new SPCRejectComment__c(
                        Clarification__c = clarification.Id,
                        NAM__c = clarification.NAM__c,
                        Comment__c = clarification.RejectReason__c,
                        Partner__c = clarification.Partner__c
                    ) );
                    mapNAMReproved.put(clarification.NAM__c, clarification.RejectReason__c);
                    clarification.RejectReason__c = null;
                    clarification.Status__c = 'Rejected';
                }
            }
            if(mapOld != null && (clarification.Status__c != mapOld.get(clarification.Id).Status__c)){
                mapNAMvsStatus.put(clarification.Partner__c + '|' + clarification.Status__c + '|' + clarification.Type__c, clarification.NAM__c);
            }
        }
        System.debug('RejectComment - ' + lstSPCRejectComment);
        if(lstSPCRejectComment.size() > 0){ 
            insert lstSPCRejectComment;

            Map<Id ,NAM__c> mapNAM = new Map<Id,NAM__c>( NamDAO.getById(mapNAMReproved.keySet()));

            List<Clarification__c> lstClarificationUpdate = new List<Clarification__c>(); 
            for(SPCRejectComment__c comment :lstSPCRejectComment){
                NAM__c nam = mapNAM.get(comment.NAM__c);
                for(Clarification__c clarification : nam.Clarifications__r){
                    if(clarification.Id != comment.Clarification__c && clarification.Status__c == 'Approved'){
                        clarification.Status__c = 'Pending';
                        switch on clarification.Partner__c {
                            when  'Mitsui' {
                                nam.MitsuiStatus__c = 'Pending'; 
                                nam.MitsuiApprovalDate__c = null;
                            }
                            when 'Marubeni' {
                                nam.MarubeniStatus__c = 'Pending';
                                nam.MarubeniApprovalDate__c = null;
                            }
                            when 'MOL' {
                                nam.MOLStatus__c = 'Pending';
                                nam.MOLApprovalDate__c = null;                                
                            }
                            when else  {
                                nam.MINCStatus__c = 'Pending';
                                nam.MINCApprovalDate__c = null; 
                            }
                        }
                        lstClarificationUpdate.add(clarification);
                    }
                }
            }
            update lstClarificationUpdate;
            update mapNAM.values();

            List<Approval.ProcessWorkitemRequest> lstReq = new List<Approval.ProcessWorkitemRequest>();
            for(ProcessInstanceWorkitem workItem  : [Select p.Id, p.ProcessInstance.TargetObjectId From ProcessInstanceWorkitem p Where p.ProcessInstance.TargetObjectId In : mapNAMReproved.keySet()]){
                
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments(mapNAMReproved.get(workItem.ProcessInstance.TargetObjectId));
                req.setAction('Reject');
                req.setWorkitemId(workItem.Id);
                lstReq.add(req);
            }

            if(lstReq.size() > 0){
                System.debug('>>> lstReq.size() >>>' + lstReq.size());
                List<Approval.ProcessResult> result =  Approval.process(lstReq);
            }
        }
        System.debug('lstFinnalClarification - ' + lstFinnalClarification);
        if(lstFinnalClarification.size() > 0){
            insert lstFinnalClarification;
            Map<Id, NAM__c> mapNAM =  new Map<Id, NAM__c>(NamDAO.getById(setNAMApproved));
            Boolean allApproved = true;
            Set<Id> setNamApproval = new Set<Id>();
            System.debug('mapNAM - ' + mapNAM);
            for(FinalClarification__c finalClar : lstFinnalClarification){
                allApproved = true;
                for(Clarification__c clarification : mapNAM.get(finalClar.NAM__c).Clarifications__r){

                    if(mapNAM.get(finalClar.NAM__c).Status__c == 'Approved' &&  clarification.type__c == 'NAM') continue;
                    if(mapNAM.get(finalClar.NAM__c).Status__c != 'Approved' &&  clarification.type__c != 'NAM') continue;
                
                    if(clarification.Id != finalClar.Clarification__c &&  clarification.Status__c != 'Approved'){
                        allApproved = false;
                        System.debug('clarification - ' + clarification + ' - ' + clarification.Status__c );
                    }
                }
                if(allApproved) setNamApproval.add(finalClar.NAM__c);
                
            }
            if(setNamApproval.size()> 0 ){
                List<Approval.ProcessWorkitemRequest> lstReq = new List<Approval.ProcessWorkitemRequest>();
                for(ProcessInstanceWorkitem workItem  : [Select p.Id, p.ProcessInstance.TargetObjectId From ProcessInstanceWorkitem p Where p.ProcessInstance.TargetObjectId In : setNamApproval]){
                    
                    Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                    req.setComments('Approved by SPC Partners');
                    req.setAction('Approve');
                    req.setWorkitemId(workItem.Id);
                    lstReq.add(req);
                }

                if(lstReq.size() > 0){
                    System.debug('>>> lstReq.size() >>>' + lstReq.size());
                    List<Approval.ProcessResult> result =  Approval.process(lstReq);
                }
            }
        }

        if(mapNAMvsStatus.size() > 0){
            Map<Id, NAM__c> mapNAM =  new Map<Id, NAM__c>(NamDAO.getById(mapNAMvsStatus.values()));
            NAM__c namEdit;
            for(string itemClarification : mapNAMvsStatus.keySet()){
                string partner = itemClarification.split('\\|')[0];
                string status = itemClarification.split('\\|')[1];
                string type = itemClarification.split('\\|')[2];
                namEdit = mapNAM.get(mapNAMvsStatus.get(itemClarification));
                switch on partner {
                    when 'Mitsui' {
                        if(type == 'NAM'){ 
                            namEdit.MitsuiStatus__c = status;
                            if(status == 'Approved') namEdit.MitsuiApprovalDate__c = Date.Today();
                        }        
                        else{ 
                            namEdit.MitsuiClosedOutStatus__c = status;
                            if(status == 'Approved') namEdit.MitsuiClosedOutApprovalDate__c = Date.Today();
                        }

                    }
                    when 'Marubeni' {
                        if(type == 'NAM'){ 
                            namEdit.MarubeniStatus__c = status; 
                            if(status == 'Approved') namEdit.MarubeniApprovalDate__c = Date.Today();    
                        }   
                        else{ 
                            namEdit.MarubeniClosedOutStatus__c = status;
                            if(status == 'Approved') namEdit.MarubeniClosedOutApprovalDate__c = Date.Today();                            
                        }
                    }
                    when 'MOL' {
                        if(type == 'NAM'){ 
                            namEdit.MOLStatus__c = status;
                            if(status == 'Approved') namEdit.MOLApprovalDate__c = Date.Today();    
                        }   
                        else{ 
                            namEdit.MOLClosedOutStatus__c = status;
                            if(status == 'Approved') namEdit.MOLClosedOutApprovalDate__c = Date.Today();                                
                        }
                    }
                    when else  {
                        if(type == 'NAM'){
                            namEdit.MINCStatus__c = status; 
                            if(status == 'Approved') namEdit.MINCApprovalDate__c = Date.Today();    
                        }       
                        else{
                            namEdit.MINCClosedOutStatus__c = status; 
                            if(status == 'Approved') namEdit.MINCClosedOutApprovalDate__c = Date.Today();
                        }                       
                    }
                }
            }
            update mapNAM.values();
        }
    }
}