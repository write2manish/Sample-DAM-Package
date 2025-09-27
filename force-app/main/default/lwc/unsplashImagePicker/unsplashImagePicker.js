// UnsplashImagePicker
import { LightningElement, api, track } from 'lwc';
import getAssets from '@salesforce/apex/MyUnsplashAssetsController.getAssets';



export default class UnsplashImagePicker extends LightningElement {
    @api title = 'Assets';

    _context;

    @api 
    get context() {
        return this._context;
    }

    set context(val) {
        this._context = val;
        console.log('context changed to Instancekey: '+ val.instanceKey);
        getAssets({  instanceKey: val.instanceKey, mediaType: val.mediaType })
               .then(result => {
                   this.assets = result;
                   console.log(' ----- getAssets returned result:   ---- ');
                   console.log(result);
               })
               .catch(error => {
                   this.error = error;
                   console.log(' ----- getAssets returned error:   ---- ');
                   console.log(error);
               });
    }

    @track selectedCollection = 'fall-2024';
    @track searchTerm = '';
    @track assets = [];
    @track collections = [
        { value: 'fall-2024', label: 'Fall 2024', description: 'Fall collection 2024' },
        {
            value: 'winter-2024',
            label: 'Winter 2024',
            description: 'Winter collection 2024',
        },
        {
            value: 'spring-2025',
            label: 'Spring 2025',
            description: 'Spring collection 2025',
        },
    ];
    
    connectedCallback() {
    }

    get isImageMediaType() {
        return this.context && this.context.mediaType === 'IMAGE';
    }

    get isVideoMediaType() {
        return this.context && this.context.mediaType === 'VIDEO';
    }

    get isAudioMediaType() {
        return this.context && this.context.mediaType === 'AUDIO';
    }

    handleSearch(event) {
        this.searchTerm = event.target.value;
        // Implement search functionality here
    }

    handleCollectionChange(event) {
        this.selectedCollection = event.detail.value;
        // Implement collection filtering here
    }

    handleAssetClick({ currentTarget: { dataset } }) {
        // Implement selection handling here
        
        // Dispatch event with selected asset
        const {id, altText, title, url, urlName } = this.assets.find(({ id }) => id === dataset.id);

        this.dispatchEvent(new CustomEvent('assetselected', {
            detail:  {
                url,
                contentInfo: {
                    altText,
                    externalId: id,
                    title,
                    urlName
                }
            }
        }));
    }
}