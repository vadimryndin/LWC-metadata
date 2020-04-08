import { LightningElement, wire, track, api } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import retrieveMetadata from '@salesforce/apex/retrieveMetadata.retrieveMetadata';

export default class ShowMetadata extends LightningElement {

    @api objectApiNameInputValue  = '';
    objectApiName;   
    @api layoutNameInputValue = '';
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
        this.objectApiName = this.objectApiNameInputValue;
        this.layoutName = this.layoutNameInputValue;
    }

  /*  @wire(getObjectInfo, { objectApiName: '$objectApiName' })
    objectInfo;
*/
    @wire(retrieveMetadata, { objectApiName: '$objectApiName' , layoutName: '$layoutName'} )
    objectInfo;
}