import { LightningElement, api, wire, track} from 'lwc';
import upgradeOrderStatus from '@salesforce/apex/CustomOrdersController.upgradeOrderStatus';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class PreviousOrdersTable extends NavigationMixin(LightningElement) {
    @api order;
    @api orderitems;
    @track correctOrderItems = this.selectCorrectOrderItems();
    error = false;

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
        }, 400);
        return temOrderItems;
    }

    handleUpgradeStatus() {
        upgradeOrderStatus({order : this.order})
            .then((result) => {
                this.showSuccess("Order Upgraded");
            })
            .catch((error) => {
                this.showError("Something went wrong...");
                this.error = true;
            })
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

}