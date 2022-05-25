import { LightningElement, api, track, wire } from 'lwc';

export default class MenuCard extends LightningElement {
    @api product;
    @track amount = 0;

    @api
    sendCradData(){
        if(this.amount > 0){
            let tempOrderItem = { 'sobjectType': 'OrderItem__c' };
            tempOrderItem.Name = this.product.Name;
            tempOrderItem.Amount__c = this.amount;
            tempOrderItem.Price_Per_Unit__c = this.product.UnitPrice;
            tempOrderItem.Order_Price__c = (this.product.UnitPrice * this.amount);
            const event = new CustomEvent('dataresponce', {
                detail: tempOrderItem
            });
            this.dispatchEvent(event);
            return true;
        }
        return false;
    }

    @api
    clearCardData(){
        this.amount = 0;
    }

    amountPlus(){
        if(this.amount < 1000){
            this.amount = this.amount + 1;
        }
    }

    amountMinus(){
        if(this.amount > 0){
            this.amount = this.amount - 1;
        }
    }

}
