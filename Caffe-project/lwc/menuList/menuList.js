import { LightningElement, api, wire, track} from 'lwc';
import Id from '@salesforce/user/Id';
import getPricebookEntries from '@salesforce/apex/ProductsController.getPricebookEntries';
import createOrder from '@salesforce/apex/CustomOrdersController.createOrder';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class MenuList extends NavigationMixin(LightningElement) {
    @track products;
    @track isModalOpen = false;
    @api userId = Id;
    @track orderItemsData = [];
    @track orderToCreate = { 'sobjectType': 'CustomOrder__c' };
    orderTotalPrice = 0;
    requiredDateTime = false;
    @track agreement = false;
    error = false;

    @wire(getPricebookEntries)
    wiredProduct({ error, data }) {
        if (data) {
            this.products = data;
            this.error = undefined;
        }
    }


    get nowPlusThirty() {
        let nowPlusThirty = new Date();
        nowPlusThirty.setMinutes(nowPlusThirty.getMinutes() + 30);
        nowPlusThirty = new Date(nowPlusThirty);
        return nowPlusThirty;
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
        this.collectCardsData();
    }
    closeModal() {
       this.isModalOpen = false;
       this.agreement = false;
       this.orderItemsData = [];
       this.orderTotalPrice = 0;
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
            this.orderToCreate.Customer__c = this.userId;
            this.orderToCreate.Status__c = 'Accepted';
            createOrder({order : this.orderToCreate, orderItems: this.orderItemsData})
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

    clearCardsData(){
        let menuCards = this.template.querySelectorAll('c-menu-card');
        menuCards.forEach(element => {
            element.clearCardData();
        });
        this.orderToCreate.OrderCompletionTime__c = null;
        this.orderToCreate.EmailWhenReady__c = null;
        this.orderToCreate.Description__c = false;
        this.agreement = false;
        this.requiredDateTime = false;
        this.error = false;
        this.closeModal();
    }

    handleCollectData(event){
        const orderItem = event.detail;
        this.orderItemsData.push(orderItem);
        this.orderTotalPrice = this.orderTotalPrice + orderItem.Order_Price__c;
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

    collectCardsData(){
        let menuCards = this.template.querySelectorAll('c-menu-card');
        menuCards.forEach(element => {
            element.sendCradData();
        });
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