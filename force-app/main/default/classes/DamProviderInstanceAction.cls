public with sharing class DamProviderInstanceAction {
	@TestVisible private static Boolean testBypassConnectApi = false;
	public class Request {
		@InvocableVariable(required=true) public String providerLabel;
		@InvocableVariable(required=true) public String instanceName;
		@InvocableVariable(required=true) public String instanceKey;
		@InvocableVariable public Boolean isDefault;
		@InvocableVariable public Id requestRecordId;
	}

	public class Response {
		@InvocableVariable public String status;
		@InvocableVariable public String createdInstanceId;
		@InvocableVariable public String errorMessage;
	}

	@InvocableMethod(label='Create Managed Content Provider Instance')
	public static List<Response> createInstances(List<Request> requests) {
		List<Response> results = new List<Response>();
		for (Request r : requests) {
			Response res = new Response();
			try {
				if (testBypassConnectApi) {
					// Simulate a successful create in tests without calling ConnectApi
					res.status = 'Succeeded';
					res.createdInstanceId = 'prov-test-001';
					if (r.requestRecordId != null) {
						DAM_Provider_Instance_Request__c upd = new DAM_Provider_Instance_Request__c(
							Id = r.requestRecordId,
							Status__c = 'Succeeded',
							Created_Instance_Id__c = res.createdInstanceId,
							Error_Message__c = null
						);
						update upd;
					}
					results.add(res);
					continue;
				}

				String providerLightningComponentId = findProviderLightningComponentId(r.providerLabel);
				if (String.isBlank(providerLightningComponentId)) {
					res.status = 'Failed';
					res.errorMessage = 'Provider label not found: ' + r.providerLabel;
				} else {
					ConnectApi.ManagedContentProviderInput input = new ConnectApi.ManagedContentProviderInput();
					input.name = r.instanceName;
					input.instanceKey = r.instanceKey;
					input.isDefault = (r.isDefault == null) ? false : r.isDefault;
					input.providerLightningComponentId = providerLightningComponentId;

					ConnectApi.ManagedContentProviderInstance created =
						ConnectApi.ManagedContent.createManagedContentProvider(input);

					res.status = 'Succeeded';
					res.createdInstanceId = created.providerInstanceId;

					if (r.requestRecordId != null) {
						DAM_Provider_Instance_Request__c upd = new DAM_Provider_Instance_Request__c(
							Id = r.requestRecordId,
							Status__c = 'Succeeded',
							Created_Instance_Id__c = created.providerInstanceId,
							Error_Message__c = null
						);
						update upd;
					}
				}
			} catch (Exception e) {
				res.status = 'Failed';
				res.errorMessage = e.getMessage();
				if (r.requestRecordId != null) {
					DAM_Provider_Instance_Request__c upd = new DAM_Provider_Instance_Request__c(
						Id = r.requestRecordId,
						Status__c = 'Failed',
						Error_Message__c = e.getMessage()
					);
					update upd;
				}
			}
			results.add(res);
		}
		return results;
	}

	private static String findProviderLightningComponentId(String providerLabel) {
		ConnectApi.ManagedContentProviderCollection col =
			ConnectApi.ManagedContent.getManagedContentProviders();
		if (col == null || col.providers == null) return null;
		for (ConnectApi.ManagedContentProvider p : col.providers) {
			if (providerLabel != null && providerLabel.equals(p.label)) {
				return p.providerLightningComponentId;
			}
		}
		return null;
	}
}
