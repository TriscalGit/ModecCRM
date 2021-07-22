@RestResource(urlMapping='/RDOTransfer/v1/*')
global with sharing class RDOTransfer {
    
    @HttpPost
        global static void RDOdoPost(){
            List<String> returnTransfer = new List<String>();
            List<RDO__c> existsRDO = new List<RDO__c>();
            List<RDO__c> updateRDO = new List<RDO__c>();

            RestRequest request = RestContext.request;
            String reviewRDO = request.params.get('rdoreview');
            Blob json1 = request.requestBody;
            system.debug(reviewRDO);
            
            RDOTO rdo1 = RDOTO.parse(json1.toString());
            existsRDO = RDODAO.getRDOByNameAndShortName(String.valueOf(rdo1.NumRDO), rdo1.Vessel);
            
            if(1==1){
                if (reviewRDO == '0'){
                
                    if(existsRDO.size() == 0){
                        returnTransfer = RDOBO.getInstance().startRDOTransfer(rdo1, 'Active');
    
                        if (returnTransfer[0] == '201'){
                            RDOBO.getInstance().createOrUpdateBOM(returnTransfer[2]);
                        }
    
                        RestResponse response = RestContext.response;
                        response.addHeader('Content-Type', 'application/json');
                        response.responseBody = Blob.valueOf(returnTransfer[1]);
                        response.statusCode = Integer.valueOf(returnTransfer[0]);
    
                    }else{
                        RestResponse response = RestContext.response;
                        response.addHeader('Content-Type', 'application/json');
                        response.responseBody = Blob.valueOf('{ "RDOTransferError" : "RDO already on the system. RDO Number ' + rdo1.NumRDO + '" }');
                        response.statusCode = 401;
                    }                
                }else if(reviewRDO == '1'){
                    if(existsRDO.size() > 0){
                        for (RDO__c rdo01 : existsRDO) {
                            RDO__c singleRDO = new RDO__c();
                            singleRDO.Id = rdo01.Id;
                            singleRDO.Status__c = 'Inactive';
    
                            updateRDO.add(singleRDO);
                        }

                        if (updateRDO.size() > 0){
                            update updateRDO;
                        }
    
                        returnTransfer = RDOBO.getInstance().startRDOTransfer(rdo1, 'Adjusted');
    
                        if (returnTransfer[0] == '201'){
                            RDOBO.getInstance().createOrUpdateBOM(returnTransfer[2]);
                        }
    
                          
                        RestResponse response = RestContext.response;
                        response.addHeader('Content-Type', 'application/json');
                        response.responseBody = Blob.valueOf(returnTransfer[1]);
                        response.statusCode = Integer.valueOf(returnTransfer[0]);
    
                    }else{
                        RestResponse response = RestContext.response;
                        response.addHeader('Content-Type', 'application/json');
                        response.responseBody = Blob.valueOf('{ "RDOTransferError" : "RDO not found. RDO Number ' + rdo1.NumRDO + '" }');
                        response.statusCode = 401;
                    }
                }
            }

            
        }
}