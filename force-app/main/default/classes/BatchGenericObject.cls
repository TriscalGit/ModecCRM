global class BatchGenericObject implements Database.Batchable<sObject> {
    List<sObject> lst;
    String action;

	global BatchGenericObject(List<sObject> plst, string pAction) {
		lst = plst;
        action = pAction;
    }
    	
	global List<sObject> start(Database.BatchableContext BC) {
		return lst;
    }

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		try {
            if(action == 'upsert') upsert scope;
            else if(action == 'delete') delete scope;
            if(action == 'insert') insert scope;
			
		} catch(Exception e) {
			System.debug('=> scope ' + JSON.serialize(scope));
			System.debug('=> error ' + e.getMessage());
			System.debug('=> stack ' + e.getStackTraceString());
		}
	}
	
	global void finish(Database.BatchableContext BC) {
		System.debug('>>> Finish BatchProcess =>>> SobjectBatchUpsert');
	}
}