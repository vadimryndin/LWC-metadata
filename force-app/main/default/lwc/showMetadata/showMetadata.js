import { LightningElement, wire, track, api } from 'lwc';
import retrieveMetadata from '@salesforce/apex/retrieveMetadata.retrieveMetadata';

export default class ShowMetadata extends LightningElement {

    @track fields;
    @track error;

    @api objectApiNameInputValue  = 'Contact';
    objectApiName;   
    @api layoutNameInputValue = 'Contact-Contact Layout';
    layoutName;

    handleChange(event) {
        if (event.target.label === 'Object Name') {
            this.objectApiNameInputValue  = event.target.value;
        }
        if (event.target.label === 'Layout Name') {
            this.layoutNameInputValue = event.target.value;
        }
    }

    handleClick() {

        retrieveMetadata({ objectApiName: this.objectApiNameInputValue , layoutName: this.layoutNameInputValue})
            .then(result => {
                this.fields = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.fields = undefined;
            });
    }
}