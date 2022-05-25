import { LightningElement, api, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
export default class ContactCardItem extends LightningElement {
    //objectApiName = CONTACT_OBJECT.objectApiName;
    @api contact;
    //fields = CONTACT_OBJECT;
    fields = [FIRSTNAME_FIELD, LASTNAME_FIELD, EMAIL_FIELD];
    @track isModalOpen = false;

    openModal() {
        this.isModalOpen = true;
    }
    closeModal(evt) {
       this.isModalOpen = false;
    }


    handleSubmit(evt) {
        this.isModalOpen = false;
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Record updated!',
                variant: 'success'
            })
        );
        const event = new CustomEvent('contactsaved', {
            detail: true
        });
        this.dispatchEvent(event);
   }

   
}
