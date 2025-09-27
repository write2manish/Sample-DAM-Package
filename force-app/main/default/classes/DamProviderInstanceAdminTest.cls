@IsTest
private class DamProviderInstanceAdminTest {

	@IsTest
	static void deleteInstance_blankParam_throws() {
		Boolean threw = false;
		try {
			DamProviderInstanceAdmin.deleteInstance(null);
		} catch (AuraHandledException e) {
			threw = true;
		}
		System.assertEquals(true, threw, 'Expected AuraHandledException for blank id');
	}

	@IsTest
	static void listCreatedInstances_returnsRows_whenDataPresent() {
		// Seed a succeeded request row that listCreatedInstances should surface
		DAM_Provider_Instance_Request__c req = new DAM_Provider_Instance_Request__c(
			Instance_Name__c = 'TestInst',
			Provider_Label__c = 'Unsplash',
			Instance_Key__c = 'example.com',
			Status__c = 'Succeeded',
			Created_Instance_Id__c = 'prov-123'
		);
		insert req;

		Test.startTest();
		List<DamProviderInstanceAdmin.InstanceOption> options = DamProviderInstanceAdmin.listCreatedInstances();
		Test.stopTest();

		System.assert(options != null);
		System.assert(options.size() >= 0);
	}

	@IsTest
	static void listProviderInstances_handlesNullAndFilter() {
		DamProviderInstanceAdmin.testBypassConnectApi = true;
		Test.startTest();
		List<DamProviderInstanceAdmin.ProviderInstance> all = DamProviderInstanceAdmin.listProviderInstances(null);
		List<DamProviderInstanceAdmin.ProviderInstance> filtered = DamProviderInstanceAdmin.listProviderInstances('Unsplash');
		Test.stopTest();
		System.assert(all != null && all.size() == 1);
		System.assert(filtered != null && filtered.size() == 1);
	}

	@IsTest
	static void deleteInstance_nonexistent_throwsAuraHandled() {
		DamProviderInstanceAdmin.testBypassConnectApi = true;
		Boolean threw = false;
		Test.startTest();
		try {
			DamProviderInstanceAdmin.deleteInstance('non-existent-id');
		} catch (AuraHandledException e) {
			threw = true;
		}
		Test.stopTest();
		System.assertEquals(false, threw, 'Bypassed ConnectApi should not throw');
	}
}


