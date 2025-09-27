public with sharing class DamProviderInstanceAdmin {
	@AuraEnabled
	public static void deleteInstance(String providerInstanceId) {
		if (String.isBlank(providerInstanceId)) {
			throw new AuraHandledException('Provider Instance Id is required');
		}
		try {
			ConnectApi.ManagedContent.deleteManagedContentProviderInstance(providerInstanceId);
			// Also remove any matching request records
			List<DAM_Provider_Instance_Request__c> reqs = [
				SELECT Id FROM DAM_Provider_Instance_Request__c WHERE Created_Instance_Id__c = :providerInstanceId
				LIMIT 200
			];
			if (!reqs.isEmpty()) {
				delete reqs;
			}
		} catch (Exception e) {
			throw new AuraHandledException('Delete failed: ' + e.getMessage());
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
}
