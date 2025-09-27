import { LightningElement, track, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import deleteInstance from '@salesforce/apex/DamProviderInstanceAdmin.deleteInstance';
import listCreatedInstances from '@salesforce/apex/DamProviderInstanceAdmin.listCreatedInstances';
import listProviderInstances from '@salesforce/apex/DamProviderInstanceAdmin.listProviderInstances';

export default class DamProviderInstanceDelete extends LightningElement {
	@track providerInstanceId = '';
	@track confirmId = '';
	@track ack = false;
	@track instanceOptions = [];
	providerLabel = 'Unsplash';
	submitting = false;

	handleChange(event) {
		this.providerInstanceId = event.target.value;
	}

	_wiredCreated;
	@wire(listCreatedInstances)
	wiredInstances(value) {
		this._wiredCreated = value;
		const { data } = value || {};
		// Only use fallback object list if we don't have live data
		if (data && (!this._wiredLive || !this._wiredLive.data || !this._wiredLive.data.length)) {
			this.instanceOptions = data.map(d => ({ label: d.label, value: d.id }));
		}
	}

	_wiredLive;
	@wire(listProviderInstances, { providerLabel: '$providerLabel' })
	wiredLive(value) {
		this._wiredLive = value;
		const { data } = value || {};
		if (data && data.length) {
			this.instanceOptions = data.map(pi => ({ label: `${pi.name} (${pi.providerLabel})${pi.isDefault ? ' [Default]' : ''}`, value: pi.id }));
		}
	}

	async reloadOptions() {
		try {
			const data = await listProviderInstances({ providerLabel: this.providerLabel });
			this.instanceOptions = (data || []).map(pi => ({ label: `${pi.name} (${pi.providerLabel})${pi.isDefault ? ' [Default]' : ''}`, value: pi.id }));
		} catch (e) {
			// ignore
		}
	}

	handlePick(event) {
		this.providerInstanceId = event.detail.value;
		this.confirmId = event.detail.value;
	}

	handleConfirmChange(event) {
		this.confirmId = event.target.value;
	}

	handleAck(event) {
		this.ack = event.target.checked;
	}

	get disableDelete() {
		return this.submitting || !this.ack || !this.providerInstanceId || this.providerInstanceId !== this.confirmId;
	}

	async handleDelete() {
		if (this.submitting) return;
		const inputs = this.template.querySelectorAll('lightning-input');
		for (const input of inputs) {
			if (!input.reportValidity()) return;
		}
		this.submitting = true;
		try {
			await deleteInstance({ providerInstanceId: this.providerInstanceId });
			this.dispatchEvent(new ShowToastEvent({ title: 'Deleted', message: 'Provider instance deleted successfully', variant: 'success' }));
			this.providerInstanceId = '';
			this.confirmId = '';
			this.ack = false;
			// Refresh wired data sources to update the picklist
			try { await refreshApex(this._wiredLive); } catch (e) {}
			try { await refreshApex(this._wiredCreated); } catch (e) {}
			// Small delay to allow backend to reflect deletion, then imperatively reload
			await new Promise(r => setTimeout(r, 500));
			await this.reloadOptions();
		} catch (e) {
			this.dispatchEvent(new ShowToastEvent({ title: 'Error', message: e?.body?.message || e.message, variant: 'error' }));
		} finally {
			this.submitting = false;
		}
	}
}
