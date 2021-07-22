public with sharing class TaskBO {
    public void createMultipleUsers(List<Task> lstTask){
        List<Task> lstTaskMultiple = new List<Task>();
        Map<Id, List<Task>> mapUserVsTasks = new Map<Id, List<Task>>();
        for(Task item : lstTask){
            if(item.MultipleUser__c){ 
                if(mapUserVsTasks.containsKey(item.OwnerId)) mapUserVsTasks.get(item.OwnerId).add(item);
                else {
                    List<Task> lst = new List<Task>(); lst.add(item);
                    mapUserVsTasks.put(item.OwnerId, lst);
                }
            } 
        }
        System.debug('TaskBO.createMultipleUser --> mapUserVsTasks' + mapUserVsTasks);

        if(mapUserVsTasks.size() > 0){
            List<GroupMember> lstGroupMember = [SELECT UserOrGroupId, Id, GroupId, Group.Name FROM GroupMember WHERE GroupId IN : mapUserVsTasks.keySet()];
            List<Task> lstTaskInsert = new List<Task>();
            List<Task> lstTaskDelete = new List<Task>();
            Set<Id> setIds = new Set<Id>(); 
            System.debug('TaskBO.createMultipleUser --> lstGroupMember.size() ' + lstGroupMember.size());
            
            for(GroupMember memberUsers :lstGroupMember){
                for(Task taskItem : mapUserVsTasks.get(memberUsers.GroupId)){
                    Task taskInsert = taskItem.clone(false,false,false, false);
                    taskInsert.OwnerId = memberUsers.UserOrGroupId;
                    taskInsert.MultipleUser__c = false;
                    lstTaskInsert.add(taskInsert);
                    if(!setIds.contains(taskItem.Id)){
                        lstTaskDelete.add(taskItem);
                        setIds.add(taskItem.Id);
                    }
                }
            }
            if(lstTaskInsert.size() > 0){ 
                insert lstTaskInsert;
                BatchGenericObject bdt = new BatchGenericObject(lstTaskDelete, 'delete');
			    Database.executeBatch(bdt); 
            }
        }
    }
}