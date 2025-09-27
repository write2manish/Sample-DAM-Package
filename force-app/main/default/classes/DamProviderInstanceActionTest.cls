@IsTest
private class DamProviderInstanceActionTest {
	@IsTest
	static void executesAction_withoutThrowing() {
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
}
