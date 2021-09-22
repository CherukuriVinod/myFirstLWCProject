import { LightningElement, wire } from "lwc";
import getProducts from "@salesforce/apex/ProductController.getProducts";

import { publish, MessageContext } from "lightning/messageService";
import PRODUCT_SELECTED_MESSAGE from "@salesforce/messageChannel/ProductSelected__c";

export default class DisplayProducts extends LightningElement {
  searchKey = "";

  //Load the list of available products.
  @wire(getProducts, { searchKey: "$searchKey" })
  products;

  //Load context for Lightning Messaging Service
  @wire(MessageContext) messageContext;

  //Publish ProductsSelected message
  handleProductSelected(event) {
    publish(this.messageContext, PRODUCT_SELECTED_MESSAGE, {
      productId: event.detail
    });
  }

  handleSearchKeyChange(event) {
    this.searchKey = event.target.value.toLowerCase();
  }
}
