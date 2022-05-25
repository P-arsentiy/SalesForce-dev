({
    validateNewRequest : function(component) {
        var validItem = true;

        // Name must not be blank
        var productNameField = component.find("productName");
        var productName = productNameField.get("v.value");
        if ($A.util.isEmpty(productName)){
            validItem = false;
            productNameField.setCustomValidity("Product Name can't be blank.");
        }
        else {
            productNameField.setCustomValidity("");
        }
        productNameField.reportValidity();
        
        // Quantity must not be blank
        var quantityField = component.find("shippingQuantity");
        var quantity = quantityField.get("v.value");
        if ($A.util.isEmpty(quantity) || quantity < 0){
            validItem = false;
            quantityField.setCustomValidity("Quantity can't be blank or below zero.");
        }
        else {
            quantityField.setCustomValidity("");
        }
        quantityField.reportValidity();
		// Price must not be blank
        var adressField = component.find("shippingAddress");
        var adress = adressField.get("v.value");
        if ($A.util.isEmpty(adress)){
            validItem = false;
            adressField.setCustomValidity("Shipping Address can't be blank.");
        }
        else {
            adressField.setCustomValidity("");
        }
        adressField.reportValidity();

        var shippingNameField = component.find("shippingName");
        var shippingName = shippingNameField.get("v.value");
        if ($A.util.isEmpty(shippingName)){
            validItem = false;
            shippingNameField.setCustomValidity("Shipping Name can't be blank.");
        }
        else {
            shippingNameField.setCustomValidity("");
        }
        shippingNameField.reportValidity();

            return (validItem);


    },
    createNewRequest : function(component, newRequest){
        var action = component.get("c.saveNewRequest");
        action.setParams({ newRequest : newRequest });
        component.set("v.isLoaded", true);
        //alert("trying to get response state");
        action.setCallback(this, function(response){
            let state = response.getState();
            //alert("Response state: " + state);
            component.set("v.isLoaded", false);
            var returnValue = response.getReturnValue();
	    		if(state === "SUCCESS"){
                    if(returnValue === 201){
                        this.showToast(component, "success", "The rquest has been send successfully.");
                        $A.get("e.force:closeQuickAction").fire() 
                    } else {
                        this.showToast(component, "warning", "Something went wrong... error code: " + returnValue);
                    }
	    		} else {
	    			let errors = response.getError();
	    			if(errors){
	    				if(errors[0] && errors[0].message){
	    					console.log("Error message: " + errors[0].message);
	    				}
	    			}
                    this.showToast(component, "error", "The rquest has been failed.");
	    		}
                
        });
        $A.enqueueAction(action);
    },

    showToast : function(component, status, text){
        var toastEvent = $A.get("e.force:showToast");
        switch (status){
            case 'success':
            toastEvent.setParams({
                        mode: 'dismissible',
                        type: 'success',
                        "title": "Success!",
                        "message": text
                    });
            break;
            case 'error':
            toastEvent.setParams({
                        mode: 'dismissible',
                        type: 'error',
                        "title": "Error!",
                        "message": text
                    });
            break;
            case 'warning':
            toastEvent.setParams({
                        mode: 'dismissible',
                        type: 'warning',
                        "title": "Warning!",
                        "message": text
                    });
            break;
        }
        toastEvent.fire();
    }

})
