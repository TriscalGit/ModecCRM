public without sharing class NamBO {
    private static final NamBO instance = new NamBO();

	public static NamBO getInstance() {
		return instance;
	}
    
    public void adjustImageInRichText(List<NAM__c> lstNAM) {
        for (NAM__c nam : lstNAM) {
            if (nam.Description__c != null) {
            	nam.Description__c = nam.Description__c.replace('<img src', '<img width="90%" style="width: 90%;" src');
            	nam.Description__c = String.valueOf(nam.Description__c).replace('<img style=""', '<img width="90%" style="width: 90%;"');
            }
            if (nam.CounterMeasure__c != null) {
            	nam.CounterMeasure__c = nam.CounterMeasure__c.replace('<img src', '<img style="width: 90%;" src');
            	nam.Description__c = String.valueOf(nam.Description__c).replace('<img style=""', '<img width="90%" style="width: 90%;"');
            }
        }
    }
    
    public void updateNAMFields(List<NAM__c> lstNAM, Map<Id, NAM__c> mapOld){
        Decimal severalRating = 0;
        
        for(NAM__c nam : lstNAM){
            nam.CurrencyIsoCode = 'USD';

            if(nam.RatingSafety__c > nam.FutherRating__c && nam.RatingSafety__c > nam.PotentialRating__c) severalRating = nam.RatingSafety__c;
            else if(nam.PotentialRating__c > nam.RatingSafety__c && nam.PotentialRating__c > nam.FutherRating__c) severalRating = nam.PotentialRating__c;
            else severalRating = nam.FutherRating__c;
            
            if(severalRating == 0) nam.ColorRating__c = null;
            else if(severalRating == 1) nam.ColorRating__c = 'green';
            else if(severalRating == 2 && (nam.Probability__c == 'A' || nam.Probability__c == 'B')) nam.ColorRating__c = 'green';
            else if(severalRating == 2 && (nam.Probability__c == 'C' || nam.Probability__c == 'D')) nam.ColorRating__c = 'yellow';
            else if(severalRating == 3 && nam.Probability__c == 'A') nam.ColorRating__c = 'green';
            else if(severalRating == 3 && (nam.Probability__c == 'B' || nam.Probability__c == 'C')) nam.ColorRating__c = 'yellow';
            else if(severalRating == 3 && nam.Probability__c == 'D') nam.ColorRating__c = 'red';
            else if(severalRating == 4 && (nam.Probability__c == 'C' || nam.Probability__c == 'D')) nam.ColorRating__c = 'red';
            else if(severalRating == 4 && (nam.Probability__c == 'A' || nam.Probability__c == 'B')) nam.ColorRating__c = 'yellow';
            else nam.ColorRating__c = 'red';

            if(!String.IsBlank(nam.ReasonWithoutAllTechSupport__c) && mapOld.get(nam.Id).ReasonWithoutAllTechSupport__c != nam.ReasonWithoutAllTechSupport__c){
                nam.TechSpc__c = UserInfo.getUserId();
            }

            if(!String.IsBlank(nam.ReasonWithoutAllTechSupportCO__c) && mapOld.get(nam.Id).ReasonWithoutAllTechSupportCO__c != nam.ReasonWithoutAllTechSupportCO__c){
                nam.TechSpcCO__c = UserInfo.getUserId();
            }
        }
    }
    public void techTeamApproved(List<NAM__c> lstNAM, Map<Id, Nam__c> mapOld){
        Set<String> setNAMIds = new Set<String>();

        for(NAM__c nam : lstNAM){
            if((nam.Status__c == 'Tech Team' && mapOld.get(nam.Id).Status__c != nam.Status__c) || 
               (nam.ClosedOutStatus__c == 'Tech Team' && mapOld.get(nam.Id).ClosedOutStatus__c != nam.ClosedOutStatus__c)){
                setNAMIds.add(nam.Id);
            }
        }
        List<NAM__c> lstNamDB = NamDAO.getById(setNAMIds);
        List<Clarification__c> lstClarificationUpdate = new List<Clarification__c>();
        
        for(NAM__c nam : lstNamDB){
            for(Clarification__c clarification : nam.Clarifications__r){
                if(nam.Status__c == 'Approved' &&  clarification.type__c == 'NAM') continue;
                if(nam.Status__c != 'Approved' &&  clarification.type__c != 'NAM') continue;
                clarification.sendPEMEmail__c = true;
                lstClarificationUpdate.add(clarification);
            }
        }
        if(lstClarificationUpdate.size() > 0) update lstClarificationUpdate;
    }
    public void validations(List<NAM__c> lstNAM, Map<Id, NAM__c> mapOld){
        Set<String> setNamName = new Set<String>();
        for(NAM__c nam :lstNAM){
            setNamName.add(nam.NameWithoutRevision__c);
        }
        Id userId = UserInfo.getUserId();
        Map<String, NAM__c> mapNameVsNAM = new Map<String, NAM__c>();
        Evmd.Collection.loadMap(mapNameVsNAM, 'NameWithoutRevision__c', NamDAO.getByName(setNamName));

        for(NAM__c item : lstNAM){
            if(item.Status__c == 'Cancel' && mapOld != null && mapOld.get(item.Id).Status__c != 'AMC') item.addError('NAM can only be cancelled by AMC');
            if(item.Status__c == 'SPC Partners' && item.TotalSupportedPending__c > 0 && String.IsBlank(item.ReasonWithoutAllTechSupport__c)) item.addError('You cannot approve the NAM without all tech members support');
            if(item.Status__c == 'SPC Partners' && String.isBlank(item.TechFinalComment__c)) item.addError('You cannot approve the NAM without inform the Tech Final Comment field');
            if(item.Status__c == 'SPC Partners' && String.isBlank(item.RCA__c)) item.addError('You cannot approve the NAM without inform the RCA field');
            if(item.Status__c == 'SPC Partners' && mapOld.get(item.Id).Status__c == 'Tech Team' && userId != item.ResponsibleForNAM__c) item.addError('Only the user Responsible for NAM can approve this record');            
            if(item.ClosedOutStatus__c == 'SPC Partners' && item.TotalClosedOutSupportedPending__c > 0 && String.IsBlank(item.ReasonWithoutAllTechSupportCO__c)) item.addError('You cannot approve the NAM without all tech members support');
            if(item.ClosedOutStatus__c == 'SPC Partners' && mapOld.get(item.Id).ClosedOutStatus__c == 'Tech Team' &&  userId != item.ResponsibleForClosedOut__c) item.addError('Only the user Responsible for Closed Out can approve this record');
            if(mapNameVsNAM.containsKey(item.NameWithoutRevision__c)){
                if(mapNameVsNAM.get(item.NameWithoutRevision__c).Id != item.Id) item.addError('A NAM with the same name ' +item.Name +' was found in the database! Try a different one');
            }
        }
    }
    public void renameNAM(List<NAM__c> lstNAM, Map<Id, NAM__c> mapOld){
        Set<String> setVessels = new Set<String>();
        Map<String, String> mapIdVsName = new Map<String, String>();
        for(NAM__c nam : lstNAM){
            nam.Revision__c = (nam.Revision__c == null? 0 : nam.Revision__c ); 
            // if(!nam.ByPassRename__c){
                Integer index = nam.Name.indexOf('_r');
                string namName = nam.Name;
                if(index != -1) namName = namName.subString(0, index);
                string namRevision;

                if(mapOld != null && nam.Revision__c != mapOld.get(nam.Id).Revision__c && (nam.Status__c != 'AMC' && nam.ClosedOutStatus__c != 'Execution')){
                     nam.addError('You only can create a revision in the AMC stages');
                }
                else if(mapOld != null && nam.RevisionCO__c != mapOld.get(nam.Id).RevisionCO__c && nam.ClosedOutStatus__c != 'Execution')  nam.addError('You only can create a revision in the Execution stage');
                else if(mapOld == null || nam.Revision__c != mapOld.get(nam.Id).Revision__c) {
                    nam.Name = namName + '_r' + nam.Revision__c;
                    nam.Status__c = 'AMC';
                    nam.ClosedOutStatus__c = null;
                    nam.RevisionCO__c = 0;
                    if(mapOld != null) mapIdVsName.put(nam.Id, mapOld.get(nam.Id).Name + ' - ' + mapOld.get(nam.Id).Subject__c);
                    nam.NameWithoutRevision__c = namName;
                }
                else if(mapOld != null && (nam.RevisionCO__c != mapOld.get(nam.Id).RevisionCO__c) || (nam.Status__c == 'Approved' && nam.ClosedOutStatus__c == 'Execution' && mapOld.get(nam.Id).Status__c != 'Approved')) {
                    String namNAMRevisionName = nam.Name;
                    Integer indexCO = nam.Name.indexOf('-', index);
                    if(indexCO != -1)  namNAMRevisionName = namNAMRevisionName.subString(0, indexCO);
                    mapIdVsName.put(nam.Id, mapOld.get(nam.Id).Name + ' - ' + mapOld.get(nam.Id).Subject__c);
                    renameFuture(nam.Id, namNAMRevisionName + '-' + String.valueOf(Integer.valueOf(nam.RevisionCO__c)), namName);
                }
            //}    
        }
        if(mapIdVsName.size() > 0) GeneratePdfController.savePdfFuture(JSON.serialize(mapIdVsName), 'NAM__c'); 
    }
    @future
    static void renameFuture(Id namId, string nameName, string namWithoutRevision){
        NAM__c namObj = new NAM__c(Id = namId, Name = nameName,NameWithoutRevision__c = namWithoutRevision );
        update namObj;
    } 

    public void generatePDFsAutomatically(List<NAM__c> lstNAM, Map<Id, NAM__c> mapOld){
		Map<String, List<String>> mapVesselVsContacts = new Map<String, List<String>>();
		Map<String, List<String>> mapIdVsContacts = new Map<String, List<String>>();
        Map<String, String> mapIdVsName = new Map<String, String>();
        Map<String, String> mapIdVsWOName = new Map<String, String>();

        for(NAM__c nam : lstNAM){
            if(
                (nam.Status__c == 'Tech Team' && mapOld.get(nam.Id).Status__c == 'PEM') || 
                (nam.ClosedOutStatus__c == 'Tech Team' && mapOld.get(nam.Id).ClosedOutStatus__c == 'PEM') ||
                (nam.Status__c == 'Approved' &&  mapOld.get(nam.Id).Status__c != nam.Status__c) ||
                (nam.ClosedOutStatus__c == 'Approved' && mapOld.get(nam.Id).ClosedOutStatus__c != nam.ClosedOutStatus__c)){ 
				
                mapIdVsName.put(nam.Id, mapOld.get(nam.Id).Name + ' - ' + nam.Subject__c);
				mapVesselVsContacts.put(nam.Vessel__c, new List<String>());
            }
		}
		
		for(VesselContact__c objVesselContact : VesselContactDAO.getByVesselId(mapVesselVsContacts.keySet())) mapVesselVsContacts.get(objVesselContact.Vessel__c).add(objVesselContact.Contact__c);
        Map<String, String> mapNAMvsName = new Map<String, String>();
        String namName;
		for(NAM__c nam : lstNAM){
            if(mapIdVsName.containsKey(nam.Id)){ 
				mapIdVsContacts.put(nam.Id, mapVesselVsContacts.get(nam.Vessel__c));
                mapNAMvsName.put(nam.Id, mapOld.get(nam.Id).Name + ' - ' + nam.Subject__c );
                namName = mapOld.get(nam.Id).Name;
			}
		}
        System.Debug('NAMBO.generatePDFsAutomatically -> mapIdVsName.size(): ' + mapIdVsName.size());
        System.Debug('NAMBO.generatePDFsAutomatically -> mapVesselVsContacts: ' + mapVesselVsContacts);
        System.Debug('NAMBO.generatePDFsAutomatically -> mapIdVsContacts: ' + mapIdVsContacts);

        if(mapIdVsName.size() > 0){

            System.Debug('NAMBO.generatePDFsAutomatically -> (mapIdVsName) ::: ' + mapIdVsName);

            GeneratePdfController.savePdfFuture(JSON.serialize(mapIdVsName), 'NAM__c');
            // if(mapIdVsContacts.size() > 0)  EmailUtil.sendEmailsWithPdf('NamReportPdf', 'PEMApproval', JSON.serialize(mapIdVsContacts), JSON.serialize(mapNAMvsName));
            if(mapIdVsContacts.size() > 0){
                System.debug('>> EmailUtil.sendNAMEmailsPdf >>');  
                EmailUtil.sendNAMEmailsPdf(JSON.serialize(mapIdVsContacts), JSON.serialize(mapNAMvsName), namName);
            }

            List<NAM__c> lstNamBD = NamDAO.getById(mapIdVsName.keySet()); 
            for(NAM__c nam : lstNamBD){
                for(WorkOrder wo : nam.WorkOrders__r)  mapIdVsWOName.put(wo.Id, wo.WorkOrder__c);
            }
            GeneratePdfController.savePdfFuture(JSON.serialize(mapIdVsWOName), 'WorkOrder');
        }
    }
    public void createSPCTechMember(List<NAM__c> lstNAM, Map<Id, NAM__c> mapOld){
        Set<Id> setIds = new Set<Id>();
        List<NAM__c> lstNAMUpdate = new List<NAM__c>();
        Map<Id, String> mapSupportedType = new Map<Id, String>();

        for(NAM__c nam : lstNAM){
            if(nam.ClarificationCreated__c && !mapOld.get(nam.Id).ClarificationCreated__c){
                lstNAMUpdate.add(nam);
                mapSupportedType.put(nam.Id, 'NAM');
            }
            else if(nam.ClosedOutClarificationCreated__c && !mapOld.get(nam.Id).ClosedOutClarificationCreated__c){
                lstNAMUpdate.add(nam);
                mapSupportedType.put(nam.Id, 'Closed Out');
            }
        }

        if(lstNAMUpdate.size() > 0){
            List<GroupMember> lstMembers = [SELECT UserOrGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.DeveloperName = 'SPCTechTeam'];
            List<TechnicalMemberSupport__c> lstTechMember = new List<TechnicalMemberSupport__c>();
            List<Clarification__c> lstClarification = new List<Clarification__c>();
            List<String> lstSPCPartners = new List<String> {'Mitsui', 'Marubeni', 'MOL', 'MINC' };
            for(NAM__c nam : lstNAMUpdate){
                for(GroupMember groupMember : lstMembers){
                    lstTechMember.add( new TechnicalMemberSupport__c(
                        NAM__c = nam.Id, 
                        Responsible__c = groupMember.UserOrGroupId,
                        Status__c = 'Pending',
                        Type__c = mapSupportedType.get(nam.Id)
                    ));
                }
                for(string partner : lstSPCPartners){
                    lstClarification.add( new Clarification__c(
                        NAM__c = nam.Id, 
                        Status__c = 'Pending',
                        Partner__c = partner,
                        Type__c = mapSupportedType.get(nam.Id)
                    ));
                }
            }
            if(lstTechMember.size() > 0) insert lstTechMember;
            if(lstClarification.size() > 0) insert lstClarification;
        }
    }

    public void updateSPCTechMember(List<NAM__c> lstNAM, Map<Id, NAM__c> mapOld){
        Set<String> setNAMIds = new Set<String>();
        List<TechnicalMemberSupport__c> lstTms = new List<TechnicalMemberSupport__c>();

        for(NAM__c nam : lstNAM){
            if((mapOld.get(nam.Id).Revision__c   != null && mapOld.get(nam.Id).Revision__c   != nam.Revision__c) || 
               (mapOld.get(nam.Id).RevisionCO__c != null && mapOld.get(nam.Id).RevisionCO__c != nam.RevisionCO__c)){
                setNAMIds.add(nam.Id);
            }
        }
        if(setNAMIds.size() > 0){
            List<NAM__c> lstNamWithTechSupport = NamDAO.getById(setNAMIds);
            if(lstNamWithTechSupport.size() > 0) {
                for(NAM__c namWithSupport : lstNamWithTechSupport){
                    if(namWithSupport.TechTeamsSupports__r.size() > 0){
                        for(TechnicalMemberSupport__c tms : namWithSupport.TechTeamsSupports__r){
                            if(namWithSupport.Phase__c == 'NAM'){
                                tms.Status__c = 'Pending';
                                tms.Description__c = '';
                                lstTms.add(tms);
                            }else{
                                if(tms.Type__c == namWithSupport.Phase__c){
                                    tms.Status__c = 'Pending';
                                    tms.Description__c = '';
                                    lstTms.add(tms);
                                }
                            }
                        }
                    }
                }
                if(lstTms.size() > 0)  update lstTms;
            }
        }
    }
    
    public void validateNAMName(List<NAM__c> lstNAM){
        for (NAM__c nam : lstNAM) {
            String [] namName = nam.Name.split('-');

            if(namName.size() <> 4){
                nam.addError('NAM number format has to be: NAM-MVxx-xx-xxx');
            }else{
                Boolean part0 = namName[0].length() <> 3 || namName[0] != 'NAM';
                Boolean part1 = namName[1].length() <> 4 || namName[1].substring(0, 2) != 'MV';
                Boolean part2 = namName[2].length() <> 2;
                Boolean part3 = namName[3].length() <> 3;

                if(part0 || part1 || part2 || part3 ) nam.addError('NAM number format has to be: NAM-MVxx-xx-xxx');
            }
        }
    }

    public void updateRelatedWorkOrderName(List<NAM__c> lstNAM, Map<Id, NAM__c> mapOld){
        Set<Id> setNAMIds = new Set<Id>();
        for(NAM__c nam : lstNAM){
            if(nam.Revision__c != mapOld.get(nam.Id).Revision__c) setNAMIds.add(nam.Id);
        }
        
        if(!setNAMIds.isEmpty()){
            List<WorkOrder> woLst = WorkOrderDAO.getByNAMId(setNAMIds);
            if(!woLst.isEmpty()){
                for(WorkOrder wo : woLst){
                    Integer index = wo.WorkOrder__c.indexOf('_r'); // WO-MV27-00-006-2_r0 -> index = 16
                    string woName = wo.WorkOrder__c.substring(0, index); // WO-MV27-00-006-2
                    wo.WorkOrder__c = woName + '_r'+ wo.NAMRevision__c;
                }
                update woLst;
            }
        }
    }
}