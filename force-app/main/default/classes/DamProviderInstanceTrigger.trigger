trigger DamProviderInstanceTrigger on DAM_Provider_Instance_Request__c (after insert) {
	List<DamProviderInstanceAction.Request> batch = new List<DamProviderInstanceAction.Request>();
	for (DAM_Provider_Instance_Request__c r : Trigger.new) {
		DamProviderInstanceAction.Request req = new DamProviderInstanceAction.Request();
		req.providerLabel = r.Provider_Label__c;
		req.instanceName = r.Instance_Name__c;
		req.instanceKey = r.Instance_Key__c;
		req.isDefault = r.Is_Default__c;
		req.requestRecordId = r.Id;
		batch.add(req);
	}
	DamProviderInstanceAction.createInstances(batch);
}
