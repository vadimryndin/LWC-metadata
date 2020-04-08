import { LightningElement, wire, track, api } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import getData from '@salesforce/apex/addDataToLWC.getData';
import retrieveMetadata from '@salesforce/apex/retrieveMetadata.retrieveMetadata';

export default class ShowMetadata extends LightningElement {

    fields = [];

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
        this.objectApiName = this.objectApiNameInputValue;
        this.layoutName = this.layoutNameInputValue;

        @wire(retrieveMetadata, { objectApiName: '$objectApiName' , layoutName: '$layoutName'});
            .then((result) => {
                this.fields = result;
                this.error = undefined;
            })
            .catch((error) => {
                this.error = error;
                this.fields = undefined;
            });
    }

  /*  @wire(getObjectInfo, { objectApiName: '$objectApiName' })
    objectInfo;
*/
 //   @wire(retrieveMetadata, { objectApiName: '$objectApiName' , layoutName: '$layoutName'} )
 //   objectInfo;

 /*   @wire(getData)
        wiredFields({ error, data }) {
            if (data) {
                this.fields = data;
                this.error = undefined;
            } else if (error) {
                this.error = error;
                this.fields = undefined;
            }
        } */
}