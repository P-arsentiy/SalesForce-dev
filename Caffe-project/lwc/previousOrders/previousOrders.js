import { LightningElement, api, wire, track} from 'lwc';
import Id from '@salesforce/user/Id';
import getCustomOrdersByUser from '@salesforce/apex/CustomOrdersController.getCustomOrdersByUser';
import getOrderItemsByUser from '@salesforce/apex/CustomOrdersController.getOrderItemsByUser';

export default class PreviousOrders extends LightningElement {
    @track orders;
    @api userId = Id;
    @track orderItems;

    @wire(getCustomOrdersByUser, { userId: '$userId'})
    wiredOrder({ error, data }) {
        if (data) {
            this.orders = data;
            this.error = undefined;
        }
    }

    @wire(getOrderItemsByUser, { userId: '$userId'})
    wiredOrderItems({ data }) {
        if (data) {
            this.orderItems = data;
        }
    }



}