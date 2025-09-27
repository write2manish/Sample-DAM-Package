@IsTest
private class DamProviderInstanceActionTest {
	@IsTest
	static void executesAction_withoutThrowing() {
		DamProviderInstanceAction.testBypassConnectApi = true;
		DamProviderInstanceAction.Request req = new DamProviderInstanceAction.Request();
		req.providerLabel = 'Unsplash';
		req.instanceName = 'Unsplash-DefaultInstance';
		req.instanceKey = 'www.salesforce.com';
		req.isDefault = true;

		Test.startTest();
		List<DamProviderInstanceAction.Response> res = DamProviderInstanceAction.createInstances(new List<DamProviderInstanceAction.Request>{ req });
		Test.stopTest();
		System.assertEquals(1, res.size());
		System.assertNotEquals(null, res[0].status);
	}

	@IsTest
	static void updateRequestRecord_onFailurePath() {
		DamProviderInstanceAction.testBypassConnectApi = false;
		// Create a placeholder request row and pass its Id to exercise update logic
		DAM_Provider_Instance_Request__c r = new DAM_Provider_Instance_Request__c(
			Instance_Name__c = 'Name',
			Provider_Label__c = 'NonexistentLabel',
			Instance_Key__c = 'key'
		);
		insert r;
		DamProviderInstanceAction.Request req = new DamProviderInstanceAction.Request();
		req.providerLabel = 'Definitely-Not-A-Provider';
		req.instanceName = 'x';
		req.instanceKey = 'k';
		req.isDefault = false;
		req.requestRecordId = r.Id;
		Test.startTest();
		List<DamProviderInstanceAction.Response> res = DamProviderInstanceAction.createInstances(new List<DamProviderInstanceAction.Request>{ req });
		Test.stopTest();
		System.assertEquals(1, res.size());
		System.assertEquals('Failed', res[0].status);
		// Verify the row was updated on failure path
		DAM_Provider_Instance_Request__c refreshed = [SELECT Status__c, Error_Message__c FROM DAM_Provider_Instance_Request__c WHERE Id = :r.Id LIMIT 1];
		System.assertEquals('Failed', refreshed.Status__c);
		System.assertNotEquals(null, refreshed.Error_Message__c);
	}

	@IsTest
	static void handlesNullIsDefaultAndNoRequestId() {
		DamProviderInstanceAction.testBypassConnectApi = false;
		DamProviderInstanceAction.Request req = new DamProviderInstanceAction.Request();
		req.providerLabel = null; // findProviderLightningComponentId will return null
		req.instanceName = 'NoDefault';
		req.instanceKey = 'k2';
		req.isDefault = null; // exercise defaulting to false
		Test.startTest();
		List<DamProviderInstanceAction.Response> res = DamProviderInstanceAction.createInstances(new List<DamProviderInstanceAction.Request>{ req });
		Test.stopTest();
		System.assertEquals(1, res.size());
		System.assertEquals('Failed', res[0].status);
	}

	@IsTest
	static void processesMultipleRequests() {
		DamProviderInstanceAction.testBypassConnectApi = true;
		DamProviderInstanceAction.Request r1 = new DamProviderInstanceAction.Request();
		r1.providerLabel = 'X';
		r1.instanceName = 'A';
		r1.instanceKey = 'a';
		DamProviderInstanceAction.Request r2 = new DamProviderInstanceAction.Request();
		r2.providerLabel = 'Y';
		r2.instanceName = 'B';
		r2.instanceKey = 'b';
		Test.startTest();
		List<DamProviderInstanceAction.Response> res = DamProviderInstanceAction.createInstances(new List<DamProviderInstanceAction.Request>{ r1, r2 });
		Test.stopTest();
		System.assertEquals(2, res.size());
	}
}
