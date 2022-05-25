import { LightningElement, api, wire, track} from 'lwc';
import createOrder from '@salesforce/apex/CustomOrdersController.createOrder';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class PreviousOrdersTable extends NavigationMixin(LightningElement) {
    @api order;
    @api orderitems;
    @track correctOrderItems = this.selectCorrectOrderItems();
    @track isModalOpen = false;
    @track orderToCreate = { 'sobjectType': 'CustomOrder__c' };
    requiredDateTime = false;
    @track agreement = false;
    error = false;

    get nowPlusThirty() {
        let nowPlusThirty = new Date();
        nowPlusThirty.setMinutes(nowPlusThirty.getMinutes() + 30);
        nowPlusThirty = new Date(nowPlusThirty);
        return nowPlusThirty;
    }

    selectCorrectOrderItems(){
        let temOrderItems = [];
        setTimeout(() => {
            for(let orderItem of this.orderitems){
                if(orderItem.Order__c === this.order.Id){
                    let tempOrderItem = { 'sobjectType': 'OrderItem__c' };
                    tempOrderItem.Name = orderItem.Name;
                    tempOrderItem.Amount__c = orderItem.Amount__c;
                    tempOrderItem.Price_Per_Unit__c = orderItem.Price_Per_Unit__c;
                    tempOrderItem.Order_Price__c = orderItem.Order_Price__c;
                    temOrderItems.push(tempOrderItem);
                }
            }
        this.orderitems = [];
        }, 300);
        return temOrderItems;
    }

    @track columns = [
        { label: 'Name', fieldName: 'Name', type: 'text',
        cellAttributes: { alignment: 'center' }, },
        { label: 'Price', fieldName: 'Price_Per_Unit__c', type: 'currency',
        cellAttributes: { alignment: 'center' }, },
        { label: 'Amount', fieldName: 'Amount__c', type: 'number',
        cellAttributes: { alignment: 'center' }, },
        { label: 'TotalPrice', fieldName: 'Order_Price__c', type: 'currency',
        cellAttributes: { alignment: 'center' } }
    ];

    openModal() {
        this.isModalOpen = true;
    }
    closeModal() {
       this.isModalOpen = false;
       this.agreement = false;
    }
    handleDateTime(event){
        this.orderToCreate.OrderCompletionTime__c = event.target.value;
        this.requiredDateTime = true;
    }
    handleEmailWhenReady(event){
        this.orderToCreate.EmailWhenReady__c = event.target.checked;
    }
    handleComment(event){
        this.orderToCreate.Description__c = event.target.value;
    }
    handleAgreement(event){
        this.agreement = event.target.checked;
    }

    handleSubmit() {
        if(this.checkIfOrderCompleted()){
            this.orderToCreate.Customer__c = this.order.Customer__c;
            this.orderToCreate.Status__c = 'Accepted';
            createOrder({order : this.orderToCreate, orderItems: this.correctOrderItems})
            .then((result) => {
                this.showSuccess("Order Accepted!");
                this.clearCardsData();
            })
            .catch((error) => {
                this.showError("Invalid Time. Try Again");
                this.error = true;
            })
        }
    }

    checkIfOrderCompleted(){
        if(this.agreement === false){
            this.showWarning("Please, check that you agree of terms of service");
            return false;
        } else if (this.requiredDateTime === false){
            this.showWarning("Please fill in the field with the date and time");
            return false;
        } else {
            return true;
        }
    }

    clearCardsData(){
        this.orderToCreate.OrderCompletionTime__c = null;
        this.orderToCreate.EmailWhenReady__c = null;
        this.orderToCreate.Description__c = false;
        this.requiredDateTime = false;
        this.error = false;
        this.closeModal();
    }

    showSuccess(msg){
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: msg,
                variant: 'success'
            })
        );
    }
    showError(msg){
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: msg,
                variant: 'error'
            })
        );
    }
    showWarning(msg){
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Warning',
                message: msg,
                variant: 'warning'
            })
        );
    }
    navigateToTermsPage() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Terms__c'
            },
        });
    }

}