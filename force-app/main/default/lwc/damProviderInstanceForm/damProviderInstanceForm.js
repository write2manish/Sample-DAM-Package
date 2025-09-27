import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import REQUEST_OBJECT from '@salesforce/schema/DAM_Provider_Instance_Request__c';
import PROVIDER_LABEL from '@salesforce/schema/DAM_Provider_Instance_Request__c.Provider_Label__c';
import INSTANCE_NAME from '@salesforce/schema/DAM_Provider_Instance_Request__c.Instance_Name__c';
import INSTANCE_KEY from '@salesforce/schema/DAM_Provider_Instance_Request__c.Instance_Key__c';
import IS_DEFAULT from '@salesforce/schema/DAM_Provider_Instance_Request__c.Is_Default__c';

export default class DamProviderInstanceForm extends LightningElement {
	@track providerLabel = '';
	@track instanceName = '';
	@track instanceKey = '';
	@track isDefault = false;
	submitting = false;

	handleChange(event) {
		const field = event.target.dataset.field;
		const value = event.target.value;
		if (field === 'Provider_Label__c') this.providerLabel = value;
		if (field === 'Instance_Name__c') this.instanceName = value;
		if (field === 'Instance_Key__c') this.instanceKey = value;
	}

	handleCheckbox(event) {
		this.isDefault = event.target.checked;
	}

	async handleSubmit() {
		if (this.submitting) return;
		const inputs = this.template.querySelectorAll('lightning-input');
		for (const input of inputs) {
			if (!input.reportValidity()) return;
		}
		this.submitting = true;
		try {
			const fields = {};
			fields[PROVIDER_LABEL.fieldApiName] = this.providerLabel;
			fields[INSTANCE_NAME.fieldApiName] = this.instanceName;
			fields[INSTANCE_KEY.fieldApiName] = this.instanceKey;
			fields[IS_DEFAULT.fieldApiName] = this.isDefault;
			const recordInput = { apiName: REQUEST_OBJECT.objectApiName, fields };
			const result = await createRecord(recordInput);
			this.dispatchEvent(new ShowToastEvent({ title: 'Submitted', message: `Request created: ${result.id}` , variant: 'success' }));
			this.providerLabel = '';
			this.instanceName = '';
			this.instanceKey = '';
			this.isDefault = false;
		} catch (e) {
			this.dispatchEvent(new ShowToastEvent({ title: 'Error', message: e?.body?.message || e.message, variant: 'error' }));
		} finally {
			this.submitting = false;
		}
	}
}
