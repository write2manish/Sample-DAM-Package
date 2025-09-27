public with sharing class DamProviderInstanceAdmin {
	@TestVisible private static Boolean testBypassConnectApi = false;
	@AuraEnabled
	public static void deleteInstance(String providerInstanceId) {
		if (String.isBlank(providerInstanceId)) {
			throw new AuraHandledException('Provider Instance Id is required');
		}
		try {
			if (!testBypassConnectApi) {
				ConnectApi.ManagedContent.deleteManagedContentProviderInstance(providerInstanceId);
			}
			// Also remove any matching request records
			List<DAM_Provider_Instance_Request__c> reqs = [
				SELECT Id FROM DAM_Provider_Instance_Request__c WHERE Created_Instance_Id__c = :providerInstanceId
				LIMIT 200
			];
			if (!reqs.isEmpty()) {
				delete reqs;
			}
		} catch (Exception e) {
			// Provide actionable guidance for common failure scenarios
			String guidance = 'Delete failed. One possible reason is that the provider instance still '
				+ 'has content media assets associated with it. Delete those content/media assets first, '
				+ 'then retry. Refer to the Managed Content delete API documentation for details. '
				+ 'Details: ' + e.getMessage();
			throw new AuraHandledException(guidance);
		}
	}

	public class InstanceOption {
		@AuraEnabled public String id;
		@AuraEnabled public String label;
	}

	public class ProviderInstance {
		@AuraEnabled public String id;           // providerInstanceId
		@AuraEnabled public String name;         // instance name
		@AuraEnabled public String providerLabel;
		@AuraEnabled public Boolean isDefault;
	}

	@AuraEnabled(cacheable=true)
	public static List<InstanceOption> listCreatedInstances() {
		List<InstanceOption> options = new List<InstanceOption>();
		for (DAM_Provider_Instance_Request__c r : [
			SELECT Instance_Name__c, Provider_Label__c, Created_Instance_Id__c, Status__c
			FROM DAM_Provider_Instance_Request__c
			WHERE Created_Instance_Id__c != null AND Status__c = 'Succeeded'
			ORDER BY LastModifiedDate DESC
			LIMIT 200
		]) {
			InstanceOption o = new InstanceOption();
			o.id = r.Created_Instance_Id__c;
			o.label = r.Instance_Name__c + ' (' + r.Provider_Label__c + ')';
			options.add(o);
		}
		return options;
	}

	@AuraEnabled(cacheable=true)
	public static List<ProviderInstance> listProviderInstances(String providerLabel) {
		List<ProviderInstance> out = new List<ProviderInstance>();
		if (testBypassConnectApi) {
			// Simulate one instance for tests
			ProviderInstance pi = new ProviderInstance();
			pi.id = 'prov-test-001';
			pi.name = 'Test';
			pi.providerLabel = (String.isBlank(providerLabel) ? 'Unsplash' : providerLabel);
			pi.isDefault = true;
			out.add(pi);
			return out;
		}
		ConnectApi.ManagedContentProviderCollection col = ConnectApi.ManagedContent.getManagedContentProviders();
		if (col == null || col.providers == null) return out;
		for (ConnectApi.ManagedContentProvider p : col.providers) {
			if (providerLabel != null && providerLabel != '' && p.label != providerLabel) continue;
			if (p.providerInstances == null) continue;
			for (ConnectApi.ManagedContentProviderInstance inst : p.providerInstances) {
				ProviderInstance pi = new ProviderInstance();
				pi.id = inst.providerInstanceId;
				pi.name = inst.name;
				pi.providerLabel = p.label;
				pi.isDefault = inst.isDefault;
				out.add(pi);
			}
		}
		return out;
	}

	@AuraEnabled
	public static String deleteInstanceWithMessage(String providerInstanceId) {
		if (String.isBlank(providerInstanceId)) {
			return 'Delete failed: Provider Instance Id is required';
		}
		try {
			if (!testBypassConnectApi) {
				ConnectApi.ManagedContent.deleteManagedContentProviderInstance(providerInstanceId);
			}
			// Clean up related request records if any
			List<DAM_Provider_Instance_Request__c> reqs = [
				SELECT Id FROM DAM_Provider_Instance_Request__c WHERE Created_Instance_Id__c = :providerInstanceId LIMIT 200
			];
			if (!reqs.isEmpty()) delete reqs;
			return 'OK';
		} catch (Exception e) {
			String guidance = 'Delete failed. One possible reason is that the provider instance still has content/media assets associated with it. '
				+ 'Delete those assets first, then retry. Refer to the Managed Content delete API documentation. '
				+ 'Details: ' + e.getMessage();
			return guidance;
		}
	}
}
