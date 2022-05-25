import { LightningElement, api, wire, track} from 'lwc';
import Id from '@salesforce/user/Id';
import getCustomOrdersByStatus from '@salesforce/apex/CustomOrdersController.getCustomOrdersByStatus';
import getOrderItemsByStatus from '@salesforce/apex/CustomOrdersController.getOrderItemsByStatus';

export default class PreviousOrders extends LightningElement {
    @api userId = Id;
    @api menuType;
    @track orders;
    @track orderitems;

    @wire(getCustomOrdersByStatus, { status: '$menuType' })
    wiredOrder({ error, data }) {
        if (data) {
            this.orders = data;
            this.error = undefined;
        }
    }

    @wire(getOrderItemsByStatus, { status: '$menuType' })
    wiredOrderItems({ data }) {
        if (data) {
            this.orderitems = data;
        }
    }



}