import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
export default class SiteFooter extends NavigationMixin(LightningElement) {
    navigateToHomePage() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Home'
            },
        });
    }
    navigateToOrderHistoryPage() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'PreviousOrders__c'
            },
        });
    }
    navigateToAboutPage() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'About__c'
            },
        });
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