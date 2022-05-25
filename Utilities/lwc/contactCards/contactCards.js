import { LightningElement, api, wire, track} from 'lwc';
import NAME_FIELD from '@salesforce/schema/Contact.FirstName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import { refreshApex } from '@salesforce/apex';
import getContacts from '@salesforce/apex/ContactController.getContacts';

const fields = [
    { label: 'Name', fieldName: NAME_FIELD.fieldApiName, type: 'text' },
    { label: 'Email', fieldName: EMAIL_FIELD.fieldApiName, type: 'text' },
    { label: 'Phone', fieldName: PHONE_FIELD.fieldApiName, type: 'text' }
];
// const fields = [
//     NAME_FIELD, EMAIL_FIELD, PHONE_FIELD
// ];
export default class ContactCards extends LightningElement {
    @api recordId;
    @track contacts;
    @track saved = false;


    @wire(getContacts, { recordId: '$recordId'})
    wiredContact({ error, data }) {
        if (data) {
            this.contacts = data;
            this.error = undefined;
        }
    }

    async handleContactSaved(evt) {
        refreshApex(this.wiredContact);
    }
}